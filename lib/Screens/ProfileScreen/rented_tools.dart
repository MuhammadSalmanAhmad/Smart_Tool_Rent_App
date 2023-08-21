import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../../product_screen.dart';

class RentedTools extends StatelessWidget {
  final dbRef = FirebaseDatabase.instance.ref().child('Tools Rented');
  final searchFilter = TextEditingController();
  String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rented Tools"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: FirebaseAnimatedList(
                query: dbRef.child('Hand Tools').orderByChild('id').equalTo(
                    currentUserId), // Update 'user_id' to the actual field name in your database
                itemBuilder: (BuildContext context, DataSnapshot snapshot,
                    Animation<double> animation, int index) {
                  final title = snapshot.child('tool name').value.toString();
                  final category = snapshot.child('category').value.toString();
                  final price = snapshot.child('price').value.toString();
                  final description =
                      snapshot.child('description').value.toString();
                  final image = snapshot.child('image').value.toString();

                  if (searchFilter.text.isEmpty ||
                      title
                          .toLowerCase()
                          .contains(searchFilter.text.toLowerCase())) {
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
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
                                  image:
                                      snapshot.child('image').value.toString(),
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
                                      description,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
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
            )
          ],
        ),
      ),
    );
  }
}
