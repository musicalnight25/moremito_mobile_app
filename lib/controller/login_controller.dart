import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

import '../model/login_model.dart';
import '../model/survey_questions_model.dart';
import '../service/error_logger.dart';
import '../utils/preferences_util.dart';

class LoginController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      usernameController.text = "shubham";
      passwordController.text = "Hello@#7777#";
    }
    _loadRememberedUser();
  }

  Future<void> _loadRememberedUser() async {
    final isEnabled = await PreferencesUtil.isRememberMeEnabled();
    rememberMe.value = isEnabled;

    if (isEnabled) {
      String? savedUser = await PreferencesUtil.getSavedUsername();
      String? savedPass = await PreferencesUtil.getSavedPassword();

      if (savedUser != null) usernameController.text = savedUser;
      if (savedPass != null) passwordController.text = savedPass;
    }
  }

  Future<void> fetchAndSetLanguage() async {
    try {
      debugPrint("🌐 Fetching language preference from API...");
      // Call GET /api/mobile/language to fetch saved language preference
      final response = await _networkRepository.getLanguage(null);

      debugPrint("📋 Full API Response: $response");

      if (response != null && response is Map) {
        debugPrint("📋 Response Data: ${response['Data']}");
        debugPrint("📋 Response data (lowercase): ${response['data']}");

        // Try different response field names (API uses LanguageCode in Data object)
        final languageCode = response['Data']?['LanguageCode']?.toString() ??
            response['data']?['LanguageCode']?.toString();

        debugPrint("📋 Extracted LanguageCode: $languageCode");

        final language = languageCode?.toLowerCase() ?? 'en';

        debugPrint("✅ Language preference from API: $language");

        if (language == 'zh') {
          Get.updateLocale(const Locale('zh', 'CN'));
          await PreferencesUtil.saveLanguagePreference('zh');
          debugPrint("✅ ✅ ✅ Language loaded: Chinese (中文) 🇨🇳");
        } else {
          Get.updateLocale(const Locale('en', 'US'));
          await PreferencesUtil.saveLanguagePreference('en');
          debugPrint("✅ ✅ ✅ Language loaded: English 🇬🇧");
        }
      } else {
        // Fallback to cached preference
        debugPrint(
            "⚠️ No response from GET language API, using cached preference");
        await _setLanguageFromCache();
      }
    } catch (e) {
      debugPrint("❌ Error fetching language: $e");
      // Fallback to cached preference
      await _setLanguageFromCache();
    }
  }

  Future<void> _setLanguageFromCache() async {
    try {
      final cachedLanguage = await PreferencesUtil.getLanguagePreference();
      if (cachedLanguage == 'zh') {
        Get.updateLocale(const Locale('zh', 'CN'));
        debugPrint("✅ ✅ ✅ Language loaded from cache: Chinese (中文) 🇨🇳");
      } else {
        Get.updateLocale(const Locale('en', 'US'));
        debugPrint("✅ ✅ ✅ Language loaded from cache: English 🇬🇧");
      }
    } catch (e) {
      debugPrint("❌ Error loading cached language: $e");
      Get.updateLocale(Get.deviceLocale ?? const Locale('en', 'US'));
      debugPrint("✅ Language set to device locale");
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _networkRepository.logout(context);
      debugPrint("User logged out successfully.");
    } catch (e, stack) {
      debugPrint("Error in logout: $e");
      await ErrorLogger.logErrorToServer(
        pageType: "Logout",
        actionType: "LogoutRequest",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }

  Future<void> loginWithPassword(BuildContext context) async {
    final data = {
      'UserName': usernameController.text.trim(),
      'Password': passwordController.text.trim(),
    };

    try {
      var response = await _networkRepository.loginWithPassword(context, data);

      if (response != null) {
        final loginUserModel =
            loginResponseModelFromJson(json.encode(response));

        if (loginUserModel.status == true && loginUserModel.data != null) {
          await PreferencesUtil.saveUserToken(loginUserModel);
          // ✅ SAVE REMEMBER ME STATE
          await PreferencesUtil.saveRememberMe(
            rememberMe: rememberMe.value,
            username: usernameController.text.trim(),
            password: passwordController.text.trim(),
          );
        }
      }
    } catch (e, stack) {
      debugPrint("Error in loginWithPassword: $e");
      CommonMethod.getXSnackBar(
        "Login Failed".tr,
        "Please check your credentials.".tr,
        redColor,
      );

      // ✅ Log the error to backend
      await ErrorLogger.logErrorToServer(
        pageType: "Login",
        actionType: "LoginBtnClick",
        errorMessage1: e.toString(),
        errorMessage2: "Login Failed",
        errorMessage3: stack.toString(),
      );
    }
  }

  Future<void> registerDeviceToken() async {
    try {
      var token = await CommonMethod.getDeviceToken();
      final data = {'DeviceToken': token};
      await _networkRepository.registerDeviceToken(data);
    } catch (e, stack) {
      debugPrint("Error in registerDeviceToken: $e");
      await ErrorLogger.logErrorToServer(
        pageType: "DeviceToken",
        actionType: "RegisterToken",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }
}
