import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/auth/login_screen.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
import 'package:more_mitro_app/pages/auth/start_survey_screen.dart';
import 'package:more_mitro_app/service/pop_up_service.dart';

import 'utils/app_text_style.dart';
import 'utils/colors.dart';
import 'utils/preferences_util.dart';

// ------------------------------------------------------------
// Notification streams
// ------------------------------------------------------------
final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}

// ------------------------------------------------------------
// Root App Widget
// ------------------------------------------------------------
class MoreMitoApp extends StatefulWidget {
  const MoreMitoApp({Key? key}) : super(key: key);

  @override
  State<MoreMitoApp> createState() => _MoreMitoAppState();
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "navigator");

class _MoreMitoAppState extends State<MoreMitoApp> with WidgetsBindingObserver {
  late final FirebaseMessaging messaging;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    messaging = FirebaseMessaging.instance;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    selectNotificationStream.close();
    didReceiveLocalNotificationStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceWidth = constraints.maxWidth;
        final deviceHeight = constraints.maxHeight;

        // Fixed base sizes
        const baseWidth = 360.0;
        const baseHeight = 800.0;

        final designSize = Size(baseWidth, baseHeight);

        return ScreenUtilInit(
          designSize: designSize,
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (_, __) {
            // ✅ At this point ScreenUtil is initialized
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_popupShown) {
                _popupShown = true;
                PopupService.runAppChecks();
              }
            });

            return GetMaterialApp(
              navigatorKey: navigatorKey,
              title: 'MoreMito',
              debugShowCheckedModeBanner: false,
              useInheritedMediaQuery: true,
              fallbackLocale: const Locale('en', 'US'),
              defaultTransition: Transition.fadeIn,
              themeMode: ThemeMode.light,
              theme: _buildThemeData(),
              darkTheme: _buildThemeData(),
              home: FutureBuilder<Widget>(
                future: _getInitialPage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasData) {
                    return snapshot.data!;
                  } else {
                    return const Scaffold(
                      body: Center(child: Text("Something went wrong")),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  ThemeData _buildThemeData() {
    return ThemeData(
      useMaterial3: true,
      primaryColor: primaryBlack,
      hintColor: primaryBlack,
      fontFamily: "Manrope",
      scaffoldBackgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: primaryBlack, size: 24),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: AppTextStyle.normalSemiBold16,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        titleTextStyle: AppTextStyle.normalBold18,
        contentTextStyle: AppTextStyle.normalRegular16,
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: MaterialColor(
          primaryBlack.value,
          const {
            50: primaryBlack,
            100: primaryBlack,
            200: primaryBlack,
            300: primaryBlack,
            400: primaryBlack,
            500: primaryBlack,
            600: primaryBlack,
            700: primaryBlack,
            800: primaryBlack,
            900: primaryBlack,
          },
        ),
      ).copyWith(surface: primaryWhite),
      textTheme: TextTheme(
        displayLarge: AppTextStyle.normalBold32,
        displayMedium: AppTextStyle.normalBold28,
        displaySmall: AppTextStyle.normalBold24,
        headlineMedium: AppTextStyle.normalBold20,
        headlineSmall: AppTextStyle.normalBold18,
        titleLarge: AppTextStyle.normalBold16,
        titleMedium: AppTextStyle.normalBold14,
        titleSmall: AppTextStyle.normalBold12,
        bodyLarge: AppTextStyle.normalRegular18,
        bodyMedium: AppTextStyle.normalRegular16,
        bodySmall: AppTextStyle.normalRegular14,
        labelLarge: AppTextStyle.normalBold10,
        labelMedium: AppTextStyle.normalRegular12,
        labelSmall: AppTextStyle.normalRegular8,
      ),
    );
  }

  Future<Widget> _getInitialPage() async {
    final userToken = await PreferencesUtil.getUserToken();
    final isSurveyCompleted = await PreferencesUtil.getIsSurveyCompleted();

    if (userToken != null) {
      return isSurveyCompleted ? MainHomeScreen() : StartSurveyScreen();
    } else {
      return LoginScreen();
    }
  }
}
