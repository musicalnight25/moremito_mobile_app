import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import '../utils/common_method.dart';
import '../utils/internet_error.dart';
import '../utils/preferences_util.dart';
import '../utils/process_indicator.dart';
import 'error_logger.dart';
import 'network_repository.dart';

class NetworkDioHttp {
  static final Dio _dio = Dio();
  static String? endPointUrl;
  static final Circle processIndicator = Circle();
  static final InternetError internetError = InternetError();
  static final NetworkRepository networkRepository = NetworkRepository();
  static bool _isBottomSheetOpen = false;

  static Future<Map<String, String>> _getHeaders() async {
    final String? token = await PreferencesUtil.getUserToken();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<void> setDynamicHeader({String? endPoint}) async {
    endPointUrl = endPoint;
    final headers = await _getHeaders();

    _dio.options = BaseOptions(
      receiveTimeout: 30000, // 30 seconds
      connectTimeout: 30000, // 30 seconds
      headers: headers,
    );
    _dio.interceptors.clear();

    _dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onResponse: (response, handler) {
          if (kDebugMode) {
            logRequestAndResponse(response.requestOptions, response);
          }
          handler.next(response);
        },
        onError: (DioError error, ErrorInterceptorHandler handler) async {
          logError(error);
          if (_isConnectionError(error)) _showInternetErrorOverlay(Get.context);
          if (error.response?.statusCode == 401)
            await _handleUnauthorizedError();
          handler.next(error);
        },
      ),
    ]);
  }

  static void logRequestAndResponse(RequestOptions request, Response response) {
    final String curlCommand = generateCurlCommand(
      '${request.uri}',
      request.method,
      request.headers,
      request.data,
    );
    log("$curlCommand\n\n📨 Response (${response.statusCode}):\n${formatJsonData(response.data)}\n");
  }

  /// Logs Response details
  static void logResponse(Response response) {
    log("\n📨 Response (${response.statusCode}): ${formatJsonData(response.data)}\n");
  }

  /// Logs error details
  static Future<void> logError(DioError error) async {
    final int? statusCode = error.response?.statusCode;

    // ⛔ Don't log or report 401 errors
    if (statusCode == 401) {
      return;
    }

    final String curlCommand = generateCurlCommand(
      '${error.requestOptions.uri}',
      error.requestOptions.method,
      error.requestOptions.headers,
      error.requestOptions.data,
    );
    log("❌ Error:\n${curlCommand}\n");

    final String errorMessage = error.message;
    final String? deviceId = await CommonMethod.getDeviceToken();

    final Map<String, dynamic> safeErrorData = {
      "statusCode": statusCode,
      "errorMessage": errorMessage,
      "deviceId": deviceId,
    };

    log("❌ Error (Safe Log): $safeErrorData");

    ErrorLogger.logErrorToServer(
      pageType: "NetworkDioHttp",
      actionType: error.requestOptions.path,
      errorMessage1: errorMessage,
      errorMessage2: statusCode?.toString(),
      errorMessage3: deviceId,
    );

    if (error.response != null) {
      logResponse(error.response!);
    }
  }

  /// Formats JSON for better readability
  static String formatJsonData(dynamic jsonData) {
    try {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
      return prettyJson;
    } catch (e) {
      return jsonData.toString();
    }
  }

  /// Generates a cURL command from request details
  static String generateCurlCommand(
    String url,
    String method,
    Map<String, dynamic>? headers,
    dynamic body,
  ) {
    StringBuffer curl = StringBuffer("curl -X $method '$url' \\\n");

    if (headers != null) {
      headers.forEach((key, value) {
        curl.write("-H \"$key: $value\" \\\n");
      });
    }

    if (body != null && body is Map) {
      curl.write("-d '${jsonEncode(body)}' \\\n");
    } else if (body != null && body is String) {
      curl.write("-d '${body.replaceAll("'", "\\'")}' \\\n");
    }

    return curl.toString().trim();
  }

  /// Formats JSON for better readability
  String formatJson(dynamic jsonData) {
    try {
      final prettyJson = const JsonEncoder.withIndent('  ').convert(jsonData);
      return prettyJson;
    } catch (e) {
      return jsonData.toString();
    }
  }

  static Future<void> _handleUnauthorizedError() async {
    CommonMethod.logOutUser();
  }

  static bool _isConnectionError(DioError error) {
    return error.type == DioErrorType.other && error.error is SocketException;
  }

  static Future<bool> _checkConnectivity() async {
    try {
      return true; // Implement actual connectivity check if needed
    } catch (e) {
      log('Error checking connectivity: $e');
      return false;
    }
  }

  static Future<String> _handleError(
      DioError error, BuildContext? context) async {
    log("Dio Error: $error");

    String errorDescription = '';
    if (error.response != null) {
      final responseData = error.response?.data;
      String? serverMessage = responseData is Map<String, dynamic>
          ? responseData['Message'] as String?
          : null;

      errorDescription =
          serverMessage ?? _getDefaultErrorMessage(error.response!.statusCode);
      if (error.response!.statusCode == 401) await _handleUnauthorizedError();
    }

    return errorDescription;
  }

  static String _getDefaultErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      default:
        return 'Unknown error';
    }
  }

  static Future<Map<String, dynamic>> _request({
    required BuildContext? context,
    required String url,
    required Future<Response> Function() request,
  }) async {
    if (!await _checkConnectivity()) {
      _showInternetErrorOverlay(context);
      return {'error_description': 'No internet connection'};
    }

    _showProcessIndicator(context);

    try {
      final Response response = await request();
      return {
        'statusCode': response.statusCode,
        'body': response.data,
        'headers': response.headers.map
      };
    } on DioError catch (e) {
      final errorDescription = await _handleError(e, context);
      return {
        'statusCode': e.response?.statusCode,
        'body': e.response?.data,
        'headers': e.response?.headers.map,
        'error_description': errorDescription
      };
    } catch (e) {
      log("General Error: $e");
      return {'error_description': 'Unknown error occurred'};
    } finally {
      _hideProcessIndicator(context);
    }
  }

  static Future<Map<String, dynamic>> get({
    required BuildContext? context,
    required String url,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _request(
      context: context,
      url: url,
      request: () async => _dio.get(url,
          queryParameters: queryParameters,
          options: Options(headers: await _getHeaders())),
    );
  }

  static Future<Map<String, dynamic>> post({
    required BuildContext? context,
    required String url,
    required dynamic data,
    Function(int, int)? onSendProgress,
    bool includeAuthHeader = true, // ✅ new flag
  }) async {
    final headers = includeAuthHeader
        ? await _getHeaders()
        : {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          };
    return _request(
      context: context,
      url: url,
      request: () async => _dio.post(url,
          data: data,
          options: Options(headers: headers),
          onSendProgress: onSendProgress),
    );
  }

  static Future<Map<String, dynamic>> put({
    required BuildContext? context,
    required String url,
    required dynamic data,
    Function(int, int)? onSendProgress,
  }) async {
    return _request(
      context: context,
      url: url,
      request: () => _dio.put(url, data: data, onSendProgress: onSendProgress),
    );
  }

  static Future<Map<String, dynamic>> delete({
    required BuildContext? context,
    required String url,
    Map<String, dynamic>? queryParameters,
    dynamic data,
  }) async {
    return _request(
      context: context,
      url: url,
      request: () =>
          _dio.delete(url, queryParameters: queryParameters, data: data),
    );
  }

  static void _showInternetErrorOverlay(BuildContext? context) {
    if (_isBottomSheetOpen || context == null) return;
    _isBottomSheetOpen = true;
    internetError
        .addOverlayEntry(context)
        .then((_) => _isBottomSheetOpen = false);
  }

  static void _showProcessIndicator(BuildContext? context) {
    if (context != null) processIndicator.show(context);
  }

  static void _hideProcessIndicator(BuildContext? context) {
    if (context != null) processIndicator.hide(context);
  }
}
