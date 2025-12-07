import 'dart:developer';

import 'network_dio.dart';

class ErrorLogger {
  static bool _isLogging = false; // <--- prevents looping

  static const String _apiUrl = "https://moremito.com/api/mobile/save-error";

  static Future<void> logErrorToServer({
    required String pageType,
    required String actionType,
    required String errorMessage1,
    String? errorMessage2,
    String? errorMessage3,
  }) async {
    // STOP LOOPING
    if (_isLogging) return;
    _isLogging = true;

    final data = {
      "PageType": pageType,
      "ActionType": actionType,
      "ErrorMessage1": errorMessage1,
      "ErrorMessage2": errorMessage2 ?? "",
      "ErrorMessage3": errorMessage3 ?? "",
    };

    try {
      await NetworkDioHttp.post(
        context: null,
        url: _apiUrl,
        data: data,
        includeAuthHeader: false,
      );

      log("🪵 [Error Logged] $data");
    } catch (e) {
      log("❌ ErrorLogger failed (NOT logging again): $e");
    } finally {
      _isLogging = false;
    }
  }
}
