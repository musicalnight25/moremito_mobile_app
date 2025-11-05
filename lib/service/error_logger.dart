import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:more_mitro_app/service/network_dio.dart';

class ErrorLogger {
  static const String _apiUrl = "https://moremito.com/api/mobile/save-error";

  /// Logs an error event to the backend.
  static Future<void> logErrorToServer({
    required String pageType,
    required String actionType,
    required String errorMessage1,
    String? errorMessage2,
    String? errorMessage3,
  }) async {
    final data = {
      "PageType": pageType,
      "ActionType": actionType,
      "ErrorMessage1": errorMessage1,
      "ErrorMessage2": errorMessage2 ?? "",
      "ErrorMessage3": errorMessage3 ?? "",
    };

    try {
      // Using the existing POST method (no token required)
      await NetworkDioHttp.post(
        context: null,
        url: _apiUrl,
        data: data,
        includeAuthHeader: false,
      );

      log("🪵 [Error Logged] $data");
    } on DioError catch (e) {
      log("❌ Failed to send error log: ${e.message}");
    } catch (e) {
      log("❌ ErrorLogger exception: $e");
    }
  }
}
