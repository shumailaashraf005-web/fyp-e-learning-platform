
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:finalproject/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();
  bool isLastPage = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }

  Widget buildPage({
    required Color color,
    required String urlImage,
    required String title,
    required String subtitle,
  }) => Container(
    color: color,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(urlImage, fit: BoxFit.cover, width: double.infinity),

        SizedBox(height: 1,child: Divider(color: Colors.white,),),

        const SizedBox(height: 30),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 80),
        child: PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() => isLastPage = index == 3);
          },

          children: [
            buildPage(
              color: Color(0xff0C042E),
              urlImage: ("assets/images/img_17.png"),
              title: "Online Learning Platform",
              subtitle:
              "Empowering students to learn academic subjects anytime, anywhere with interactive and easy-to-use lessons.",
            ),

            buildPage(
              color: Color(0xff0C042E),

              urlImage: ("assets/images/img_18.png"),
              title: "Learn on your Schedule",
              subtitle:
              "Access academic subjects anytime and study at your own pace with flexible online learning.",
            ),

            buildPage(
              color: Color(0xff0C042E),

              urlImage: ("assets/images/img_19.png"),
              title: "Ready to find a Course",
              subtitle:
              "Explore a wide range of academic subjects and start learning with interactive and engaging lessons.",
            ),

            buildPage(
              color: Color(0xff0C042E),
              urlImage:
              ("assets/images/img_20.png"),
              title: "Explore it Today!",
              subtitle:
              "Discover academic subjects designed to make learning simple, interactive, and effective.",
            ),
          ],
        ),
      ),

      bottomSheet: isLastPage
          ? TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.indigo,
          minimumSize: const Size.fromHeight(90),
        ),
        onPressed: () async {
          final prefs = await SharedPreferences.getInstance();
          prefs.setBool("showLogin", true);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Loginpage()),
          );
        },
        child: const Text("Get Started", style: TextStyle(fontSize: 24)),
      )
          : Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Loginpage(),
                  ),
                );
              },
              child: Text("Skip"),
            ),
            Center(
              child: SmoothPageIndicator(
                controller: controller,
                count: 4,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: Colors.black26,
                  activeDotColor: Colors.black,
                ),
                onDotClicked: (index) => controller.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                ),
              ),
            ),
            TextButton(
              onPressed: () => controller.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              ),
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}
