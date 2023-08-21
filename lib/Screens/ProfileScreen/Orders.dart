import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(
        child: Text("No user logged in."),
      );
    }

    DatabaseReference ordersRef = FirebaseDatabase.instance.reference().child('Orders').child(user.uid);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("My Orders"),
      ),
    );
  }
}
