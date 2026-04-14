import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/pages/auth/login_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import 'app_text_style.dart';
import 'colors.dart';
import 'common_bottom_sheet.dart';
import 'preferences_util.dart';
import 'static_decoration.dart';

extension ByteListEquality on List<int> {
  bool equals(List<int> other) {
    if (length != other.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}

class CommonMethod {
  static void changeLanguage(String languageCode, String countryCode) {
    var locale = Locale(languageCode, countryCode);
    Get.updateLocale(locale);
  }

  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return "-";

    try {
      return DateFormat("dd-MM-yyyy").format(dateTime);
    } catch (e) {
      return "-";
    }
  }

  static String formatDateFromDateTime(DateTime? dateTime) {
    if (dateTime == null) return "-";

    try {
      return DateFormat("MMM dd, yyyy").format(dateTime);
    } catch (e) {
      return "-";
    }
  }

  static String formatFullDateFromDateTime(DateTime? dateTime) {
    if (dateTime == null) return "-";

    try {
      return DateFormat("MMMM dd, yyyy 'at' hh:mm a").format(dateTime);
    } catch (e) {
      return "-";
    }
  }

  static bool isBottomSheetOpen = false;

  static getXSnackBar(String title, String message, Color? color,
      {SnackPosition? snackPosition}) {
    final BuildContext? currentContext =
        Get.key.currentContext ?? Get.context ?? Get.overlayContext;

    if (currentContext == null) {
      debugPrint("Snackbar skipped (no overlay): $title - $message");
      return;
    }

    final scaffoldMessenger = ScaffoldMessenger.maybeOf(currentContext);
    if (scaffoldMessenger != null) {
      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor:
                color?.withOpacity(0.9) ?? primaryBlack.withOpacity(0.8),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      return;
    }

    if (Get.key.currentState?.overlay == null) {
      debugPrint("Snackbar skipped (overlay unavailable): $title - $message");
      return;
    }

    try {
      Get.snackbar(
        title,
        message,
        backgroundColor:
            color?.withOpacity(0.9) ?? primaryBlack.withOpacity(0.8),
        colorText: primaryWhite,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        duration: const Duration(seconds: 3),
        borderRadius: 15,
        barBlur: 20,
        borderColor: Colors.white.withOpacity(0.5),
        borderWidth: 1,
        snackPosition: snackPosition ?? SnackPosition.TOP,
        titleText: Text(title,
            style: AppTextStyle.normalBold18.copyWith(color: primaryWhite)),
        messageText: Text(
          message,
          style: AppTextStyle.normalRegular16.copyWith(
            color: Colors.white70,
          ),
        ),
        icon: Icon(
          Icons.info_outline,
          color: primaryWhite,
        ),
        animationDuration: const Duration(milliseconds: 300),
        forwardAnimationCurve: Curves.easeInOut,
        reverseAnimationCurve: Curves.easeInOut,
      );
    } catch (e) {
      debugPrint("Snackbar failed: $e");
    }
  }

  static String getFileNameFromPath(String filePath) {
    return filePath.split('/').last;
  }

  static int calculateDateDiff({
    required DateTime startDate,
    DateTime? endDate,
  }) {
    final _startDate = startDate;
    final _currentDate = endDate ?? DateTime.now();
    final duration = _startDate.difference(_currentDate);
    return duration.inDays;
  }

  static String getRenewalDate({
    required DateTime? startDate,
    required int durationInDays,
  }) {
    try {
      // Validate inputs
      if (durationInDays < 0) {
        throw ArgumentError("Duration in days must be non-negative.");
      }

      // If startDate is null, use the current date
      if (startDate == null) {
        startDate = DateTime.now().toUtc();
      } else {
        startDate = startDate.toUtc();
      }

      // Add the duration to the UTC start date
      final renewalDate = startDate.add(Duration(days: durationInDays));

      // Adjust to local timezone after calculating the renewal date
      DateTime localRenewalDate = renewalDate.toLocal();

      // Ensure that the localRenewalDate keeps the expected day
      if (localRenewalDate.day != startDate.day) {
        localRenewalDate = localRenewalDate.add(Duration(days: 1));
      }

      // Format the date to the desired format "d MMMM yyyy"
      final formattedDate = DateFormat('d MMMM yyyy').format(localRenewalDate);

      return formattedDate;
    } catch (e) {
      // Handle errors and return a default value or error message
      print("Error calculating renewal date: $e");
      return "Invalid date";
    }
  }

  static String getProfileText(String fullName) {
    // Split the full name by spaces
    List<String> nameParts = fullName.trim().split(' ');

    // Extract the first character of the first and last name
    String initials = '';

    if (nameParts.isNotEmpty) {
      // Always add the first initial
      initials += nameParts[0][0].toUpperCase();

      // If there are more than one part, add the initial of the last name
      if (nameParts.length > 1) {
        initials += nameParts[nameParts.length - 1][0].toUpperCase();
      }
    }

    return initials;
  }

  static Future logOutUser() async {
    // Reset dashboard data if HomeController exists
    try {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().resetDashboard();
        Get.delete<HomeController>();
      }
    } catch (e) {
      debugPrint("⚠ Error resetting HomeController on logout: $e");
    }

    await PreferencesUtil.clear();
    PreferencesUtil.clearRememberMe();
    final isAlreadyOnLogin = Get.currentRoute.toLowerCase().contains('login');

    if (isAlreadyOnLogin) return;
    Get.offAll(() => LoginScreen());
  }

