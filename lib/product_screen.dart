import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tool_rental_app/Screens/PaymentMethod/paymen_method.dart';
import 'package:tool_rental_app/Screens/ProfileScreen/review.dart';
import 'Widgets/bottom_sheet.dart';
import 'package:intl/intl.dart';

class ReviewData {
  final double rating;
  final String review;
  final String date;
  final String userName;

  ReviewData({
    required this.rating,
    required this.review,
    required this.date,
    required this.userName,
  });
}

class UserReviewData {
  final double rating;
  final String review;
  final String date;
  final String userName;
  final String userId;
  final String postTitle;
  final String postPrice;
  final String postDescription;

  UserReviewData({
    required this.rating,
    required this.review,
    required this.date,
    required this.userName,
    required this.postTitle,
    required this.postDescription,
    required this.postPrice,
    required this.userId,
  });
}

class ProductScreen extends StatefulWidget {
  final String title;
  final String category;
  final String price;
  final String description;
  final String image;

  ProductScreen({
    required this.title,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
  });

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 0;
  List<ReviewData> _reviewsData = [];
  String _currentUserName = "";

  void fetchCurrentUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _currentUserName = await getUserDisplayNameFromRealtimeDatabase(user.uid);
      setState(() {});
    }
  }

  Future<String> getUserDisplayNameFromRealtimeDatabase(String uid) async {
    DataSnapshot snapshot = (await FirebaseDatabase.instance
        .ref()
        .child('Users')
        .child(uid)
        .once()) as DataSnapshot;

    Map<String, dynamic> data = snapshot.value as Map<String, dynamic>;
    if (data != null && data.containsKey('name')) {
      return data['name'] as String;
    } else {
      return "Anonymous"; // Default name if user's name is not available
    }
  }

  double calculateAverageRating() {
    if (_reviewsData.isEmpty) {
      return 0;
    }

    double totalRating = 0;
    for (var reviewData in _reviewsData) {
      totalRating += reviewData.rating;
    }

    return totalRating / _reviewsData.length;
  }

  ProductScreen get productScreen => widget;

  void uploadReviewToDatabase(ReviewData reviewData) {
    String postTitle = productScreen.title;
    DatabaseReference reviewsRef = FirebaseDatabase.instance
        .ref()
        .child("Reviews of Product")
        .child(postTitle);

    String reviewKey = reviewsRef.push().key!;

    reviewsRef.child(reviewKey).set({
      "rating": reviewData.rating,
      "review": reviewData.review,
      "date": reviewData.date,
      "userName": reviewData.userName,
    });
  }

  void uploadUserReviewToDatabase(UserReviewData userReviewData) async {
    DatabaseReference userReviewsRef = FirebaseDatabase.instance
        .ref()
        .child("Reviews by Users")
        .child(userReviewData.userId);

    String reviewKey = userReviewsRef.push().key!;

    userReviewsRef.child(reviewKey).set({
      "rating": userReviewData.rating,
      "review": userReviewData.review,
      "date": userReviewData.date,
      "userName": userReviewData.userName,
      "postTitle": userReviewData.postTitle,
      "postPrice": userReviewData.postPrice,
      "postDescription": userReviewData.postDescription,
    });
  }

  void fetchReviewsData() async {
    DatabaseReference reviewsRef =
    FirebaseDatabase.instance.ref().child("Reviews of Product").child(widget.title);

    DataSnapshot snapshot = (await reviewsRef.once()) as DataSnapshot;

    if (snapshot.value != null) {
      Map<dynamic, dynamic>? reviewsMap = snapshot.value as Map?;
      List<ReviewData> reviews = [];

      reviewsMap?.forEach((key, value) {
        reviews.add(ReviewData(
          rating: value['rating'],
          review: value['review'],
          date: value['date'],
          userName: value['userName'],
        ));
      });

      setState(() {
        _reviewsData = reviews;
      });
    }
  }



  @override
  void initState() {
    super.initState();
    fetchCurrentUserName();
    fetchReviewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height / 3.0,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 224, 224, 224),
                  image: DecorationImage(
                    image: NetworkImage(widget.image),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(right: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${widget.price}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.orange.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.category,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 10),
              // Rating Bar
              RatingBar.builder(
                unratedColor: Color.fromARGB(255, 223, 221, 221),
                itemSize: 28,
                initialRating: calculateAverageRating(),
                minRating: 0,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {},
              ),
              SizedBox(height: 10),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Reviews()),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.reviews,
                            size: 22,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "Reviews",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      final cleanedPrice = widget.price.replaceAll(RegExp(r'[^\d.]'), '');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMethod(
                            title: widget.title, // Replace with the actual title
                            price: double.tryParse(cleanedPrice) ?? 0.0,
                              image: widget.image,// Replace with the actual price
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Color(0xfffd725a),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 20),

              // Reviews
              Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _reviewsData.map((reviewData) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rating: ${reviewData.rating}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                "By: ${reviewData.userName}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                reviewData.date,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            reviewData.review,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),

              // Review input
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                              RatingBar.builder(
                                unratedColor:
                                    Color.fromARGB(255, 223, 221, 221),
                                itemSize: 28,
                                initialRating: _rating,
                                minRating: 0,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    _rating = rating;
                                  });
                                },
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _reviewController,
                                decoration: InputDecoration(
                                  hintText: "Write a review...",
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (_reviewController.text.isNotEmpty &&
                                _rating > 0) {
                              String currentUserName = _currentUserName
                                      .isNotEmpty
                                  ? _currentUserName
                                  : "Anonymous"; // Use 'Anonymous' if the user's name is not fetched yet.
                              setState(() {
                                _reviewsData.add(ReviewData(
                                  rating: _rating,
                                  review: _reviewController.text,
                                  date: DateFormat.yMMMMd()
                                      .format(DateTime.now()),
                                  userName:
                                      currentUserName, // Use the current user's ID
                                ));
                                _reviewController.clear();
                                _rating = 0;
                                uploadReviewToDatabase(_reviewsData
                                    .last); // Upload the new review to the database
                                if (_reviewController.text.isNotEmpty &&
                                    _rating > 0) {
                                  String currentUserName = _currentUserName
                                          .isNotEmpty
                                      ? _currentUserName
                                      : "Anonymous"; // Use 'Anonymous' if the user's name is not fetched yet.

                                  String userId = FirebaseAuth.instance
                                      .currentUser!.uid; // Get the user's ID
                                  String postTitle = widget.title;
                                  String postPrice = widget.price;
                                  String postDescription = widget.description;

                                  UserReviewData userReviewData =
                                      UserReviewData(
                                    rating: _rating,
                                    review: _reviewController.text,
                                    date: DateFormat.yMMMMd()
                                        .format(DateTime.now()),
                                    userName: currentUserName,
                                    userId: userId,
                                    postTitle: postTitle,
                                    postPrice: postPrice,
                                    postDescription: postDescription,
                                  );

                                  uploadUserReviewToDatabase(userReviewData);

                                  setState(() {
                                    _reviewsData
                                        .add(userReviewData as ReviewData);
                                    _reviewController.clear();
                                    _rating = 0;
                                  });
                                }
                              });
                            }
                          },
                          child: Text("Post"),
                        ),
                      ],
                    ),
                  ],
              ),
              //SizedBox(height: 20),
          ),
        ),
      );
  }

  void updateData() {
    if (_reviewController.text.isNotEmpty && _rating > 0) {
      String currentUserName = _currentUserName.isNotEmpty
          ? _currentUserName
          : "Anonymous"; // Use 'Anonymous' if the user's name is not fetched yet.

      String userId =
          FirebaseAuth.instance.currentUser!.uid; // Get the user's ID
      String postTitle = widget.title;
      String postPrice = widget.price;
      String postDescription = widget.description;

      UserReviewData userReviewData = UserReviewData(
        rating: _rating,
        review: _reviewController.text,
        date: DateFormat.yMMMMd().format(DateTime.now()),
        userName: currentUserName,
        userId: userId,
        postTitle: postTitle,
        postPrice: postPrice,
        postDescription: postDescription,
      );

      uploadUserReviewToDatabase(userReviewData);

      setState(() {
        _reviewsData.add(userReviewData as ReviewData);
        _reviewController.clear();
        _rating = 0;
      });
    }
  }
}
