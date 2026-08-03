import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:finalproject/screens/dashboard.dart';
import 'package:finalproject/screens/course.dart';
import 'package:finalproject/screens/notifications.dart';
import 'package:finalproject/screens/analyticsgraph.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyChaptersScreen extends StatelessWidget {
  final String courseName;
  final String department;
  final Map chapters;

  const StudyChaptersScreen({
    super.key,
    required this.courseName,
    required this.department,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          courseName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: chapters.isEmpty
          ? const Center(
        child: Text(
          "No Chapters Found",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView(
        children: chapters.entries.map((e) {
          final chapter = Map<String, dynamic>.from(e.value);

          return Card(
            margin: const EdgeInsets.all(10),


            child: ListTile(

              leading: const Icon(
                Icons.menu_book,
                size: 50,
                color: Colors.blue,
              ),

              title: Text(
                chapter["name"] ?? "No Chapter",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              subtitle: Text(
                department,
              ),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudyTopicsScreen(
                      chapterName: chapter["name"] ?? "",
                      topics: chapter["topics"] ?? {},
                    ),
                  ),
                );
              },
            ),

          );
        }).toList(),
      ),
    );
  }
}

class StudyTopicsScreen extends StatelessWidget {
  final String chapterName;
  final Map topics;

  const StudyTopicsScreen({
    super.key,
    required this.chapterName,
    required this.topics,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          chapterName,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: topics.isEmpty
          ? const Center(
        child: Text(
          "No Topics Found",
          style: TextStyle(color: Colors.white),
        ),
      )
          : ListView(
        children: topics.entries.map((e) {

          final topic = Map<String, dynamic>.from(e.value);

          return Card(
            margin: const EdgeInsets.all(10),

            child: ListTile(
              leading: const Icon(Icons.picture_as_pdf, color: Colors.red),

              title: Text(
                topic["name"] ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              trailing: const Icon(Icons.open_in_new),

              onTap: () async {

                final pdfUrl = topic["Pdf_url"] ?? "";

                if (pdfUrl.isNotEmpty) {

                  final Uri url = Uri.parse(pdfUrl);

                  await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  );
                }
              },

            ),
          );
        }).toList(),
      ),
    );
  }
}

class StudyNotesScreen extends StatefulWidget {
  const StudyNotesScreen({super.key});

  @override
  State<StudyNotesScreen> createState() => _StudyNotesScreenState();
}

class _StudyNotesScreenState extends State<StudyNotesScreen> {

  int myIndex = 3;

  bool hasUnread = false;

  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();

    FirebaseDatabase.instance
        .ref("Notifications")
        .onValue
        .listen((event) {

      final data = event.snapshot.value;

      if (data != null) {

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
      }
    });

    FirebaseDatabase.instance
        .ref("study_content")
        .onValue
        .listen((event) {

      final data = event.snapshot.value;

      if (data == null) {
        setState(() {
          courses = [];
        });
        return;
      }

      final map = Map<String, dynamic>.from(data as dynamic);

      List<Map<String, dynamic>> temp = [];

      map.forEach((userId, userData) {

        final userMap = Map<String, dynamic>.from(userData);

        userMap.forEach((courseId, value) {

          temp.add({
            "id": courseId,
            "course_name": value["course_name"] ?? "",
            "department": value["department"] ?? "",
            "chapters": value["chapters"] ?? {},
          });

        });
      });

      setState(() {
        courses = temp;
      });
    });
  }

  void onItemTapped(int index) {

    if (index == myIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        ),
      );
    }

    else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Courses(),
        ),
      );
    }

    else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        ),
      );
    }

    else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const StudyNotesScreen(),
        ),
      );
    }

    else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AnalyticsGraphScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      body: SafeArea(
        child: Column(
          children: [

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Study Notes",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: courses.isEmpty
                  ? const Center(
                child: Text(
                  "No Study Notes Found",
                  style: TextStyle(color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: courses.length,

                itemBuilder: (context, index) {

                  final course = courses[index];

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),

                    child: ListTile(

                      leading: const Icon(
                        Icons.menu_book,
                        size: 50,
                        color: Colors.blue,
                      ),

                      title: Text(
                        course["course_name"] ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      subtitle: Text(
                        course["department"] ?? "",
                      ),

                      trailing: const Icon(Icons.arrow_forward_ios),

                      onTap: () {

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => StudyChaptersScreen(
                              courseName:
                              course["course_name"] ?? "",

                              department:
                              course["department"] ?? "",

                              chapters:
                              course["chapters"] ?? {},
                            ),
                          ),
                        );
                      },
                    ),


                  );
                },
              ),
            ),
          ],
        ),
      ),

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

            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "",
              backgroundColor: Colors.blue,
            ),

            const BottomNavigationBarItem(
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

            const BottomNavigationBarItem(
              icon: Icon(Icons.note_alt),
              label: "",
              backgroundColor: Colors.blue,
            ),

            const BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: "",
              backgroundColor: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}