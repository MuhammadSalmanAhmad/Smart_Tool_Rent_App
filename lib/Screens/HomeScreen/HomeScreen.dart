import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../PaymentMethod/paymen_method.dart';
import 'HomeScreen_Components/CategoryCard.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Index of the selected tab

  var categoryTitles = <String>[
    "Hand Tools",
    "Power Accessories",
    "Welding Tools",
    "Wood Working",
    "Electric Tools"
  ];
  var assets = [
    "assets/hammer.png",
    "assets/power.png",
    "assets/welding.png",
    "assets/chainsaw.png",
    "assets/electronics.png"
  ];

  void signOut() {
    // Implement your sign out logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Smart Tool Rent"),
        actions: [
          IconButton(onPressed: signOut, icon: Icon(Icons.logout_rounded))
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black45, fontSize: 20),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          // Home Screen
          GridView.count(
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(
              5,
                  (index) => CategoryCard(
                title: categoryTitles[index],
                assetName: assets[index],
              ),
            ),
          ),
          // Search Screen (Replace with your own widget)
          Center(child: Text("Search Screen")),
          // Profile Screen (Replace with your own widget)
          Center(child: Text("Profile Screen")),
        ],
      ),
    );
  }
}

// Rest of the code remains the same
