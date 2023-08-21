import 'dart:io';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Widgets/utils.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final postController = TextEditingController();
  final postController1 = TextEditingController();
  final postController2 = TextEditingController();
  final postController3 = TextEditingController();
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  String selectedCategory = "Hand Tools";
  List<String> categories = [
    "Hand Tools",
    "Power Accessories",
    "Welding Tools",
    "Wood Working",
    "Electric Tools",
  ];

  String suggestedPrice1 = '';
  String suggestedPrice2 = '';
  String suggestedPrice3 = '';

  FocusNode priceFocusNode = FocusNode();

  @override
  void dispose() {
    priceFocusNode.dispose();
    super.dispose();
  }

  Future getGalleryImage() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print("No Image Picked");
      }
    });
  }

  String formatPrice(String input) {
    if (input.isEmpty) {
      return "\$0";
    } else {
      return "\$" + input;
    }
  }

  void updateSuggestedPrices(String toolName, {bool clearSuggestions = false}) {
    toolName = toolName.toLowerCase();
    if (clearSuggestions) {
      setState(() {
        suggestedPrice1 = '';
        suggestedPrice2 = '';
        suggestedPrice3 = '';
      });
    } else if (toolKeywords.contains(toolName)) {
      setState(() {
        suggestedPrice1 = "\$${(Random().nextInt(50) + 10)}";
        suggestedPrice2 = "\$${(Random().nextInt(50) + 10)}";
        suggestedPrice3 = "\$${(Random().nextInt(50) + 10)}";
      });
    } else {
      setState(() {
        suggestedPrice1 = 'No suggestion for this tool';
        suggestedPrice2 = '';
        suggestedPrice3 = '';
      });
    }
  }

  Future<void> uploadData() async {
    setState(() {
      loading = true;
    });

    try {
      int date = DateTime.now().millisecondsSinceEpoch;
      firebase_storage.Reference ref =
      firebase_storage.FirebaseStorage.instance.ref('/Images$date');
      UploadTask uploadTask = ref.putFile(_image!.absolute);
      await Future.value(uploadTask);
      User? user = _auth.currentUser;
      var newUrl = await ref.getDownloadURL();
      var price = formatPrice(postController2.text.toString());

      // Generate a random rating based on price
      int priceValue = int.tryParse(postController2.text) ?? 0;
      int rating = 5;
      if (priceValue < 30) {
        rating = 5;
      } else if (priceValue < 50) {
        rating = 4;
      } else if (priceValue < 70) {
        rating = 3;
      } else if (priceValue < 90) {
        rating = 2;
      } else if (priceValue < 110) {
        rating = 1;
      } else {
        rating = 0;
      }

      DatabaseReference database = FirebaseDatabase.instance
          .ref('Tools Rented')
          .child(selectedCategory)
          .child(date.toString());
      database.set({
        'tool name': postController.text.toString(),
        'category': selectedCategory,
        'price': price,
        'description': postController3.text.toString(),
        'id': user?.uid,
        'image': newUrl.toString(),
        'time': date.toString(),
        'rating': rating, // Set the calculated rating
      }).then((value) {
        Utils().toastMessage('Tool Rented');
      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
      });
    } catch (e) {
      Utils().toastMessage(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                "Rent a Tool",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 25,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  getGalleryImage();
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                    ),
                  ),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : Center(child: Icon(Icons.image_rounded)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: postController,
                decoration: InputDecoration(
                  labelText: 'Tool Name',
                  hintText: 'Enter Tool Name',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                onChanged: (toolName) {
                  updateSuggestedPrices(toolName);
                  setState(() {});
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
                items: categories.map((category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Tools Category',
                  border: OutlineInputBorder(),
                ),
              ),
              if (suggestedPrice1.isNotEmpty && priceFocusNode.hasFocus)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Suggested Prices: $suggestedPrice1, $suggestedPrice2, $suggestedPrice3',
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: postController2,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                onTap: () {
                  updateSuggestedPrices(postController.text);
                },
                decoration: InputDecoration(
                  labelText: 'Price',
                  hintText: 'Enter Price Per Day',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: postController3,
                maxLines: 4,
                onTap: () {
                  updateSuggestedPrices(postController.text, clearSuggestions: true);
                },
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Enter the Description',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: uploadData,
                child: loading ? CircularProgressIndicator() : Text('Rent The Tool'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<String> toolKeywords = [
  'hammer',
  'needle',
  'tape',
  'pliers',
  'screwdriver',
  'handsaw',
  'wrench',
  'chisel',
  'spirit level',
  'saw',
  'mallet',
  'utility knife',
  'axe',
  'clamp',
  'claw hammer',
  'file',
  'shovel',
  'hacksaw',
  'coping saw',
  'scissors',
  'crowbar',
  'hoe',
  'hex key',
  'adjustable spanner',
  'spanner',
  'Air compressor',
  'Alligator shear',
  'Angle grinder',
  'Bandsaw',
  'Belt sander',
  'Biscuit joiner',
  'Ceramic tile cutter',
  'Chainsaw',
  'Circular saw',
  'Concrete mixer',
  'Concrete saw',
  'Cold saw',
  'Crusher',
  'Diamond blade',
  'Diamond tool',
  'Die grinder',
  'Disc cutter',
  'Disc sander',
  'Drill',
  'Floor sander',
  'Food processor',
  'Grinding machine',
  'Heat gun',
  'Hedge trimmer',
  'Impact driver',
  'Impact wrench',
  'Iron',
  'Jackhammer',
  'Jointer',
  'Jigsaw',
  'Knitting machine',
  'Lathe',
  'Lawn mower',
  'Leaf blower',
  'Miter saw',
  'Multi-tool',
  'Nail gun (electric and battery as well as powder actuated)',
  'Needlegun scaler',
  'Pneumatic torque wrench',
  'Powder-actuated tools',
  'Power wrench',
  'Pressure washer',
  'Radial arm saw',
  'Random orbital sander',
  'Reciprocating saw',
  'Rotary saw',
  'Rotary tool',
  'Rotary tiller',
  'Sabre saw',
  'Sander',
  'Scrollsaw',
  'Sewing machine',
  'Snow blower',
  'Steel cut off saw',
  'String trimmer',
  'Table saw',
  'Thickness planer',
  'Wall chaser',
  'Washing machine',
  'Wood router',
  "Welding Helmet",
  "Welding Gloves",
  "Welding Jacket",
  "Welding Goggles",
  "Welding Electrodes",
  "Welding Wire",
  "Welding Machine",
  "Welding Clamp",
  "Welding Chipping Hammer",
  "Welding Pliers",
  "Welding Magnet",
  "Welding Apron",
  "Welding Table",
  "Welding Curtain",
  "Welding Rod",
  "Air Compressor",
  "Bench Grinder",
  "Circular Saw",
  "Drill Press",
  "Floor Sander",
  "Grinding Wheel",
  "Jigsaw",
  "Lathe Machine",
  "Miter Saw",
  "Nail Gun",
  "Oscillating Multi-Tool",
  "Paint Sprayer",
  "Router",
  "Soldering Iron",
  "Table Saw",
  "Chisel",
  "Mallet",
  "Wood Plane",
  "Spokeshave",
  "Saw",
  "Coping Saw",
  "Jigsaw",
  "Band Saw",
  "Circular Saw",
  "Table Saw",
  "Scroll Saw",
  "Router",
  "Wood Router",
  "Router Table",
  "Biscuit Joiner",
  "Dovetail Jig",
  "Miter Saw",
  "Compound Miter Saw",
  "Crosscut Saw",
  "Rip Saw",
  "Backsaw",
  "Block Plane",
  "Framing Square",
  "Clamp",
  "Hammer",
  "Wood Glue",
  "Screwdriver",
  "Brad Nailer",
  "Staple Gun",
  "Electric Drill",
  "Power Saw",
  "Angle Grinder",
  "Circular Saw",
  "Jigsaw",
  "Reciprocating Saw",
  "Electric Screwdriver",
  "Impact Driver",
  "Rotary Tool",
  "Biscuit Joiner",
  "Power Planer",
  "Router",
  "Heat Gun",
  "Electric Sander",
  "Electric Staple Gun",
  "Electric Nail Gun",
  "Electric Chainsaw",
  "Electric Hedge Trimmer",
  "Power Mixer",
  "Soldering Iron",
  "Soldering Station",
  "Cordless Phone",
  "Battery Charger",
  "Electric Lawn Mower",
  "Electric Leaf Blower",
  "Electric Edger",
  "Electric Weed Eater",
  "Electric Pressure Washer",
  "Electric String Trimmer",
  "Electric Tiller",
];