import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import '../../product_screen.dart';
import '../Posts/add_posts.dart';
import '../ProfileScreen/basic_screen.dart';

class PowerAccessories extends StatefulWidget {
  const PowerAccessories({Key? key}) : super(key: key);

  @override
  State<PowerAccessories> createState() => _PowerAccessories();
}

class _PowerAccessories extends State<PowerAccessories> {
  final searchFilter = TextEditingController();
  List<String> catList = [
    'All',
  ];
  final dbRef = FirebaseDatabase.instance.ref().child('Tools Rented');

  List<String> cartItems = [];
  int cartItemCount = 0;
  bool showCartItems = false;

  @override
  void initState() {
    super.initState();
    cartItemCount = 0;
    showCartItems = false;
  }

  void removeFromCart(String item) {
    setState(() {
      cartItems.remove(item);
      cartItemCount = cartItems.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff9fafc),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                        color: Color(0xfff7f8fa),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextFormField(
                        controller: searchFilter,
                        decoration: InputDecoration(
                            labelText: "Find Your Product",
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search_outlined,
                              size: 30,
                              color: Colors.grey,
                            )),
                        onChanged: (String value) {},
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Color(0xfff7f8fa),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.notifications_none_outlined,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 25, top: 20),
                alignment: Alignment.center,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/cover.jpg',
                    width: MediaQuery.of(context).size.width / 1.2,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      for (int i = 0; i < catList.length; i++)
                        Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                          decoration: BoxDecoration(
                              color: catList[i] == "All"
                                  ? Color(0xfffd725a)
                                  : Color(0xfff7f8fa),
                              borderRadius: BorderRadius.circular(18)),
                          child: Text(
                            catList[i],
                            style: TextStyle(
                              fontSize: 14,
                              color: catList[i] == "All"
                                  ? Colors.white
                                  : Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: showCartItems
                    ? ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(cartItems[index]),
                    );
                  },
                )
                    : FirebaseAnimatedList(
                  query: dbRef.child('Power Accessories').orderByChild('price').limitToFirst(10),
                  itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                    final data = snapshot.value as Map<dynamic, dynamic>?;

                    if (data == null) {
                      return Container();
                    }
                    final title = data['tool name']?.toString() ?? 'N/A';
                    final category = data['category']?.toString() ?? 'N/A';
                    final price = data['price']?.toString() ?? 'N/A';
                    final description = data['description']?.toString() ?? 'N/A';
                    final image = data['image']?.toString() ?? 'N/A';
                    final rating = data['rating'] as int?;

                    if (searchFilter.text.isEmpty || (title?.toLowerCase() ?? '').contains(searchFilter.text.toLowerCase())) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProductScreen(
                                title: title,
                                category: category,
                                price: price,
                                description: description,
                                image: image,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  ),
                                  child: FadeInImage.assetNetwork(
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 150,
                                    placeholder: 'assets/power.png',
                                    image: image,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "${price}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        "Rating: ${rating ?? 'N/A'}",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        description,
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          setState(() {
                                            cartItems.add(title);
                                            cartItemCount = cartItems.length;
                                          });
                                        },
                                        child: Text('Add to Cart'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: Color(0xfffd725a),
        unselectedItemColor: Colors.grey,
        currentIndex: showCartItems ? 1 : 0,
        onTap: (index) {
          if (index == 1) {
            setState(() {
              showCartItems = true;
            });
          } else {
            setState(() {
              showCartItems = false;
            });
          }
          if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => BasicScreen()));
          }
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.shopping_cart),
                cartItemCount > 0
                    ? Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : Container(),
              ],
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xfffd725a),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPostScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}