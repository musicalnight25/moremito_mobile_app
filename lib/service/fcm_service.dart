import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/state_manager.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';

import '../utils/colors.dart';

class FcmService extends GetxService {
  //pre-config
  final AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'notification_id', // id
      'NotificationName', // name
      description: 'notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('notification_sound'),
      enableVibration: true,
      audioAttributesUsage: AudioAttributesUsage.notification);

  //init local notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

//Print Fcm Token
  Future<String?> getToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    print(token);
    return token;
  }

  //Display Notification
  displayNotification(RemoteNotification notification) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'notification_id',
            channel.name,
            color: primaryColor,
            importance: Importance.max,
            colorized: true,
            playSound: true,
            icon: '@mipmap/ic_launcher',
            sound:
                const RawResourceAndroidNotificationSound('notification_sound'),
          ),
        ));
  }

  //Background
  Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      displayNotification(notification);
    }
  }

  handleBackground() {
    //BackGround Handler
    FirebaseMessaging.onBackgroundMessage(_fcmBackgroundHandler);
  }

  handleForeground() {
    //Foreground Handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        displayNotification(notification);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeController.getDashboard();
        });
      }
    });
  }

  Future<FcmService> init() async {
    print('$runtimeType is ready!');

    await Firebase.initializeApp(
        //options: DefaultFirebaseOptions.currentPlatform,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    //
    handleForeground();
    //Token
    //getToken();
    return this;
  }
}
