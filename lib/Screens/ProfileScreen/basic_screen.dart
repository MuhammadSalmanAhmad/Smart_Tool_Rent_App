import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tool_rental_app/Screens/ProfileScreen/Orders.dart';
import 'package:tool_rental_app/Screens/ProfileScreen/profile_settings.dart';
import 'package:tool_rental_app/Screens/ProfileScreen/rented_tools.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';

class BasicScreen extends StatelessWidget {
  Future<void> _launchPlayStore() async {
    final androidAppId = "com.example.tool_rental_app"; // Replace with your Android app ID
    final playStoreUrl = 'https://play.google.com/store/apps/details?id=$androidAppId';

    if (await canLaunchUrl(playStoreUrl as Uri)) {
      await launchUrl(playStoreUrl as Uri);
    } else {
      // Handle the case where the Play Store URL can't be launched
      print("App not available on Play Store");
    }
  }
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LaunchScreen()),
      );
    } catch (e) {
      print("Error logging out: $e");
      // Handle error (display a snackbar or alert)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",),
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(150),
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Image.asset("assets/logo.png",
                      fit: BoxFit.cover,),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Text("Smart Tool Rent", style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: 28, color: Colors.black,
            ),),
            SizedBox(height: 30,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileSettings()));
              },
              child: Container(
                height: 35,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.account_circle,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Profile Settings",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> RentedTools()));
              },
              child: Container(
                height: 35,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.pan_tool_sharp,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Rented Tools",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 35,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade300,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.reviews_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                  ),
                  Text(
                    "Reviews",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              height: 35,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade300,
              ),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Orders()));
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Your Orders",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                _launchPlayStore;
              },
              child: Container(
                height: 35,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.star,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Rate Us",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: ()=> _logout(context),
              child: Container(
                height: 35,
                width: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey.shade300,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.logout_outlined,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                    Text(
                      "Log Out",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
