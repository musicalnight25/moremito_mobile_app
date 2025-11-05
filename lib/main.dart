import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:more_mitro_app/app.dart';
import 'package:more_mitro_app/service/fcm_service.dart';
import 'package:more_mitro_app/service/network_dio.dart';
import 'package:more_mitro_app/utils/app_constants.dart';
import 'package:more_mitro_app/utils/preferences_util.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  log("Handling background message: ${message.messageId}");
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();
  await PreferencesUtil
      .init(); // ✅ Register background handler before Firebase.initializeApp()
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  await Firebase.initializeApp();

  // Set notification display options for foreground messages (iOS)
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Handle Notification Permission and FCM token
  await _initializeFirebaseMessaging();

  // Set app-wide headers
  await NetworkDioHttp.setDynamicHeader(endPoint: AppConstants.apiEndPoint);

  // UI settings
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize services
  await Get.putAsync(() => FcmService().init());
  Get.put(() => FcmService().handleBackground());
  await Hive.initFlutter();
  await Hive.openBox('contactsBox');

  // Initialize localization and start app
  await initializeDateFormatting('en_IN', null);

  // Enable fullscreen / edge-to-edge
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Make status bar transparent
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    ),
  );
  runApp(const MoreMitoApp());
}

Future<void> _initializeFirebaseMessaging() async {
  final messaging = FirebaseMessaging.instance;

  if (Platform.isIOS) {
    // Request iOS notification permission
    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');

    // Wait for APNs token (real device only)
    final apnsToken = await messaging.getAPNSToken();
    log("APNs Token: $apnsToken");

    if (apnsToken == null) {
      log("⚠️ APNs token not yet available (likely simulator).");
      return;
    }
  }

  // Get the FCM token
  try {
    final fcmToken = await messaging.getToken();
    log("✅ FCM Token: $fcmToken");
  } catch (e) {
    log("❌ Error getting FCM token: $e");
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
