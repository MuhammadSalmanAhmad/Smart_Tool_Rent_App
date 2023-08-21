import 'package:flutter/material.dart';
import 'package:tool_rental_app/FirebaseServices/splash_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashServices = SplashServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashServices.isLogin(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body:Column(
        children: [
          SizedBox(height: 130,),
          Center(child: Image.asset("assets/logo.png", height: 200, width: 200,)),
          SizedBox(height: 60,),
          Center(
            child: Text("Smart Tool Rental App",style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: Colors.white),),
          ),
        ],
      ) ,
    );
  }
}
