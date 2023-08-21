import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../Posts/add_posts.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  List catList = [
    'All',
    'Hand Tools',
    'Power Accessories',
    'Welding Tools',
    'Wood Working',
    'Electric Tools'
  ];

  @override
  Widget build(BuildContext context) {

    final dbRef = FirebaseDatabase.instance.ref().child('Tools Rented');

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
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

                          decoration: InputDecoration(
                              label: Text("Find Your Porduct"),
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search_outlined,
                                size: 30,
                                color: Colors.grey,
                              )),

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
                FirebaseAnimatedList(
                    query: dbRef.child('Hand Tools'),
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {

                      return Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              color: Color.fromARGB(225, 224, 244, 244),
                              child: Stack(
                                children: [
                                  InkWell(
                                    onTap: (){},
                                      child: FadeInImage.assetNetwork(
                                          fit: BoxFit.cover,
                                          height: 230,
                                          width: 100,
                                          placeholder: 'assets/power.png',
                                          image: snapshot.child('image').value.toString()),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 30,
        selectedItemColor: Color(0xfffd725a),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index){},
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: 'Profile'),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterDocked,
    );
  }
}
