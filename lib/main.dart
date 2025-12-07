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

// MUST IMPORT THIS
import 'firebase_options.dart';

/// ------------------------------------------------------------
///  BACKGROUND HANDLER (MUST USE SAME FIREBASE OPTIONS)
/// ------------------------------------------------------------
Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  log("🔔 Background message received: ${message.messageId}");
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  /// ------------------------------------------------------------
  /// Register Background Handler BEFORE FirebaseMessaging is used
  /// ------------------------------------------------------------
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);

  /// ------------------------------------------------------------
  /// Initialize Firebase
  /// ------------------------------------------------------------
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Preferences
  await PreferencesUtil.init();

  /// ------------------------------------------------------------
  /// Initialize FCM Service FIRST (must be before Hive or others)
  /// ------------------------------------------------------------
  final fcmService = Get.put(FcmService());
  await fcmService.init(); // Safe now — Firebase already ready

  /// API & Hive
  await NetworkDioHttp.setDynamicHeader(endPoint: AppConstants.apiEndPoint);
  await Hive.initFlutter();
  await Hive.openBox('contactsBox');

  await initializeDateFormatting('en_IN', null);

  /// UI Configurations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MoreMitoApp());
}

/// Allow all SSL certs (dev only)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
  }
}
