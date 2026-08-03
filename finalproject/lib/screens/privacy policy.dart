import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),
      appBar: AppBar(
        title: const Text("Privacy Policy",
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
            "At EDULearn, your privacy is our top priority. This Privacy Policy explains how we collect, use, and protect your information when you use our application.\n\n"

                "1. Information We Collect\n"
                "We may collect basic user information such as name, email address, and usage data to improve your learning experience. We do not collect unnecessary personal data.\n\n"

                "2. How We Use Your Information\n"
                "We use collected data to:\n"
                "• Improve app performance\n"
                "• Personalize learning experience\n"
                "• Provide relevant educational content\n"
                "• Fix bugs and improve features\n\n"

                "3. Data Protection\n"
                "We use secure systems and encryption methods to protect your data from unauthorized access, misuse, or loss.\n\n"

                "4. Data Sharing\n"
                "We do not sell, trade, or share your personal information with third parties. Your data is only used within the app for educational purposes.\n\n"

                "5. Third-Party Services\n"
                "Some features may use third-party services (like Firebase). These services have their own privacy policies which we recommend reviewing.\n\n"

                "6. User Rights\n"
                "You have the right to:\n"
                "• Access your data\n"
                "• Request data deletion\n"
                "• Update your information\n\n"

                "7. Changes to Privacy Policy\n"
                "We may update this Privacy Policy from time to time. Any changes will be updated within the app.\n\n"

                "8. Contact Us\n"
                "If you have any questions about this Privacy Policy, you can contact our support team.\n\n"

                "By using EDULearn, you agree to this Privacy Policy.\n\n"
                "© 2026 EDULearn. All rights reserved.",
            style: TextStyle(color: Colors.white, height: 1.5),
          ),
        ),
      ),
    );
  }
}