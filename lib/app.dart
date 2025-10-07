import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/login_screen.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
import 'package:more_mitro_app/pages/start_survey_screen.dart';

import 'utils/app_text_style.dart';
import 'utils/colors.dart';
import 'utils/preferences_util.dart';

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

class MoreMitoApp extends StatefulWidget {
  const MoreMitoApp({Key? key}) : super(key: key);

  @override
  _MoreMitoAppState createState() => _MoreMitoAppState();
}

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "navigator");

class _MoreMitoAppState extends State<MoreMitoApp> with WidgetsBindingObserver {
  late FirebaseMessaging messaging;

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final deviceWidth = constraints.maxWidth;
      final deviceHeight = constraints.maxHeight;
      const baseWidth = 360.0;
      const baseHeight = 800.0;
      final scaleFactorWidth = deviceWidth / baseWidth;
      final scaleFactorHeight = deviceHeight / baseHeight;
      final designSize = Size(
        baseWidth * scaleFactorWidth.clamp(1.0, 2.0),
        baseHeight * scaleFactorHeight.clamp(1.0, 2.0),
      );
      return ScreenUtilInit(
        designSize: designSize,
        minTextAdapt: true,
        fontSizeResolver: (fontSize, instance) {
          final display = View.of(context).display;
          final screenSize = display.size / display.devicePixelRatio;
          final scaleWidth = screenSize.width / designSize.width;
          return fontSize * scaleWidth;
        },
        splitScreenMode: true,
        builder: (BuildContext context, Widget? child) {
          return GetMaterialApp(
            useInheritedMediaQuery: true,
            fallbackLocale: const Locale('en', 'US'),
            defaultTransition: Transition.fadeIn,
            navigatorKey: navigatorKey,
            title: 'MoreMito',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primaryColor: primaryBlack,
              hintColor: primaryBlack,
              useMaterial3: true,
              fontFamily: "Manrope",
              iconTheme: IconThemeData(color: primaryBlack, size: 24),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 16.sp, // Larger font size for TextButton
                    fontWeight: FontWeight.w600, // Semi-bold text
                  ),
                ),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white, // Set dialog background color
                titleTextStyle: AppTextStyle.normalBold18, // Set title color
                contentTextStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ), // Set content color
              ),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(
                  primaryBlack.value,
                  {
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
              scaffoldBackgroundColor: Colors.white,
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
            ),
            darkTheme: ThemeData(
              primaryColor: primaryBlack,
              hintColor: primaryBlack,
              fontFamily: "Manrope",
              iconTheme: IconThemeData(color: primaryBlack, size: 24),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  textStyle: TextStyle(
                    fontSize: 16.sp, // Larger font size for TextButton
                    fontWeight: FontWeight.w600, // Semi-bold text
                  ),
                ),
              ),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: MaterialColor(
                  primaryBlack.value,
                  {
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
              scaffoldBackgroundColor: Colors.white,
              dialogTheme: DialogThemeData(
                backgroundColor: Colors.white, // Set dialog background color
                titleTextStyle: AppTextStyle.normalBold18, // Set title color
                contentTextStyle: TextStyle(
                  color: Colors.black54,
                  fontSize: 16.sp,
                ), // Set content color
              ),
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
            ),
            themeMode: ThemeMode.light,
            home: FutureBuilder<Widget>(
              future: _getInitialPage(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data!;
                } else {
                  return Placeholder(); // Default fallback
                }
              },
            ),
          );
        },
      );
    });
  }

  Future<Widget> _getInitialPage() async {
    String? userToken = await PreferencesUtil.getUserToken() ?? null;
    bool isSurveyCompleted = await PreferencesUtil.getIsSurveyCompleted();

    if (userToken != null) {
      if (isSurveyCompleted) {
        return MainHomeScreen();
      } else {
        return StartSurveyScreen();
      }
    } else {
      return LoginScreen();
    }
  }
}
