// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, library_private_types_in_public_api

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentMethod extends StatefulWidget {
  final String title;
  final double price;
  final String image;

  PaymentMethod({required this.title, required this.price, required this.image});

  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethod> {
  Map<String, dynamic>? paymentIntentData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      appBar: AppBar(
        title: const Text('Stripe Payment'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(16), // Add padding around the image
              child: Image.network(
                widget.image, // Use the passed image URL
                width: 220, // Set a smaller width for the image
                height: 220, // Set a smaller height for the image
                fit: BoxFit.contain, // Adjust the image fit
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Product: ${widget.title}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Price: \$${widget.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            InkWell(
              onTap: () async {
                await makePayment();
                // Get the current user's ID
                String userId = FirebaseAuth.instance.currentUser!.uid;

                // Define the order data to be uploaded
                Map<String, dynamic> orderData = {
                  'title': widget.title,
                  'userId': userId,
                  'price': widget.price.toString(),
                  'timestamp': ServerValue.timestamp,
                  'image' : widget.image// Add a timestamp for ordering time
                };

                // Upload the order data to the database
                DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('Orders');
                DatabaseReference userOrdersRef = ordersRef.child(userId);
                userOrdersRef.push().set(orderData);
                Fluttertoast.showToast(
                  msg: "Payment is successful!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                );

                // Navigate to the HomeScreen
                Navigator.of(context).pop();
              },
              child: Container(
                height: 50,
                width: 200,
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Pay',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> makePayment() async {
    try {
      paymentIntentData =
      await createPaymentIntent('20', 'USD'); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              setupIntentClientSecret: 'sk_test_51NdKIjGBms1IUDYCWP8C9ezQiil2RYEBegcVTIHzvrBiyefTJj7tcn7ilT2w06L5wS2PSrudpWWyLR5Xs60UoCxi006xF4rsWZ',
              paymentIntentClientSecret:
              paymentIntentData!['client_secret'],
              //applePay: PaymentSheetApplePay.,
              //googlePay: true,
              //testEnv: true,
              customFlow: true,
              style: ThemeMode.dark,
              // merchantCountryCode: 'US',
              merchantDisplayName: 'Kashif'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      print('Payment exception:$e$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
        //       parameters: PresentPaymentSheetParameters(
        // clientSecret: paymentIntentData!['client_secret'],
        // confirmPayment: true,
        // )
      )
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
            content: Text("Cancelled "),
          ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount('20'),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer ' + 'your token',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');
      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }

  calculateAmount(String amount) {
    final a = (int.parse(amount)) * 100;
    return a.toString();
  }
}