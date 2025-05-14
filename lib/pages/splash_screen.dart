// import 'dart:async';
// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:more_mitro_app/pages/login_screen.dart';
// import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
// import 'package:more_mitro_app/pages/start_survey_screen.dart';
// import 'package:more_mitro_app/utils/app_asset.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import '../utils/base_background_widget.dart';
// import '../utils/preferences_util.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   Timer? timer;
//
//   Future onSelectNotification(String? payLoadData) async {
//     log("----------payLoadData------>> $payLoadData");
//     if (payLoadData == null) {
//       await Get.to(() => Placeholder());
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     timer?.cancel();
//   }
//
//   @override
//   void initState() {
//     startTime();
//     super.initState();
//   }
//
//   notifcationPermistion() async {
//     await Permission.notification.request();
//   }
//
//   startTime() async {
//     timer = Timer(
//       const Duration(milliseconds: 3000),
//       () async {
//         String? userToken = await PreferencesUtil.getUserToken() ?? null;
//         bool isSurveyCompleted = await PreferencesUtil.getIsSurveyCompleted();
//
//         if (userToken != null) {
//           if (isSurveyCompleted) {
//             Get.offAll(() => MainHomeScreen());
//           } else {
//             Get.offAll(() => StartSurveyScreen());
//           }
//         } else {
//           Get.offAll(() => LoginScreen());
//         }
//       },
//     );
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
//       notifcationPermistion();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       body: BaseBackgroundWidget(
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 AppAsset.logo,
//                 width: 300.sp,
//                 height: 50.sp,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
