import 'package:flutter/material.dart';
import 'package:tool_rental_app/HomeScreen/HomeScreen_Components/CategoryCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var category_titles = <String>[
    "Hand Tools",
    "power accessories",
    "welding tools",
    "wood working",
    "electric tools"
  ];
  var assets = [
    "assets/hammer.png",
    "assets/power.png",
    "assets/welding.png",
    "assets/chainsaw.png",
    "assets/electronics.png"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("SmartToolRent"),
        centerTitle: true,
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(color: Colors.black45, fontSize: 20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
            crossAxisCount: 2,
            children: List.generate(
                5,
                (index) => CategoryCard(
                    title: category_titles[index],
                    assetName: assets[index],))),
      ),
    );
  }
}
