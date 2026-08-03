import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        title: const Text("About App",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF0D022D),
        leading: const BackButton(color: Colors.white),
      ),

      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            "Welcome to EDULearn \n\n"
                "EDULearn is a modern and user-friendly e-learning platform designed to make education simple, accessible, and effective for students of all levels. Our goal is to provide high-quality learning content anytime, anywhere.\n\n"

                "Our Mission\n"
                "Our mission is to empower students with digital education by providing easy access to video lectures, structured courses, and learning materials that help improve knowledge and skills.\n\n"

                "Key Features\n"
                "• High-quality video lectures\n"
                "• Organized courses by subjects\n"
                "• Simple and user-friendly interface\n"
                "• Regular content updates\n"
                "• Smooth learning experience\n\n"

                "Our Vision\n"
                "We aim to build a strong digital education system where every student can learn without barriers of time, location, or cost.\n\n"

                "Why EDULearn?\n"
                "We focus on delivering clear, easy-to-understand, and practical knowledge that helps students succeed in their academic journey.\n\n"

                "Version\n"
                "1.0.0\n\n"

                "© 2026 EDULearn. All rights reserved.",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}