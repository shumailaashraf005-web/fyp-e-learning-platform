import 'dart:io';
import 'package:finalproject/screens/Topics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class ChapterScreen extends StatefulWidget {
  final String subjectName;
  final String courseId;

  const ChapterScreen({
    super.key,
    required this.subjectName,
    required this.courseId,
  });

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  TextEditingController searchController = TextEditingController();
  String searchText = "";

  List<Map<String, dynamic>> chapters = [];

  @override
  void initState() {
    super.initState();
    fetchChapters();
  }

  void fetchChapters() {
    dbRef.child("courses").onValue.listen((event) {
      final data = event.snapshot.value;

      List<Map<String, dynamic>> temp = [];

      if (data is Map) {
        final usersMap = Map<String, dynamic>.from(data);

        usersMap.forEach((uid, userCourses) {
          if (userCourses is Map) {
            final coursesMap = Map<String, dynamic>.from(userCourses);

            coursesMap.forEach((courseId, course) {
              if (course is Map) {

                String courseName =
                (course["course_name"] ?? "").toString().trim().toLowerCase();

                String selectedCourse =
                widget.subjectName.trim().toLowerCase();

                if (courseName == selectedCourse) {

                  if (course["chapters"] != null) {
                    final chapterMap =
                    Map<String, dynamic>.from(course["chapters"]);

                    chapterMap.forEach((chapterKey, chapterValue) {

                      final chapter = Map<String, dynamic>.from(chapterValue);

                      temp.add({
                        "key": chapterKey,
                        "name": chapter["name"] ?? "",
                        "courseId": courseId,
                      });
                    });
                  }
                }
              }
            });
          }
        });
      }

      setState(() {
        chapters = temp;
      });
    });
  }

  void search(String value) {
    setState(() {
      searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = chapters.where((e) {
      return e["name"]
          .toString()
          .toLowerCase()
          .contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.subjectName,
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme:
        const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 55,
              padding:
              const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border:
                Border.all(color: Colors.white),
                borderRadius:
                BorderRadius.circular(10),
              ),
              child: TextField(
                controller: searchController,
                onChanged: search,
                style: const TextStyle(
                    color: Colors.white),
                decoration:
                const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Chapters...",
                  hintStyle: TextStyle(
                      color: Colors.white70),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: filtered.isEmpty
                  ? const Center(
                child: Text(
                  "No Chapters Found",
                  style: TextStyle(
                      color: Colors.white),
                ),
              )
                  : ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];

                  return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopicsScreen(
                              /*courseId: widget.courseId,
                              chapterName: item["key"],*/
                              courseId: widget.courseId,
                              chapterName: item["key"].toString(),
                            ),
                          ),
                        );
                      },
                      child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: item["thumb"] !=
                              null &&
                              item["thumb"].toString().isNotEmpty
                              ? Image.file(
                            File(item["thumb"]),
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                            const Icon(
                              Icons.menu_book,
                              color: Colors.blue
                              ,
                              size: 50,
                            ),
                          )
                              : const Icon(
                            Icons.menu_book,
                            color: Colors.blue,
                            size: 50,
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),

                              Text(
                                "Chapter ${index + 1}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
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