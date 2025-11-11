import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/notification_details_screen.dart';

import '../utils/colors.dart';

class FcmService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Android Channel
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification_id',
    'NotificationName',
    description: 'notifications',
    importance: Importance.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notification_sound'),
    enableVibration: true,
  );

  // ✅ Show Notification
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
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  // ✅ Notification tap handler
  Future<void> _handleNotificationNavigation(Map<String, dynamic> data) async {
    log("Notification Click Data: $data");

    if (data.containsKey('id')) {
      Get.to(() => NotificationDetailsScreen(notificationId: data['id']));
    }
  }

  // ✅ Background Notification Handler
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    final notification = message.notification;
    if (notification != null) {
      final service = FcmService();
      service.displayNotification(notification, message.data);
    }
  }

  void handleBackground() {
    FirebaseMessaging.onBackgroundMessage(FcmService.fcmBackgroundHandler);
  }

  // ✅ Foreground notification handler
  void handleForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        displayNotification(notification, message.data);
      }
    });
  }

  // ✅ Handle notification taps
  void setupNotificationClickHandler() {
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationNavigation(message.data);
    });

    // Terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationNavigation(message.data);
      }
    });

    // Local tap
    flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNotificationNavigation(data);
        }
      },
    );
  }

  // ✅ Request iOS Permissions
  Future<void> requestIOSPermissions() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      sound: true,
    );
  }

  // ✅ Initialize Service
  Future<FcmService> init() async {
    log('$runtimeType initialized!');
    await Firebase.initializeApp();

    // iOS
    await requestIOSPermissions();

    // Create Android Channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // Show notification in foreground (iOS only)
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    handleBackground();
    handleForeground();
    setupNotificationClickHandler();
    return this;
  }
}
