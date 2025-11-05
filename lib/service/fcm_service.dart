import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/notification_details_screen.dart';

import '../utils/colors.dart';

class FcmService extends GetxService {
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification_id',
    'NotificationName',
    description: 'notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableVibration: true,
    audioAttributesUsage: AudioAttributesUsage.notification,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 🔔 Display notification with payload
  void displayNotification(
      RemoteNotification notification, Map<String, dynamic> data) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          color: primaryColor,
          importance: Importance.max,
          playSound: true,
          icon: '@mipmap/ic_launcher',
          sound:
              const RawResourceAndroidNotificationSound('notification_sound'),
        ),
      ),
      payload: jsonEncode(data), // ✅ store structured JSON
    );
  }

  // 🚀 Unified handler for navigation after tapping notification
  Future<void> _handleNotificationNavigation(Map<String, dynamic> data) async {
    log("🔔 Notification clicked with data: $data");

    try {
      // if (data.containsKey('type')) {
      //   switch (data['type']) {
      //     case 'offer':
      //       // Get.to(() => OfferDetailScreen(offerId: data['id']));
      //       break;
      //     case 'chat':
      //       // Get.to(() => ChatScreen(chatId: data['id']));
      //       break;
      //     default:
      //       Get.to(() => NotificationDetailsScreen(notificationId: data['id']));
      //   }
      // } else
      if (data.containsKey('id')) {
        Get.to(() => NotificationDetailsScreen(notificationId: data['id']));
      }
    } catch (e) {
      log('⚠️ Navigation error: $e');
    }
  }

  // 💤 Background FCM message handler
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null) {
      final service = FcmService();
      service.displayNotification(notification, message.data);
    }
  }

  void handleBackground() {
    FirebaseMessaging.onBackgroundMessage(FcmService.fcmBackgroundHandler);
  }

  // 📱 Foreground FCM message handler
  void handleForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      final android = message.notification?.android;
      if (notification != null && android != null) {
        displayNotification(notification, message.data);
      }
    });
  }

  // 🧭 Handle notification taps (local + remote)
  void setupNotificationClickHandler() {
    // 1️⃣ When app is opened from background (tap FCM)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });

    // 2️⃣ When app is opened from terminated state
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationNavigation(message.data);
      }
    });

    // 3️⃣ When user taps a local notification (foreground)
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          try {
            final Map<String, dynamic> data =
                Map<String, dynamic>.from(jsonDecode(response.payload!));
            log('📦 Local notification payload: $data');
            _handleNotificationNavigation(data);
          } catch (e) {
            log('⚠️ Failed to decode payload: $e');
          }
        }
      },
    );
  }

  // 🚀 Initialize FCM service
  Future<FcmService> init() async {
    log('$runtimeType initialized!');
    await Firebase.initializeApp();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    handleBackground();
    handleForeground();
    setupNotificationClickHandler();
    return this;
  }
}
