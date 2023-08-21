import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tool_rental_app/SignInScreen.dart';
import 'Screens/HomeScreen/HomeScreen.dart';
import 'SignUpScreen.dart';
import 'UI/splash_screen.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_51NdKIjGBms1IUDYCdwFOqjTTPSU9F6kvQqHlAoJWF4csTQSyZkSFZWVrKk762agJ6tyLTWdYc8Sh0dgA4zezYLnR00YwDCAx00';

  runApp(  MaterialApp(initialRoute: '/',
  routes: {
    '/':(context)=>SplashScreen(),
    'LaunchScreen':(context)=>LaunchScreen(),
    'SignUpScreen':(context)=>const SignUpScreen(),
    'SignInScreen':((context) => SignInScreen()),
    'HomeScreen':(context) => HomeScreen()
  },));
}

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEFEBE9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ClipPath(
            clipper: MyCustomClipper(),
            child: Container(
              height: 550,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/tools.png"),
                      fit: BoxFit.cover)),
            ),
          ),
          Center(
            child: Text(
              "Welcome to smart Rent tool app",
              style: GoogleFonts.montserrat(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 65, 97, 109)),
            ),
          ),
          SizedBox(
            height: 35,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff4E342E),
                      shape: StadiumBorder(),
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 5)),
                  onPressed: () {
                    Navigator.pushNamed(context, 'SignUpScreen');
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: StadiumBorder(),
                        backgroundColor: Color(0xff4E342E),
                        padding: EdgeInsets.symmetric(horizontal: 30)),
                    onPressed: () {
                      Navigator.pushNamed(context, 'SignInScreen');
                    },
                    child: Text("Login"))
              ],
            ),
          ),
          SizedBox(
            height: 35,
          ),
          OutlinedButton.icon(
              style: ElevatedButton.styleFrom(
                  shape: StadiumBorder(),
                  side: BorderSide(width: 2, color: Colors.blue)),
              onPressed: () {},
              icon: Icon(Icons.facebook),
              label: Text("Connect with Facebook")),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // TODO: implement getClip

    Path path = new Path();
    path.lineTo(0, size.height * 0.85); //vertical line
    path.cubicTo(size.width / 3, size.height, 2 * size.width / 3,
        size.height * 0.7, size.width, size.height * 0.85); //cubic curve
    path.lineTo(size.width, 0); //vertical line
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}