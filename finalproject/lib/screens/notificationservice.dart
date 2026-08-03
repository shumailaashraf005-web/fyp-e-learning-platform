import 'package:firebase_database/firebase_database.dart';

class NotificationService {

  static Future<bool> hasUnreadNotifications() async {
    final ref = FirebaseDatabase.instance.ref("Notifications");
    final snapshot = await ref.get();

    if (!snapshot.exists) return false;

    final data = Map<String, dynamic>.from(snapshot.value as dynamic);

    for (var item in data.values) {
      if (item["isRead"] == false) {
        return true;
      }
    }
    return false;
  }
}