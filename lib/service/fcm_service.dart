import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/app.dart';
import 'package:more_mitro_app/pages/notification/notification_details_screen.dart';

import '../utils/colors.dart';

class FcmService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'notification_id',
    'NotificationName',
    description: 'notifications',
    importance: Importance.max,
    playSound: true,
    enableVibration: true,
  );

  Future<FcmService> init() async {
    log('🔔 Initializing FCM Service...');

    await _initializeLocalNotifications();
    await _setupFirebaseListeners();

    log('✅ FCM Service initialized successfully');
    return this;
  }

  Future<void> _initializeLocalNotifications() async {
    const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        ));

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNotificationNavigation(data);
        }
      },
    );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> _setupFirebaseListeners() async {
    final messaging = FirebaseMessaging.instance;

    // iOS permissions
    await messaging.requestPermission(alert: true, badge: true, sound: true);

    // Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        displayNotification(notification, message.data);
      }
    });

    // When app is in background and tapped
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('📩 onMessageOpenedApp triggered');
      _handleNotificationNavigation(message.data);
    });

    // When app was terminated and opened from tap
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      log('🚀 getInitialMessage triggered');
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationNavigation(initialMessage.data);
      });
    }
  }

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

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    log("🧭 Navigating with data: $data");

    if (!data.containsKey('id')) return;

    // Use Navigator safely with delay to ensure context is ready
    Future.delayed(const Duration(milliseconds: 400), () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NotificationDetailsScreen(notificationId: data['id']),
        ),
      );
    });
  }

  // For background FCM (Android)
  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    final notification = message.notification;
    if (notification != null) {
      final service = FcmService();
      service.displayNotification(notification, message.data);
    }
  }
}
