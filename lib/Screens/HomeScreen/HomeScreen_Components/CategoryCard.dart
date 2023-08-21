import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../ToolScreens/electric_tools.dart';
import '../../ToolScreens/hand_tools.dart';
import '../../ToolScreens/power_accessories.dart';
import '../../ToolScreens/welding_tools.dart';
import '../../ToolScreens/wood_working.dart';

class CategoryCard extends StatelessWidget {
  CategoryCard({super.key, required this.title, required this.assetName});
  final String title;
  final String assetName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        debugPrint("$title is clicked");
        FirebaseAuth _auth = FirebaseAuth.instance;

        // Get the currently signed-in user
        User? user = _auth.currentUser;
        String userEmail = user?.email ?? "Email not available";

        if (title == 'Hand Tools') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HandTools(),
            ),
          );
        } else if (title == 'Power Accessories') {
          // Replace 'Power Accessories' with the correct title if needed
          // Navigate to the respective screen for power accessories
          Navigator.push(context, MaterialPageRoute(builder: (context) => PowerAccessories()));
        } else if (title == 'Welding Tools') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WeldingTools(),
            ),
          );
        } else if (title == 'Wood Working') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WoodWorking(),
            ),
          );
        } else if (title == 'Electric Tools') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ElectricTools(),
            ),
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.grey,
        color: Colors.orange, // Set the card color to orange
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              child: CircleAvatar(
                radius: 50, // Adjust the radius for the circle avatar
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(assetName),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set the text color to white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
