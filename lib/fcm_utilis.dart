import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:live_score_app/main.dart';

class FcmUtilis {
  static Future<void> initialize() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      criticalAlert: true,
      sound: true,
    );

    // Foreground - App jokhon cholche
    FirebaseMessaging.onMessage.listen(_handleforegroundNotification);

    // Background/Minimize - Notification e click korle app e dhukbe
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundNotification);

    // Killed/Dead State - Background message handler
    FirebaseMessaging.onBackgroundMessage(handleBackgriundNotification);
  }

  static void _handleBackgroundNotification(RemoteMessage message) {
    print(message.data);
    print(message.notification?.title);
    print(message.notification?.body);
  }

  static void _handleforegroundNotification(RemoteMessage message) {
    print(message.data);
    print(message.notification?.title);
    print(message.notification?.body);

    // Navigatorkey check kora dorkar jeno context null na hoy
    if (MyApp.navigatorkey.currentState?.context != null) {
      showDialog(
        context: MyApp.navigatorkey.currentState!.context,
        builder: (ctx) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // Column ke choto rakhar jonno
                children: [
                  Text(
                    message.notification?.title ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(message.notification?.body ?? ''),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  static Future<String?> getFCMToken() async{
    //TODO: send to the backend while you are logging in
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken;

  }
  static Future<void> onRefreshToken() async{
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken){

      // TODO: send to backend api(refresh token
    });
  }


}

// Eta class er bairei thakte hobe (Top-level function)
Future<void> handleBackgriundNotification(RemoteMessage message) async {
  print("Background message received: ${message.notification?.title}");
}