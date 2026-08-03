import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'constants.dart';
import 'package:finalproject/main.dart';
import 'package:finalproject/screens/notifications.dart';

class OneSignalService {

  static Future<void> init() async {

    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

    OneSignal.initialize(oneSignalAppId);

    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint("Foreground Notification Received");

      event.notification.display();

      FirebaseDatabase.instance.ref("Notifications").push().set({
        "title": event.notification.title ?? "",
        "body": event.notification.body ?? "",
        "time": DateTime.now().millisecondsSinceEpoch,
        "isRead": false,   // ⭐ IMPORTANT
      });

    });

    OneSignal.Notifications.addClickListener((event) async {

      debugPrint("Notification Clicked");

      await Future.delayed(const Duration(milliseconds: 200));

      final nav = navigatorKey.currentState;

      if (nav == null) {
        debugPrint("Navigator not ready");
        return;
      }

      nav.push(
        MaterialPageRoute(
          builder: (_) => const NotificationScreen(),
        ),
      );
    });

    OneSignal.User.pushSubscription.addObserver((state) async {

      final playerId = state.current.id;

      if (playerId != null) {

        DatabaseReference ref =
        FirebaseDatabase.instance.ref("UsersNotifications");

        await ref.child(playerId).set({
          "playerId": playerId,
        });

        debugPrint("Player ID Saved: $playerId");
      }
    });
  }
}