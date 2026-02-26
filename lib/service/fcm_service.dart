import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/app.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
import 'package:more_mitro_app/pages/notification/notification_details_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colors.dart';

// SharedPreferences key for persisting badge count across isolates
const String _kBadgeCountKey = 'app_badge_count';

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
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // User tapped a notification → clear badge
        clearBadge();
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

    // ── FOREGROUND ──
    // When app is open and notification arrives, show it + update badge
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final notification = message.notification;
      if (notification != null) {
        final newCount = await _incrementPersistedBadge();
        displayNotification(notification, message.data, badgeCount: newCount);
        await _applyBadgeToLauncher(newCount);
      }
    });

    // ── BACKGROUND TAP ──
    // User tapped a background notification → clear badge and navigate
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('📩 onMessageOpenedApp triggered');
      clearBadge();
      _handleNotificationNavigation(message.data);
    });

    // ── TERMINATED TAP ──
    // App launched from a notification tap → clear badge and navigate
    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      log('🚀 getInitialMessage triggered');
      clearBadge();
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationNavigation(initialMessage.data);
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // DISPLAY
  // ─────────────────────────────────────────────────────────────────────────

  void displayNotification(
    RemoteNotification notification,
    Map<String, dynamic> data, {
    int badgeCount = 0,
  }) {
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
          number: badgeCount, // ← shows count on Android notification
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          badgeNumber: badgeCount, // ← updates iOS app icon badge
        ),
      ),
      payload: jsonEncode(data),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NAVIGATION
  // ─────────────────────────────────────────────────────────────────────────

  void _handleNotificationNavigation(Map<String, dynamic> data) {
    log("🧭 Navigating with data: $data");
    if (!data.containsKey('id')) return;
    Future.delayed(const Duration(milliseconds: 400), () {
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => NotificationDetailsScreen(notificationId: data['id']),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BADGE HELPERS  (static → usable from background isolate too)
  // ─────────────────────────────────────────────────────────────────────────

  /// Increment persisted count by 1, returns new count
  static Future<int> _incrementPersistedBadge() async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_kBadgeCountKey) ?? 0;
    final next = current + 1;
    await prefs.setInt(_kBadgeCountKey, next);
    return next;
  }

  /// Reset persisted count to 0
  static Future<void> _resetPersistedBadge() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBadgeCountKey, 0);
  }

  /// Actually set the launcher icon badge number
  static Future<void> _applyBadgeToLauncher(int count) async {
    try {
      final bool supported = await FlutterAppBadger.isAppBadgeSupported();
      if (!supported) return;

      if (count <= 0) {
        await FlutterAppBadger.removeBadge();
        log('✅ Launcher badge cleared');
      } else {
        await FlutterAppBadger.updateBadgeCount(count);
        log('🔴 Launcher badge set to $count');
      }
    } catch (e) {
      log('⚠️ Badge apply failed: $e');
    }
  }

  /// PUBLIC — Call this when user opens Notifications screen / marks all read
  /// Clears both the launcher icon badge AND the in-app counter
  static Future<void> clearBadge() async {
    await _resetPersistedBadge();
    unreadNotificationCount.value = 0;
    await _applyBadgeToLauncher(0);
  }

  /// PUBLIC — Call this to sync badge from API count (after getDashboard)
  static Future<void> syncBadgeFromApiCount(int apiCount) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kBadgeCountKey, apiCount);
    await _applyBadgeToLauncher(apiCount);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BACKGROUND HANDLER  (separate isolate — no GetX / reactive state)
  // ─────────────────────────────────────────────────────────────────────────

  static Future<void> fcmBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    log('🔔 Background message: ${message.messageId}');

    // Increment badge stored in SharedPreferences (works across isolates)
    final newCount = await _incrementPersistedBadge();
    await _applyBadgeToLauncher(newCount);

    log('🔴 Background badge count → $newCount');
  }
}
