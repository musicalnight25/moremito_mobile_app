import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/common_web_view.dart';

// Adjust imports based on your project structure
import '../service/network_repository.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

class ShopMoremitoController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  // Changed initial value to false, so it only shows when triggered
  RxBool isLoading = false.obs;

  Future<void> getWebViewToken(String actionName) async {
    // 1. Start Loading
    isLoading.value = true;

    try {
      final response = await _networkRepository.getWebviewToken();

      if (response != null) {
        if (response['Status'] == true && response['Data'] != null) {
          String exchangeToken = response['Data']['exchangeToken'];

          String finalUrl =
              "https://moremito.com/MobileWebView/MemberPage?actionName=$actionName&token=$exchangeToken";

          _loadUrl(finalUrl);
        } else {
          _handleError(response['Message'] ?? "Failed to generate token");
        }
      } else {
        _handleError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _handleError("Connection Error: $e");
    } finally {
      // 2. Stop Loading (always runs, success or fail)
      isLoading.value = false;
    }
  }

  void _loadUrl(String url) {
    Get.to(() => CommonWebView(url: url, title: "Shop Moremito"));
  }

  void _handleError(String message) {
    CommonMethod.getXSnackBar("Error", message, redColor);
  }
}
