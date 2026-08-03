import 'package:finalproject/screens/studynotes.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:finalproject/screens/dashboard.dart';
import 'package:finalproject/screens/course.dart';
import 'package:finalproject/screens/notifications.dart';


class AnalyticsGraphScreen extends StatefulWidget {
  const AnalyticsGraphScreen({super.key});

  @override
  State<AnalyticsGraphScreen> createState() =>
      _AnalyticsGraphScreenState();
}

class _AnalyticsGraphScreenState
    extends State<AnalyticsGraphScreen> {

  int myIndex = 4;

  final DatabaseReference dbRef =
  FirebaseDatabase.instance.ref();

  Map<String, double> chartData = {};
  bool isLoading = true;

  bool hasUnread = false;


  @override
  void initState() {
    super.initState();

    fetchAnalytics();

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


  void fetchAnalytics() async {

    final snapshot = await dbRef
        .child("courses")
        .child("cm1ucWomJYhRoosYn4zJGwwkJO92")
        .get();

    if (!snapshot.exists) return;

    Map data = snapshot.value as Map;

    Map<String, double> tempData = {};

    data.forEach((courseKey, courseValue) {

      int chapterCount = 0;
      int topicCount = 0;

      if (courseValue["chapters"] != null) {

        Map chapters = courseValue["chapters"];

        chapterCount = chapters.length;

        chapters.forEach((chKey, chValue) {

          if (chValue["topics"] != null) {
            Map topics = chValue["topics"];
            topicCount += topics.length;
          }
        });
      }

      double score =
      (chapterCount * 10 + topicCount * 5).toDouble();


      String courseName = courseKey
          .replaceAll("_", " ")
          .split(" ")
          .first; //

      tempData[courseName] = score;
    });

    setState(() {
      chartData = tempData;
      isLoading = false;
    });
  }


  void onItemTapped(int index) {
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
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnalyticsGraphScreen()),
      );
    }
  }


  Widget legendItem(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const Center(
                child: Text(
                  "Analytics",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  children: [

                    const Text(
                      "Courses Analytics",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    const SizedBox(height: 30),


                    SizedBox(
                      height: 280,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : PieChart(
                        PieChartData(
                          centerSpaceRadius: 50,
                          sectionsSpace: 4,
                          sections: chartData.entries.map((entry) {

                            final total = chartData.values.fold(
                                0.0, (a, b) => a + b);

                            final percent =
                                (entry.value / total) * 100;

                            return PieChartSectionData(
                              value: entry.value,
                              color: Colors.primaries[
                              chartData.keys
                                  .toList()
                                  .indexOf(entry.key) %
                                  Colors.primaries.length],
                              radius: 75,
                              title:
                              "${entry.key}\n${percent.toStringAsFixed(1)}%",
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),


                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: chartData.entries.map((entry) {

                        Color color = Colors.primaries[
                        chartData.keys
                            .toList()
                            .indexOf(entry.key) %
                            Colors.primaries.length];

                        return legendItem(entry.key, color);
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}