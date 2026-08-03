import 'package:finalproject/screens/help%20and%20support.dart';
import 'package:finalproject/screens/my%20profile.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/screens/profile.dart';
import 'package:finalproject/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finalproject/screens/login.dart';

import 'package:finalproject/screens/about app.dart';
import 'package:finalproject/screens/privacy policy.dart';
import 'package:finalproject/screens/terms and conditions.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Poppins",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF0D022D),
        elevation: 0,
        leading: const BackButton(color: Colors.white),
      ),

      body: ListView(
        children: [
          const SizedBox(height: 10),

          ListTile(
            leading: const Icon(Icons.person, color: Colors.white),
            title: const Text("My Profile",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyProfileScreen()),
              );
            },
          ),

          const Divider(color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text("About App",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutAppScreen()),
              );
            },
          ),

          const Divider(color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined,
                color: Colors.white),
            title: const Text("Privacy Policy",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),

          const Divider(color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.description_outlined, color: Colors.white),
            title: const Text("Terms & Conditions",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
              );
            },
          ),

          const Divider(color: Colors.white24),

          ListTile(
            leading: const Icon(Icons.help_outline, color: Colors.white),
            title: const Text("Help & Support",
                style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios,
                size: 16, color: Colors.white),
            onTap: () {
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => ClientChatScreen()),
              );
            },
          ),

          const Divider(color: Colors.white24),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}