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
        "Login Failed",
        "Please check your credentials.",
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
