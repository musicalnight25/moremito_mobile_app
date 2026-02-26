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

import 'firebase_options.dart';

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = MyHttpOverrides();

  /// Register Background FCM Handler BEFORE Firebase is used
  /// This runs in a separate isolate; uses SharedPreferences to update badge count
  FirebaseMessaging.onBackgroundMessage(FcmService.fcmBackgroundHandler);

  /// Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Preferences
  await PreferencesUtil.init();

  /// Initialize FCM Service (Firebase must be ready first)
  final fcmService = Get.put(FcmService());
  await fcmService.init();

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
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