  static Future<String> getDeviceToken() async {
    try {
      String? deviceId;

      final messaging = FirebaseMessaging.instance;

      // 🔹 Android Logic
      if (Platform.isAndroid) {
        try {
          final settings = await messaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
          );

          if (settings.authorizationStatus != AuthorizationStatus.denied) {
            deviceId = await messaging.getToken();
            if (deviceId != null && deviceId.isNotEmpty) {
              log("📱 Android FCM Token (original): $deviceId");
              return deviceId; // ✅ return original token directly
            }
          }
        } catch (e) {
          log("⚠️ Android token fetch error: $e");
        }
      }
      // 🔹 iOS Logic
      else if (Platform.isIOS) {
        try {
          final settings = await messaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
          );

          if (settings.authorizationStatus != AuthorizationStatus.denied) {
            deviceId = await messaging.getToken();
            if (deviceId != null && deviceId.isNotEmpty) {
              log("🍏 iOS FCM/APNs Token (original): $deviceId");
              return deviceId; // ✅ return original token directly
            }
          }
        } catch (e) {
          log("⚠️ iOS token fetch error: $e");
          CommonMethod.getXSnackBar(
            "Test".tr,
            "⚠️ iOS token fetch error: {error}".trParams({
              "error": e.toString(),
            }),
            primaryColor,
          );
        }

        // 🔁 Fallback: identifierForVendor
        if (deviceId == null || deviceId.isEmpty) {
          try {
            final deviceInfo = DeviceInfoPlugin();
            final iosInfo = await deviceInfo.iosInfo;
            deviceId = iosInfo.identifierForVendor;
            if (deviceId != null && deviceId.isNotEmpty) {
              log("🍏 iOS identifierForVendor: $deviceId");
              return deviceId; // ✅ return vendor ID directly
            }
          } catch (e) {
            log("⚠️ iOS identifierForVendor error: $e");
          }
        }
      }

      // 🔹 Fallback (common)
      if (deviceId == null || deviceId.isEmpty) {
        deviceId = _generateLongId();
        log("⚙️ Using generated fallback ID: $deviceId");
      }

