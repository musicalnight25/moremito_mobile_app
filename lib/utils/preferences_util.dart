import 'package:get/get.dart';
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/model/login_model.dart';
import 'package:more_mitro_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/home_controller.dart';
import '../pages/main_dashboard_screen.dart';
import '../pages/auth/start_survey_screen.dart';
import '../service/network_dio.dart';

class PreferencesUtil {
  static SharedPreferences? _prefs;
  static const _rememberMeKey = "remember_me";
  static const _usernameKey = "saved_username";
  static const _passwordKey = "saved_password";

  // -------- REMEMBER ME --------
  static Future<void> saveRememberMe({
    required bool rememberMe,
    required String username,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, rememberMe);

    if (rememberMe) {
      await prefs.setString(_usernameKey, username);
      await prefs.setString(_passwordKey, password);
    } else {
      await prefs.remove(_usernameKey);
      await prefs.remove(_passwordKey);
    }
  }

  static Future<bool> isRememberMeEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false;
  }

  static Future<String?> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_usernameKey);
  }

  static Future<String?> getSavedPassword() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey);
  }

  // -------- CLEAR ON LOGOUT (optional) --------
  static Future<void> clearRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_rememberMeKey);
    await prefs.remove(_usernameKey);
    await prefs.remove(_passwordKey);
  }

  // Initialize SharedPreferences instance once (singleton)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<bool> saveString(String key, String value) async {
    try {
      return await _prefs?.setString(key, value) ?? false;
    } catch (e) {
      print('Error saving string: $e');
      return false;
    }
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<bool> saveInt(String key, int value) async {
    try {
      return await _prefs?.setInt(key, value) ?? false;
    } catch (e) {
      print('Error saving int: $e');
      return false;
    }
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<bool> saveBool(String key, bool value) async {
    try {
      return await _prefs?.setBool(key, value) ?? false;
    } catch (e) {
      print('Error saving bool: $e');
      return false;
    }
  }

  static bool getBool(String key, {bool defaultValue = false}) {
    return _prefs?.getBool(key) ?? defaultValue;
  }

  static Future<bool> remove(String key) async {
    try {
      return await _prefs?.remove(key) ?? false;
    } catch (e) {
      print('Error removing key: $e');
      return false;
    }
  }

  static Future<bool> clear() async {
    try {
      return await _prefs?.clear() ?? false;
    } catch (e) {
      print('Error clearing preferences: $e');
      return false;
    }
  }

  static Future<void> saveUserToken(LoginResponseModel loginUserModel) async {
    try {
      if (loginUserModel.data != null && loginUserModel.data?.token != null) {
        await _prefs?.setString(
            'userToken', loginUserModel.data!.token.toString());
        await _prefs?.setBool('isSurveyCompleted',
            loginUserModel.data!.isSurveyCompleted ?? false);
        await NetworkDioHttp.setDynamicHeader(
            endPoint: AppConstants.apiEndPoint);
        var homeController = Get.put(HomeController());
        homeController.dashboardModel.value = null;
        homeController.dashboardModel.refresh();
        if (loginUserModel.data!.isSurveyCompleted == true) {
          Get.offAll(() => MainHomeScreen());
        } else {
          Get.off(() => StartSurveyScreen());
        }
      }
    } catch (e) {
      print('Error saving user token: $e');
    }
  }

  static String? getUserToken() {
    return _prefs?.getString('userToken');
  }

  static bool getIsSurveyCompleted() {
    return _prefs?.getBool('isSurveyCompleted') ?? false;
  }

  static Future<void> setSurveyCompleted() async {
    try {
      await _prefs?.setBool('isSurveyCompleted', true);
    } catch (e) {
      print('Error setting survey completed: $e');
    }
  }

  static bool? getIsServiceEnable() {
    return _prefs?.getBool('service');
  }

  static Future<bool> setIsServiceEnable(bool isServiceEnable) async {
    try {
      return await _prefs?.setBool('service', isServiceEnable) ?? false;
    } catch (e) {
      print('Error setting service enable: $e');
      return false;
    }
  }

  // -------- LANGUAGE PREFERENCE --------
  static const _languageKey = "app_language";

  static Future<void> saveLanguagePreference(String languageCode) async {
    try {
      await _prefs?.setString(_languageKey, languageCode);
      print('✅ Language preference saved: $languageCode');
    } catch (e) {
      print('Error saving language preference: $e');
    }
  }

  static Future<String?> getLanguagePreference() async {
    try {
      return _prefs?.getString(_languageKey);
    } catch (e) {
      print('Error getting language preference: $e');
      return null;
    }
  }

  static bool isLoggedIn() {
    final String? token = getUserToken();
    return token != null && token.isNotEmpty;
  }
}
