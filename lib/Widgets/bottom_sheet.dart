import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cart_screen.dart';

class CustomBottomSheet extends StatefulWidget {
  final int productPrice;

  CustomBottomSheet({required this.productPrice});

  @override
  _CustomBottomSheetState createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  int quantity = 0;

  void _increaseQuantity() {
    setState(() {
      quantity++;
    });
  }

  void _decreaseQuantity() {
    if (quantity > 0) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPrice = widget.productPrice * quantity;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16), // Adjust the padding as needed
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Total: ",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: _decreaseQuantity,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      CupertinoIcons.minus,
                      size: 18,
                      color: Colors.orange,
                    ),
                  ),
                ),
                Text(
                  "$quantity",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                InkWell(
                  onTap: _increaseQuantity,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      CupertinoIcons.plus,
                      size: 18,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Total Payment",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "$totalPrice",
              style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Color(0xfffd725a),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Center(
                  child: Text(
                    "Checkout",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}