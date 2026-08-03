import 'package:finalproject/screens/studynotes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:finalproject/screens/dashboard.dart';
import 'package:finalproject/screens/course.dart';

import 'package:finalproject/screens/analyticsgraph.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  void markAllAsRead() async {
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Notifications");

    final snapshot = await ref.get();

    if (snapshot.exists) {
      final data = Map<String, dynamic>.from(snapshot.value as dynamic);

      data.forEach((key, value) {
        ref.child(key).update({
          "isRead": true,
        });
      });
    }
  }

  void checkUnreadNotifications() {
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

  List<Map<String, dynamic>> notifications = [];
  int myIndex = 2;
  bool hasUnread = false;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
    markAllAsRead();
    checkUnreadNotifications();
  }

  void fetchNotifications() {
    DatabaseReference ref =
    FirebaseDatabase.instance.ref("Notifications");

    ref.onValue.listen((event) {
      final data = event.snapshot.value;

      if (data == null) return;

      List<Map<String, dynamic>> temp = [];

      if (data is Map) {
        data.forEach((key, value) {
          temp.add({
            "title": value["title"] ?? "",
            "body": value["body"] ?? "",
          });
        });
      }

      setState(() {
        notifications = temp.reversed.toList();
      });
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

      body: Column(
        children: [
          const SizedBox(height: 50),

          const Text(
            "My Notifications",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: notifications.isEmpty
                ? const Center(
              child: Text(
                "No notifications yet",
                style: TextStyle(color: Colors.white70),
              ),
            )
                : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  title: Text(
                    notifications[index]["title"] ?? "",
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    notifications[index]["body"] ?? "",
                    style: const TextStyle(color: Colors.white70),
                  ),
                );
              },
            ),
          ),
        ],
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
    );
  }
}