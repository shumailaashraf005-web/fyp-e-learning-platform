import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),
      appBar: AppBar(
        title: const Text("Terms & Conditions",
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
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Text(
            "Welcome to EDULearn. By accessing or using this application, you agree to be bound by the following terms and conditions. Please read them carefully before using the app.\n\n"

                "1. Use of App\n"
                "EDULearn is created for educational purposes only. Users must use this app in a lawful and responsible manner.\n\n"

                "2. User Responsibility\n"
                "Users are responsible for maintaining the confidentiality of their account information and activity within the app.\n\n"

                "3. Prohibited Activities\n"
                "You agree NOT to:\n"
                "• Copy or redistribute content without permission\n"
                "• Misuse videos or educational material\n"
                "• Attempt to hack or damage the system\n"
                "• Use the app for illegal activities\n\n"

                "4. Content Ownership\n"
                "All content including videos, images, and materials belong to EDULearn. Unauthorized use is strictly prohibited.\n\n"

                "5. App Changes\n"
                "We reserve the right to update, modify, or discontinue any feature of the app at any time without prior notice.\n\n"

                "6. Limitation of Liability\n"
                "We are not responsible for any loss, damage, or issues caused by misuse of the app or technical errors.\n\n"

                "7. Termination\n"
                "We may suspend or terminate user access if any violation of terms is detected.\n\n"

                "8. Acceptance of Terms\n"
                "By continuing to use EDULearn, you fully agree to these Terms & Conditions.\n\n"

                "© 2026 EDULearn. All rights reserved.",
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ),
      ),
    );
  }
}