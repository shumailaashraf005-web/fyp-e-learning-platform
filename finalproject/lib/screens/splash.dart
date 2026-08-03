import 'dart:async';

import 'package:flutter/material.dart';
import 'package:finalproject/screens/Onboarding.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () =>
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(
            builder: (context) =>  OnboardingScreen(),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0C042E),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "EDULearn",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PoppinsBold"
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage("assets/images/img_2.png"),
                height: 200,
                width: 200,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