      return deviceId;
    } catch (e, st) {
      log("❌ Error generating device ID: $e", stackTrace: st);
      return _generateLongId();
    }
  }

  // 🧩 Generates a fallback long random ID
  static String _generateLongId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final randomPart = const Uuid().v4();
    final longId =
        sha256.convert(utf8.encode("$timestamp-$randomPart")).toString();
    return longId;
  }

  static showLostConnecationDialog() {
    return CommonMethod.showCustomBottomSheet(
      title: "Lost Connection".tr,
      messageWidget: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // Aligns children vertically in the center
            crossAxisAlignment: CrossAxisAlignment.center,
            // Aligns children horizontally in the center
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Worry not! ',
                      style: AppTextStyle.normalRegular16
                          .copyWith(color: lightBlackColor),
                    ),
                    TextSpan(
                      text: 'Your recording is safe.',
                      style: AppTextStyle.normalRegular16.copyWith(
                        color: lightBlackColor,
                        decoration: TextDecoration.underline,
                        decorationColor: lightBlackColor,
                      ),
                    ),
                    TextSpan(
                      text:
                          'You can retry once your connection is restored.\n\n',
                      style: AppTextStyle.normalRegular14.copyWith(
                        color: lightBlackColor,
                      ),
                    ),
                    TextSpan(
                      text: 'What you can do:',
                      style: AppTextStyle.normalBold16.copyWith(
                        color: lightBlackColor,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "•  ".tr,
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: lightBlackColor),
                  ),
                  Flexible(
                    child: Text(
                      "Check your internet connection.".tr,
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: lightBlackColor),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "•  ".tr,
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: lightBlackColor),
                  ),
                  Flexible(
                    child: Text(
                      "Try again in a few moments.".tr,
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: lightBlackColor),
                    ),
                  ),
                ],
              ),
              height08,
            ],
          ),
        ),
      ),
      confirmButtonTitle: "Got it",
      onConfirm: () {
        Get.back();
        isBottomSheetOpen = false;
      },
      message: null,
    );
  }

  static Future<bool> requestPermissions() async {
    var microphoneStatus = await Permission.microphone.status;
    if (!microphoneStatus.isGranted) {
      await Permission.microphone.request();
      microphoneStatus = await Permission.microphone.status;
    }

    var mediaStatus = await Permission.mediaLibrary.status;
    if (!mediaStatus.isGranted) {
      await Permission.mediaLibrary.request();
      mediaStatus = await Permission.mediaLibrary.status;
    }

    var notificationStatus = await Permission.notification.status;
    if (!notificationStatus.isGranted) {
      await Permission.notification.request();
      notificationStatus = await Permission.notification.status;
    }

    if (!microphoneStatus.isGranted || !mediaStatus.isGranted) {
      if (microphoneStatus.isPermanentlyDenied) {
        _showPermissionDeniedDialog("Microphone");
      }
      if (mediaStatus.isPermanentlyDenied) {
        _showPermissionDeniedDialog("Media Library");
      }
      if (notificationStatus.isPermanentlyDenied) {
        _showPermissionDeniedDialog("Notification");
      }

      return false;
    }
    return true;
  }

  static Future<void> showSimpleDialog({
    String? title,
    bool? hideContent,
    Widget? titleWidget,
    Widget? iconWidget,
    required Widget child,
    required BuildContext context,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: primaryBlack.withOpacity(.3),
      builder: (BuildContext context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: AlertDialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 15.sp),
// contentPadding: EdgeInsets.zero,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          contentPadding: EdgeInsets.symmetric(
              horizontal: hideContent != null && hideContent ? 0 : 15),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),

          content: Padding(
            padding: EdgeInsets.all(15.sp),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: hideContent != null && hideContent ? 0 : 20),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void _showPermissionDeniedDialog(String permission) {
    Get.defaultDialog(
      title: "Permission Required".tr,
      content: Text(
        "Please grant {permission} permission in the settings.".trParams({
          "permission": permission,
        }),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            openAppSettings();
          },
          child: Text("Open Settings".tr),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text("Cancel".tr),
        ),
      ],
    );
  }

  static String generatePasswordResetLink(String token) {
    final Uri uri = Uri(
      scheme: 'myapp',
      host: 'resetpassword',
      queryParameters: {
        'token': token,
      },
    );

    return uri.toString();
  }

  static showCustomBottomSheet({
    required String title,
    required String? message,
    String? confirmButtonTitle,
    String? cancelButtonTitle,
    Widget? messageWidget,
    Widget? customWidget,
    IconData? icon,
    Color? confirmButtonColor,
    Color? confirmButtonTextColor,
    Color? cancelButtonTextColor,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool? showCancelButton,
  }) {
    Get.bottomSheet(
      CommonBottomSheet(
        title: title,
        message: message,
        confirmButtonTitle: confirmButtonTitle ?? "Done",
        cancelButtonTitle: cancelButtonTitle,
        messageWidget: messageWidget,
        icon: icon,
        confirmButtonColor: confirmButtonColor,
        confirmButtonTextColor: confirmButtonTextColor,
        cancelButtonTextColor: cancelButtonTextColor,
        onConfirm: onConfirm ??
            () {
              Get.back();
            },
        customWidget: customWidget,
        onCancel: onCancel,
        showCancelButton: showCancelButton,
      ),
      backgroundColor: primaryWhite,
      isScrollControlled: true,
    );
  }

  static String formatDateTime(DateTime? date) {
    if (date == null) return "-";

    try {
      return DateFormat('yyyy-MM-dd hh:mm a').format(date);
    } catch (e) {
      return "-";
    }
  }

  // Converts ISO 8601 date string to IST and formats as "hh:mm a"
  static String formatTimeIsoDateString(String isoDateString) {
    DateTime parsedDate = DateTime.parse(isoDateString);
    DateTime indianDate = parsedDate.add(Duration(hours: 5, minutes: 30));
    String formattedTime =
        DateFormat('dd MMM yyyy, hh:mm a').format(indianDate);
    return formattedTime;
  }

// Helper function to validate file size
  static bool isFileSizeValid(File file, int maxSizeInMB) {
    final fileSizeInBytes = file.lengthSync();
    final fileSizeInMB = fileSizeInBytes / (1024 * 1024);

    log('-------fileSizeInMB-------${fileSizeInMB}');
    log('-------maxSizeInMB-------${maxSizeInMB}');
    return fileSizeInMB <= maxSizeInMB;
  }

  static bool isMarkdownTable(String markdown) {
    // Trim the leading and trailing whitespace
    markdown = markdown.trim();

    // Split the Markdown into lines
    List<String> lines = markdown.split('\n');

    // Check if the Markdown has at least one line for header and one line for separator
    if (lines.length < 3) return false;

    // Check if the second line contains table separator (|---|)
    if (!lines[1].contains('|') || !lines[1].contains('-')) return false;

    // Validate the header line
    if (!lines[0].contains('|')) return false;

    // Check if each row contains the same number of columns
    int columnCount =
        lines[0].split('|').length - 1; // Number of columns in the header row

    for (var line in lines.skip(2)) {
      // Skip header and separator lines
      if (line.split('|').length - 1 != columnCount)
        return false; // Check column count consistency
    }

    // If all checks passed, the Markdown contains a valid table format
    return true;
  }
}
