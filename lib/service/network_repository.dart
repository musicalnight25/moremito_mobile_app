import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:more_mitro_app/service/network_dio.dart';
import 'package:more_mitro_app/utils/app_constants.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

class NetworkRepository {
  static final NetworkRepository _instance = NetworkRepository._internal();
  factory NetworkRepository() => _instance;
  NetworkRepository._internal();

  FocusNode searchFocus = FocusNode();

  // Prevent showing multiple session expiry alerts
  bool _isSessionExpiredShown = false;

  Future<dynamic> postRequest(BuildContext? context, String endpoint,
      {var data}) async {
    try {
      final response = await NetworkDioHttp.post(
        context: context,
        url: AppConstants.apiEndPoint + endpoint,
        data: data,
      );
      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  Future<dynamic> getRequest(BuildContext? context, String endpoint) async {
    try {
      final response = await NetworkDioHttp.get(
        context: context,
        url: AppConstants.apiEndPoint + endpoint,
      );
      return _processResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // ---------- API METHODS ----------
  Future<dynamic> loginWithPassword(BuildContext context, var data) =>
      postRequest(context, AppConstants.loginWithPassword, data: data);
  Future<dynamic> logout(BuildContext context) =>
      postRequest(context, AppConstants.logout);
  Future<dynamic> registerDeviceToken(var data) =>
      postRequest(null, AppConstants.registerDeviceToken, data: data);
  Future<dynamic> saveSurvey(BuildContext context, var data) =>
      postRequest(context, AppConstants.saveSurvey, data: data);
  Future<dynamic> getSurveyQuestions(BuildContext? context) =>
      getRequest(context, AppConstants.getSurveyQuestions);
  Future<dynamic> getCategoriesList() =>
      getRequest(null, AppConstants.getCategories);
  Future<dynamic> getDashboard(BuildContext? context) =>
      getRequest(context, AppConstants.getDashboard);
  Future<dynamic> getCallDetails(
      {BuildContext? context, required String id, required String templateName}) =>
      getRequest(context, AppConstants.getCallDetails + "Id=$id&TemplateName=$templateName");
  Future<dynamic> getAnnouncementDetails(
      {BuildContext? context, required String annId}) =>
      getRequest(context, AppConstants.getAnnouncementDetails + annId);
  Future<dynamic> getNotification() =>
      getRequest(null, AppConstants.getNotification);
  Future<dynamic> getNotificationDetail(
          BuildContext? context, String notificationId) =>
      getRequest(context, AppConstants.getNotificationDetail + notificationId);
  Future<dynamic> getSubCategories(BuildContext? context, String categoryID) =>
      getRequest(context, AppConstants.getSubCategories + categoryID);
  Future<dynamic> getSubCategoriesFiles(
          BuildContext? context, String categoryID) =>
      getRequest(context, AppConstants.getSubCategoriesFiles + categoryID);
  Future<dynamic> mobileSaveFileShare(BuildContext context, var data) =>
      postRequest(context, AppConstants.mobileSaveFileShare, data: data);
  Future<dynamic> generateLink(BuildContext context, var data) =>
      postRequest(context, AppConstants.generateLink, data: data);

  // ---------- INTERNAL HANDLERS ----------

  dynamic _processResponse(Map<String, dynamic> response) {
    final statusCode = response['statusCode'] ?? 0;
    final body = response['body'];

    if (_isSuccess(statusCode)) {
      return body is Map<String, dynamic> && body.containsKey('body')
          ? body['body']
          : body;
    }

    if (statusCode == 401 || statusCode == 403 || statusCode == 410) {
      _handleSessionExpiry();
      return null;
    }

    final errorMessage = _extractErrorMessage(body);
    _showErrorDialog(errorMessage);
    return null;
  }

  void _handleSessionExpiry() {
    if (_isSessionExpiredShown) return; // ✅ Prevent multiple calls

    _isSessionExpiredShown = true;

    CommonMethod.getXSnackBar(
      "🔐 Access Denied!",
      "Either your session took a time warp ⏳ or your credentials don’t match our secret codes! 🔑 Try logging in again.",
      redColor,
    );

    // Delay logout slightly so snackbar shows first
    Future.delayed(const Duration(seconds: 1), () {
      CommonMethod.logOutUser();
      _isSessionExpiredShown = false; // Reset after logout
    });
  }

  String _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      if (body.containsKey('Message')) return body['Message'];
      if (body.containsKey('message')) return body['message'];
      if (body.containsKey('errors') &&
          body['errors'] is Map<String, dynamic>) {
        return (body['errors'] as Map<String, dynamic>)
            .entries
            .map((e) => '${e.key}: ${e.value.join(", ")}')
            .join("\n");
      }
    }
    return 'Unexpected server error occurred.';
  }

  void _showErrorDialog(String message) {
    log("--------message------$message");
    if (message.isNotEmpty) {
      CommonMethod.getXSnackBar("Error", message, redColor);
    }
  }

  dynamic _handleError(dynamic e) {
    _showErrorDialog(e.toString());
    return null;
  }

  bool _isSuccess(int status) => status == 200 || status == 201;
}
