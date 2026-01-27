import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/service/network_dio.dart';
import 'package:more_mitro_app/utils/app_constants.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

import 'error_logger.dart';

class NetworkRepository {
  static final NetworkRepository _instance = NetworkRepository._internal();

  factory NetworkRepository() => _instance;

  NetworkRepository._internal();

  FocusNode searchFocus = FocusNode();

  // Prevent showing multiple session expiry alerts
  bool _isSessionExpiredShown = false;
  String? _lastApiEndpoint;

  Future<dynamic> postRequest(
    BuildContext? context,
    String endpoint, {
    var data,
  }) async {
    _lastApiEndpoint = endpoint; // ✅ ADD

    try {
      final response = await NetworkDioHttp.post(
        context: context,
        url: AppConstants.apiEndPoint + endpoint,
        data: data,
      );
      return _processResponse(response);
    } catch (e, stack) {
      return _handleError(e, stack);
    }
  }

  Future<dynamic> getRequest(
    BuildContext? context,
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    _lastApiEndpoint = endpoint; // ✅ ADD

    try {
      final response = await NetworkDioHttp.get(
        context: context,
        queryParameters: queryParameters,
        url: AppConstants.apiEndPoint + endpoint,
      );
      return _processResponse(response);
    } catch (e, stack) {
      return _handleError(e, stack);
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

  Future<dynamic> getSurveyResponses(BuildContext? context) =>
      getRequest(context, AppConstants.getSurveyResponses);

  Future<dynamic> getCategoriesList() =>
      getRequest(null, AppConstants.getCategories);

  Future<dynamic> getDashboard(BuildContext? context) =>
      getRequest(context, AppConstants.getDashboard);

  Future<dynamic> getOrders(var queryParameters) =>
      getRequest(null, AppConstants.getOrders,
          queryParameters: queryParameters);

  Future<dynamic> getOrderDetail(BuildContext? context, int orderid) =>
      getRequest(context, AppConstants.getOrderDetail,
          queryParameters: {'orderid': orderid});

  Future<dynamic> getSupportTickets(BuildContext? context,
          {int sortBy = 0, int filter = 0}) =>
      getRequest(context,
          AppConstants.getSupportTickets + '?sortBy=$sortBy&filter=$filter');

  Future<dynamic> getTicketPriorities(BuildContext? context) =>
      getRequest(context, AppConstants.getTicketPriorities);

  Future<dynamic> getTicketModules(BuildContext? context) =>
      getRequest(context, AppConstants.getTicketModules);

  Future<dynamic> getTmrisContent() =>
      getRequest(null, AppConstants.getTmrisContent);

  Future<dynamic> getPushNotificationSettings() =>
      getRequest(null, AppConstants.getPushNotificationSettings);

  Future<dynamic> getTicketComments(BuildContext? context, var ticketId) =>
      getRequest(context,
          AppConstants.getTicketComments + "?TicketId=${ticketId.toString()}");

  Future<dynamic> createSupportTicket(BuildContext? context, var data) =>
      postRequest(context, AppConstants.createSupportTicket, data: data);

  Future<dynamic> addTicketComment(BuildContext? context, var data) =>
      postRequest(context, AppConstants.addTicketComment, data: data);

  Future<dynamic> getCallDetails(
          {BuildContext? context,
          required String id,
          required String templateName}) =>
      getRequest(context,
          AppConstants.getCallDetails + "Id=$id&TemplateName=$templateName");

  Future<dynamic> getAnnouncementDetails(
          {BuildContext? context, required String annId}) =>
      getRequest(context, AppConstants.getAnnouncementDetails + annId);

  Future<dynamic> getNotification(
          {BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getNotification,
          queryParameters: queryParameters);

  Future<dynamic> getSharedFlyers(var queryParameters) =>
      getRequest(null, AppConstants.getSharedFlyers,
          queryParameters: queryParameters);

  Future<dynamic> getFlyerInteractions(var queryParameters) =>
      getRequest(null, AppConstants.getFlyerInteractions,
          queryParameters: queryParameters);

  Future<dynamic> getLinkActivityDetails(var queryParameters) =>
      getRequest(null, AppConstants.getLinkActivityDetails,
          queryParameters: queryParameters);

  Future<dynamic> getFlyerTrackingStats() => getRequest(
        null,
        AppConstants.getFlyerTrackingStats,
      );

  Future<dynamic> getNotificationDetail(
          BuildContext? context, String notificationId) =>
      getRequest(context, AppConstants.getNotificationDetail + notificationId);

  Future<dynamic> getSubCategories(BuildContext? context, String categoryID) =>
      getRequest(null, AppConstants.getSubCategories + categoryID);

  Future<dynamic> getSubCategoriesFiles(
    BuildContext? context,
    String subCategoryId, {
    String? searchText,
    int pageNumber = 1,
  }) async {
    final params = {
      "SubCategoryId": subCategoryId,
      "SearchText": searchText,
      "PageNumber": pageNumber.toString(),
    };

    return getRequest(
      null,
      AppConstants.getSubCategoriesFiles,
      queryParameters: params,
    );
  }

  Future<dynamic> mobileSaveFileShare(BuildContext context, var data) =>
      postRequest(context, AppConstants.mobileSaveFileShare, data: data);

  Future<dynamic> generateLink(BuildContext context, var data) =>
      postRequest(context, AppConstants.generateLink, data: data);

  Future<dynamic> generateFlyerShareLink(BuildContext context, var data) =>
      postRequest(context, AppConstants.generateFlyerShareLink, data: data);

  Future<dynamic> getMyLeads({BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getMyLeads,
          queryParameters: queryParameters);

  Future<dynamic> archiveLead({BuildContext? context, var data}) =>
      postRequest(context, AppConstants.archiveLead, data: data);

  Future<dynamic> archiveTmrisLead({BuildContext? context, var data}) =>
      postRequest(context, AppConstants.archiveTmrisLead, data: data);

  Future<dynamic> updateMyProfile({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.updateMyProfile, data: body);

  Future<dynamic> getTmrisLeads({BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getTmrisLeads,
          queryParameters: queryParameters);

  Future<dynamic> getMyProfile({BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getMyProfile,
          queryParameters: queryParameters);

  Future<dynamic> getFlyerTemplates(
          {BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getFlyerTemplates,
          queryParameters: queryParameters);

  Future<dynamic> getFlyerTemplateDetail(
          {BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getFlyerTemplateDetail,
          queryParameters: queryParameters);

  Future<dynamic> getFlyerPreview(
          {BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getFlyerPreview,
          queryParameters: queryParameters);

  Future<dynamic> getMyAddresses(
          {BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getMyAddresses,
          queryParameters: queryParameters);

  Future<dynamic> getWelcomeTag({BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getWelcomeTag,
          queryParameters: queryParameters);

  Future<dynamic> getUserRoleInfo(
          {BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getUserRoleInfo,
          queryParameters: queryParameters);

  Future<dynamic> saveAddress({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.saveAddress, data: body);

  Future<dynamic> updateWelcomeTag({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.updateWelcomeTag, data: body);

  Future<dynamic> changePassword({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.changePassword, data: body);

  Future<dynamic> changeUserRole({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.changeUserRole, data: body);

  Future<dynamic> savePushNotificationSetting(
          {BuildContext? context, var body}) =>
      postRequest(context, AppConstants.savePushNotificationSetting,
          data: body);

  Future<dynamic> savePushNotificationSettingsBulk(
          {BuildContext? context, var body}) =>
      postRequest(context, AppConstants.savePushNotificationSettingsBulk,
          data: body);

  Future<dynamic> saveFlyerDetails({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.saveFlyerDetails, data: body);

  Future<dynamic> markAllNotificationsRead({BuildContext? context, var body}) =>
      postRequest(context, AppConstants.markAllNotificationsRead, data: body);

  Future<dynamic> saveLeadNotes({required var data}) async {
    return postRequest(
      null,
      AppConstants.saveLeadNotes,
      data: data,
    );
  }

  Future<dynamic> markLeadAsContacted({required var data}) async {
    return postRequest(
      null,
      AppConstants.markLeadAsContacted,
      data: data,
    );
  }

  Future<dynamic> getWebviewToken() async {
    return postRequest(
      null,
      AppConstants.getWebviewToken,
      data: null,
    );
  }

  Future<dynamic> getDeepLinks(BuildContext? context) =>
      getRequest(context, AppConstants.deepLinks);

  Future<dynamic> getRankInfo({BuildContext? context, var queryParameters}) =>
      getRequest(context, AppConstants.getRankInfo,
          queryParameters: queryParameters);

  Future<dynamic> getMyCompensationHistory({BuildContext? context}) =>
      getRequest(context, AppConstants.myCompensationHistory);

  Future<dynamic> getMyCompensationHistoryByYear(
          {BuildContext? context, required int year}) =>
      getRequest(context, '${AppConstants.myCompensationHistoryYear}/$year');

  Future<dynamic> getMyCompensationHistoryByMonth(
          {BuildContext? context, required int year, required int month}) =>
      getRequest(context,
          '${AppConstants.myCompensationHistoryYear}/$year/month/$month');

  Future<dynamic> getMyDailyCompensations(
      {required Map<String, dynamic> data}) {
    return postRequest(
      null,
      AppConstants.myCompensationsGrouped,
      data: data,
    );
  }

  Future<dynamic> getMyCompensationsByOrder(int orderId) {
    return getRequest(
      null,
      '${AppConstants.myCompensationsByOrder}/$orderId',
    );
  }

  Future<dynamic> getMyCompensationsByDateRange(
      {required Map<String, dynamic> data}) {
    return postRequest(
      null,
      AppConstants.myCompensations,
      data: data,
    );
  }

  Future<dynamic> getMyCommissionRequestHistory({BuildContext? context}) =>
      getRequest(context, AppConstants.myCommissionRequestHistory);

  Future<dynamic> getMyCashTransferHistory({BuildContext? context}) =>
      getRequest(context, AppConstants.myCashTransferHistory);

  // Compensation spent on orders
  Future<dynamic> getMyCommissionSpent({
    required Map<String, dynamic> data,
  }) {
    return postRequest(
      null,
      AppConstants.myCommissionSpent,
      data: data,
    );
  }

  // Cash sent to others
  Future<dynamic> getMyCashSentHistory({BuildContext? context}) {
    return getRequest(context, AppConstants.myCashSentHistory);
  }

  Future<dynamic> getCountries() {
    return getRequest(null, AppConstants.getCountries);
  }

  Future<dynamic> getStates(int countryId) {
    return getRequest(null, AppConstants.getStates,
        queryParameters: {'CountryId': countryId});
  }

  Future<dynamic> getMyReferralOrders({BuildContext? context}) =>
      getRequest(context, AppConstants.myReferralOrders);

  Future<dynamic> getMyReferralOrderDetail({
    required int orderId,
    required int orderOwnerId,
    BuildContext? context,
  }) =>
      getRequest(
        context,
        "${AppConstants.myReferralOrderDetail}?OrderId=$orderId&OrderOwnerId=$orderOwnerId",
      );

  Future<dynamic> getDownlineOrders({
    required Map<String, dynamic> data,
  }) {
    return postRequest(
      null,
      AppConstants.downlineOrders,
      data: data,
    );
  }

  Future<dynamic> getDownlineOrderDetails({
    required int orderId,
    required int userId,
  }) {
    return getRequest(
      null,
      '${AppConstants.downlineOrderDetails}?OrderId=$orderId&userId=$userId',
    );
  }

  // ---------- INTERNAL HANDLERS ----------

  dynamic _processResponse(Map<String, dynamic> response) {
    final int statusCode = response['statusCode'] ?? 0;
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

    // 🖨️ EXACT LOG YOU WANT
    log(
      "--------message------$errorMessage",
    );

    // 🚀 SEND TO SERVER
    ErrorLogger.logErrorToServer(
      pageType: "NetworkRepository",
      actionType: _lastApiEndpoint ?? "Unknown API",
      errorMessage1: errorMessage,
      errorMessage2: "StatusCode: $statusCode",
      errorMessage3:
          "Endpoint: ${AppConstants.apiEndPoint}${_lastApiEndpoint ?? ''}",
    );

    CommonMethod.getXSnackBar("Error", errorMessage, redColor);
    return null;
  }

  void _handleSessionExpiry() {
    if (_isSessionExpiredShown) return; // ✅ Prevent multiple calls

    _isSessionExpiredShown = true;

    // Check if already on LoginScreen
    final isAlreadyOnLogin = Get.currentRoute.toLowerCase().contains('login');
    if (isAlreadyOnLogin) {
      CommonMethod.getXSnackBar(
        "Error",
        "Invalid username or password.",
        redColor,
      );
    } else {
      CommonMethod.getXSnackBar(
        "Access Denied!",
        "Session expired. Please log in again.",
        redColor,
      );
    }
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

  dynamic _handleError(Object e, StackTrace stackTrace) {
    final message = e.toString();

    log("--------message------$message");

    ErrorLogger.logErrorToServer(
      pageType: "NetworkRepository",
      actionType: _lastApiEndpoint ?? "Unknown API",
      errorMessage1: message,
      errorMessage2: stackTrace.toString(),
      errorMessage3: "Runtime exception",
    );

    CommonMethod.getXSnackBar("Error", message, redColor);
    return null;
  }

  bool _isSuccess(int status) => status == 200 || status == 201;
}
