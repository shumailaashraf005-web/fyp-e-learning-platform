import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TopicsScreen extends StatefulWidget {
  final String chapterName;
  final String courseId;

  const TopicsScreen({
    super.key,
    required this.chapterName,
    required this.courseId,
  });

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  final db = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> topics = [];
  bool loading = true;

  YoutubePlayerController? controller;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    fetchTopics();
  }

  Widget numberBadge(int number) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        color: Color(0xFFBFE3FF),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        number.toString().padLeft(2, '0'),
        style: const TextStyle(
          color: Color(0xFF1E88E5),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void fetchTopics() {
    db.child("courses").onValue.listen((event) {
      final data = event.snapshot.value;

      List<Map<String, dynamic>> temp = [];

      if (data is Map) {
        final usersMap = Map<String, dynamic>.from(data);

        usersMap.forEach((uid, userCourses) {
          if (userCourses is Map) {
            final coursesMap = Map<String, dynamic>.from(userCourses);

            coursesMap.forEach((_, course) {
              if (course is Map) {
                final chapters = course["chapters"];

                if (chapters is Map) {
                  final chapterMap = Map<String, dynamic>.from(chapters);

                  chapterMap.forEach((chapterKey, chapterValue) {
                    if (chapterValue is Map &&
                        chapterKey.trim() == widget.chapterName.trim()) {

                      final topicMap = Map<String, dynamic>.from(
                          chapterValue["topics"] ?? {});

                      final sortedKeys = topicMap.keys.toList()..sort();

                      for (var k in sortedKeys) {
                        final v = topicMap[k];

                        temp.add({
                          "id": k,
                          "topic_name": v["name"] ?? "",
                          "video_url": v["video_url"] ?? "",
                        });
                      }
                    }
                  });
                }
              }
            });
          }
        });
      }

      setState(() {
        topics = temp;
        loading = false;
      });
    });
  }

  void playVideo(int index) {
    final url = topics[index]["video_url"];
    final id = YoutubePlayer.convertUrlToId(url);

    if (id == null) return;

    setState(() {
      selectedIndex = index;
    });

    if (controller == null) {
      controller = YoutubePlayerController(
        initialVideoId: id,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );

      setState(() {});
    } else {

      controller!.load(id);
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          widget.chapterName.replaceAll("_", " "),
          style: const TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          if (controller != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    YoutubePlayer(
                      controller: controller!,
                      showVideoProgressIndicator: true,
                    ),

                    if (selectedIndex >= 0)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: numberBadge(selectedIndex + 1),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Topics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: topics.length,
              itemBuilder: (context, index) {
                final item = topics[index];

                return GestureDetector(
                  onTap: () => playVideo(index),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        numberBadge(index + 1),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item["topic_name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.play_circle_fill,
                          color: Colors.red,
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
    );
  }
}