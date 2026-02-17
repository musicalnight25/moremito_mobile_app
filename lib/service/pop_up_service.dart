import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_asset.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/primary_text_button.dart';

class PopupService {
  /// Master check: runs maintenance -> update.json -> popup
  static Future<void> runAppChecks() async {
    log("-----runAppChecks----");
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 30),
          minimumFetchInterval: const Duration(seconds: 10),
        ),
      );
      await remoteConfig.fetchAndActivate();

      // 🔹 Then check update.json
      await checkForUpdate();
    } catch (e) {
      log("----Error in runAppChecks: $e");
    }
  }

  /// Check for app update based on Remote Config values
  static Future<void> checkForUpdate() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    try {
      final bool showUpdateDialog = remoteConfig.getBool('show_update_dialog');
      if (!showUpdateDialog) return;

      log("------ showUpdateDialog----$showUpdateDialog");
      final String latestVersion = Platform.isAndroid
          ? remoteConfig.getString('latest_version_android')
          : remoteConfig.getString('latest_version_ios');
      log("------ latestVersion----$latestVersion");
      final bool forceUpdate = remoteConfig.getBool('force_update');
      log("------ force_update----$forceUpdate");

      final String updateTitle =
          remoteConfig.getString('update_title').isNotEmpty
              ? remoteConfig.getString('update_title')
              : "Update Required 🚨";
      log("------ update_title----$updateTitle");

      final String updateMessage = remoteConfig
              .getString('update_message')
              .isNotEmpty
          ? remoteConfig.getString('update_message')
          : "We’ve made big improvements and added awesome new features.\n\nPlease update to continue using the app.";
      log("------ update_message----$updateMessage");

      final String appUrl = Platform.isAndroid
          ? "https://play.google.com/store/apps/details?id=com.moremito.app"
          : "https://apps.apple.com/us/app/moremito-learn-earn-grow/id6753805953";

      final packageInfo = await PackageInfo.fromPlatform();
      final String currentVersion = packageInfo.version;

      log("------ currentVersion ---- $currentVersion");
      log("------ latestVersion ---- $latestVersion");

      // 🔹 Compare versions semantically
      if (_isVersionLower(currentVersion, latestVersion)) {
        _showUpdateDialog(
          title: updateTitle,
          message: updateMessage,
          appUrl: appUrl,
          forceUpdate: forceUpdate,
        );
      }
    } catch (e) {
      log("Error fetching Remote Config: $e");
    }
  }

  /// Semantic version comparison (returns true if current < latest)
  static bool _isVersionLower(String current, String latest) {
    try {
      final currentParts = current.split('.').map(int.parse).toList();
      final latestParts = latest.split('.').map(int.parse).toList();

      for (int i = 0; i < latestParts.length; i++) {
        final curr = i < currentParts.length ? currentParts[i] : 0;
        final lat = latestParts[i];

        if (curr < lat) return true;
        if (curr > lat) return false;
      }
      return false;
    } catch (e) {
      log("Version parsing error: $e");
      return current != latest; // fallback to != check
    }
  }

  /// Shows the update dialog (Force or Soft)
  static void _showUpdateDialog({
    required String title,
    required String message,
    required String appUrl,
    required bool forceUpdate,
  }) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => !forceUpdate,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 40,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
            backgroundColor: primaryWhite,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Lottie.asset(
                        AppAsset.update,
                        height: 200,
                        repeat: true,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 20),
                      Text(
                        title,
                        style: AppTextStyle.normalBold20,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        message,
                        style: AppTextStyle.normalRegular16.copyWith(
                          color: lightBlackColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (forceUpdate) ...[
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'This update is mandatory',
                            style: AppTextStyle.normalSemiBold14.copyWith(
                              color: primaryColor,
                            ),
                          ),
                        ),
                      ],
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: PrimaryTextButton(
                          title: "Update Now",
                          onPressed: () => launchUrl(
                            Uri.parse(appUrl),
                            // mode: LaunchMode.externalApplication,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!forceUpdate)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () async => Get.back(),
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: !forceUpdate,
    );
  }
}
