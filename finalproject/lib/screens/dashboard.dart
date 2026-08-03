import 'dart:io';

import 'package:finalproject/screens/chapter.dart';
import 'package:finalproject/screens/course.dart';
import 'package:finalproject/screens/notifications.dart';
import 'package:finalproject/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalproject/screens/analyticsgraph.dart';
import 'package:finalproject/screens/studynotes.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  final TextEditingController _searchController =
  TextEditingController();

  final DatabaseReference _courseRef =
  FirebaseDatabase.instance.ref("new_courses");

  List<Map> allCourses = [];
  List<Map> filteredCourses = [];

  int myIndex = 0;

  bool hasUnread = false;

  String? imagePath;

  @override
  void initState() {
    super.initState();

    fetchCourses();

    listenProfileImage();

    FirebaseDatabase.instance.ref("Notifications").onValue.listen((event) {

      final data = event.snapshot.value;

      if (data == null) return;

      final map = Map<String, dynamic>.from(data as dynamic);

      bool foundUnread = false;

      map.forEach((key, value) {
        if (value["isRead"] == false) {
          foundUnread = true;
        }
      });

      setState(() {
        hasUnread = foundUnread;
      });
    });
  }

  void listenProfileImage() {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseDatabase.instance
        .ref("users")
        .child(uid)
        .child("image")
        .onValue
        .listen((event) {
      setState(() {
        imagePath = event.snapshot.value?.toString();
      });
    });
  }

  void fetchCourses() {
    _courseRef.onValue.listen((event) {
      final data = event.snapshot.value;

      allCourses.clear();

      if (data != null) {
        final mainMap = Map<String, dynamic>.from(data as dynamic);

        mainMap.forEach((uid, coursesMap) {
          final userCourses =
          Map<String, dynamic>.from(coursesMap);

          userCourses.forEach((key, value) {
            allCourses.add({
              "id": key,
              "name": value["name"] ?? "",
            });
          });
        });
      }

      setState(() {
        filteredCourses = allCourses;
      });
    });
  }

  void search(String query) {
    final results = allCourses.where((course) {
      final name = course["name"].toString().toLowerCase();
      return name.contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredCourses = results;
    });
  }

  void onItemTapped(int index) async {
    if (index == myIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Courses()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NotificationScreen()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StudyNotesScreen()),
      );
    }   else if (index == 4) {

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AnalyticsGraphScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          currentIndex: myIndex,
          onTap: onItemTapped,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.shifting,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: "",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Stack(
                children: [

                  const Icon(Icons.notifications),

                  if (hasUnread)
                    Positioned(
                      right: 0,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
              label: "",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.note_alt),
              label: "",
              backgroundColor: Colors.blue,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: "",
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  const Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),


                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.blue,

                      backgroundImage: (imagePath != null && imagePath!.isNotEmpty)
                          ? FileImage(File(imagePath!))
                          : null,

                      child: (imagePath == null || imagePath!.isEmpty)
                          ? const Icon(
                        Icons.person,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Container(
                height: 58,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 1.3),
                ),
                child: Center(
                  child: TextField(
                    controller: _searchController,
                    onChanged: search,
                    cursorColor: Colors.white,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.white,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 14),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 24,
                      ),
                      border: InputBorder.none,
                      hintText: "Search Courses...",
                      hintStyle: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              Container(
                height: MediaQuery.of(context).size.height * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/image.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              const Text(
                "New Courses",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              filteredCourses.isEmpty
                  ? const Center(
                child: Text(
                  "No Courses Found",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredCourses.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 2.8,
                ),
                itemBuilder: (context, index) {
                  final item = filteredCourses[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterScreen(
                            subjectName: item["name"],
                            courseId: item["id"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          item["name"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}