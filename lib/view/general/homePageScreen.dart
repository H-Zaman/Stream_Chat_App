import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:streamchat/view/general/loginScreen.dart';

class HomePageScreen extends StatefulWidget {
  @override
  _HomePageScreenState createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5),()=> Get.offAll(LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff50C3E9),
      body: Stack(
        children: [
          Center(
            child: Lottie.asset(
              'assets/lottieJson/welcome.json'
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 100,
            child: Text(
              'Welcome to\n StreamChat',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Positioned(
            right: 20,
            bottom: 40,
            child: Text(
              'By: github/h-zaman',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      )
    );
  }
}
