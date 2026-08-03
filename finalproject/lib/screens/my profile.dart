import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalproject/screens/login.dart';
import 'package:finalproject/screens/editprofile.dart';
import 'dart:io';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<MyProfileScreen> {
  final FirebaseAuth auth =
      FirebaseAuth.instance;

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref("users");

  User? user;

  String dbEmail = "";
  String dbImage = "";

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    fetchUserData();
  }

  void fetchUserData() {
    final uid = auth.currentUser?.uid;

    if (uid == null) return;

    dbRef.child(uid).onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      if (data != null) {
        setState(() {
          dbEmail = data["email"] ?? "";
          dbImage = data["image"] ?? "";
        });
      }
    });
  }

  Future<void> logout() async {
    await auth.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => Loginpage()),
          (route) => false,
    );
  }

  Future<void> openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );

    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D022D),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "My Profile",
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 40),

            Stack(
              children: [
                GestureDetector(
                  onTap: openEditProfile,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: dbImage.isNotEmpty
                        ? FileImage(File(dbImage))
                        : null,
                    child: dbImage.isEmpty
                        ? const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: openEditProfile,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Text(
              dbEmail.isNotEmpty ? dbEmail : (user?.email ?? "No Email"),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: "PoppinsMedium",
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: openEditProfile,
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}