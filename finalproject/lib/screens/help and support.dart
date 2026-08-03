import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class ClientChatScreen extends StatefulWidget {
  const ClientChatScreen({super.key});

  @override
  State<ClientChatScreen> createState() => _ClientChatScreenState();
}

class _ClientChatScreenState extends State<ClientChatScreen> {
  final TextEditingController controller = TextEditingController();

  final DatabaseReference db = FirebaseDatabase.instance.ref();

  User? get user => FirebaseAuth.instance.currentUser;

  List<Map> messages = [];

  @override
  void initState() {
    super.initState();

    messages = [];

    saveUserEmail();
    listenMessages();
  }

  void saveUserEmail() {
    if (user == null) return;

    db.child("chats/${user!.uid}/email").set(
      user!.email ?? "",
    );
  }

  void listenMessages() {
    db.child("chats/${user!.uid}/messages").onValue.listen((event) {
      final data = event.snapshot.value as Map?;

      List<Map> temp = [];

      if (data != null) {
        data.forEach((key, value) {
          temp.add(Map.from(value));
        });
      }

      temp.sort((a, b) =>
          (a["time"] ?? 0).compareTo(b["time"] ?? 0));

      setState(() {
        messages = temp;
      });
    });
  }

  void sendMessage() {
    if (controller.text.trim().isEmpty) return;

    db.child("chats/${user!.uid}/messages").push().set({
      "sender": "user",
      "text": controller.text,
      "time": DateTime.now().millisecondsSinceEpoch,
    });

    controller.clear();
  }

  Widget messageBubble(Map msg) {
    bool isMe = msg["sender"] == "user";

    String text = msg["text"] ?? "";

    int timeValue = msg["time"] ?? 0;

    DateTime dateTime =
    DateTime.fromMillisecondsSinceEpoch(timeValue);

    String time =
        "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment:
      isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(
            vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.grey.shade800,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D022D),

      appBar: AppBar(
        backgroundColor: const Color(0xFF0D022D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Help & Support",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "PoppinsMedium",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messageBubble(messages[index]);
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      hintStyle:
                      const TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    icon: const Icon(Icons.send,
                        color: Colors.white),
                    onPressed: sendMessage,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}