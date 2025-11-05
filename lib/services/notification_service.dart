import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      await _fcm.requestPermission();
      final token = await _fcm.getToken();
      // Save token to your DB under user profile for server push targeting
      print('FCM token: $token');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // handle foreground messages
        print('Foreground message: ${message.notification?.title}');
      });
    } catch (e) {
      print('FCM init error: $e');
    }
  }
}
