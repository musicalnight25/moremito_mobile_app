import 'package:get/get.dart';
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/model/login_model.dart';
import 'package:more_mitro_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/main_dashboard_screen.dart';
import '../pages/start_survey_screen.dart';
import '../service/network_dio.dart';

class PreferencesUtil {
  static SharedPreferences? _prefs;

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
    LoginController loginController = Get.put(LoginController());

    try {
      if (loginUserModel.data != null && loginUserModel.data?.token != null) {
        await _prefs?.setString(
            'userToken', loginUserModel.data!.token.toString());
        await _prefs?.setBool('isSurveyCompleted',
            loginUserModel.data!.isSurveyCompleted ?? false);
        await NetworkDioHttp.setDynamicHeader(
            endPoint: AppConstants.apiEndPoint);
        if (loginUserModel.data!.isSurveyCompleted == true) {
          Get.offAll(() => MainHomeScreen());
        } else {
          await loginController.getSurveyQuestions(Get.context!);
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

  static bool isLoggedIn() {
    final String? token = getUserToken();
    return token != null && token.isNotEmpty;
  }
}
