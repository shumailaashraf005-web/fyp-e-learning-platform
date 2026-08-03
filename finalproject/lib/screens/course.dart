import 'dart:io';

import 'package:finalproject/screens/analyticsgraph.dart';
import 'package:finalproject/screens/chapter.dart';

import 'package:finalproject/screens/notifications.dart';
import 'package:finalproject/screens/dashboard.dart';
import 'package:finalproject/screens/studynotes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalproject/screens/login.dart';

class Courses extends StatefulWidget {
  const Courses({super.key});

  @override
  State<Courses> createState() => _CoursesState();
}

class _CoursesState extends State<Courses> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  final User? user = FirebaseAuth.instance.currentUser;

  int myIndex = 1;


  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> filteredCourses = [];

  final TextEditingController _searchController =
  TextEditingController();

  bool hasUnread = false;


  @override
  void initState() {
    super.initState();

    fetchCourses();

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

  void fetchCourses() {
    dbRef.child("courses").onValue.listen((event) {
      final data = event.snapshot.value;

      List<Map<String, dynamic>> temp = [];

      if (data != null) {
        Map<dynamic, dynamic> usersMap =
        Map<dynamic, dynamic>.from(data as dynamic);

        usersMap.forEach((userKey, userValue) {
          if (userValue is Map) {
            Map<dynamic, dynamic> courseMap =
            Map<dynamic, dynamic>.from(userValue);

            courseMap.forEach((courseKey, courseValue) {
              temp.add({
                "id": courseKey,
                "course_name": courseValue["course_name"] ?? "",
                "department": courseValue["department"] ?? "",
                "thumbnail": courseValue["thumbnail"] ?? "",
              });
            });
          }
        });
      }

      setState(() {
        courses = temp;

        if (_searchController.text.isEmpty) {
          filteredCourses = temp;
        } else {
          filteredCourses = temp.where((course) {
            return course["course_name"]
                .toString()
                .toLowerCase()
                .contains(
              _searchController.text
                  .toLowerCase(),
            );
          }).toList();
        }
      });
    });
  }

  void searchCourses(String value) {
    final results = courses.where((course) {
      final name = course["course_name"]
          .toString()
          .toLowerCase();

      return name.contains(value.toLowerCase());
    }).toList();

    setState(() {
      filteredCourses = results;
    });
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => Loginpage(),
      ),
          (route) => false,
    );
  }

  void onItemTapped(int index) async {
    setState(() {
      myIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) =>
          const DashboardScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const Courses(),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const NotificationScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => const StudyNotesScreen(),
        ),
      );
    } else if (index == 4) {
      // ⭐ Analytics Screen
      Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (_) => AnalyticsGraphScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      const Color(0xFF0D022D),

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
              label: "Analytics",
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),

      body: Padding(
        padding:
        const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 30),

            TextField(
              controller: _searchController,
              cursorColor: Colors.white,
              style: const TextStyle(
                color: Colors.white,
              ),
              onChanged: searchCourses,
              decoration: InputDecoration(
                hintText:
                "Search Courses...",
                hintStyle: const TextStyle(
                  color: Colors.white70,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                  const BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            const Align(
              alignment:
              Alignment.centerLeft,
              child: Text(
                "Courses",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: filteredCourses
                  .isEmpty
                  ? const Center(
                child: Text(
                  "No Courses Found",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: filteredCourses.length,
                itemBuilder:
                    (context, index) {
                  final course = filteredCourses[index];

                  final path = course["thumbnail"].toString();

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChapterScreen(
                            courseId: course["course_name"],
                            subjectName: course["course_name"],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              "${index + 1}".padLeft(2, "0"),
                              style:
                              const TextStyle(color: Colors.blue,
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: path.isNotEmpty ? Image.file(
                              File(path),
                              height: 60,
                              width: 60,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) {
                                return const Icon(Icons.menu_book, color: Colors.blue, size: 50,
                                );
                              },
                            )
                                : const Icon(Icons.menu_book,
                              color: Colors.blue,
                              size: 50,
                            ),
                          ),

                          const SizedBox(width: 6),

                          Expanded(child:
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course["course_name"].toString(),
                                  style:
                                  const TextStyle(
                                    fontWeight:
                                    FontWeight.bold,
                                    fontSize:
                                    16,
                                  ),
                                  overflow:
                                  TextOverflow.ellipsis,
                                ),

                                const SizedBox(height:4),

                                Text(
                                  course["department"].toString(),
                                  style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}