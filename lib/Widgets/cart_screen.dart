import 'package:flutter/material.dart';

import 'cart_item_sample.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 22,
                      ),
                    ),
                    Text(
                      "Cart",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.more_horiz,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
              Container(padding: EdgeInsets.only(top: 15),
              child: Column(
                children: [
                  CartItemSample(),
                ],
              ),),
            ],
          ),
        ),
      ),
    );
  }
}
