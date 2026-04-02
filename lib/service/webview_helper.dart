import 'package:get/get.dart';
import '../service/network_repository.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/process_indicator.dart';

class WebviewHelper {
  static final NetworkRepository _networkRepository = NetworkRepository();
  static final Circle processIndicator = Circle();

  static Future<void> getDynamicWebviewURL({
    required String actionName,
    required String page,
    String? id,
    required Function(String url) onSuccess,
  }) async {
    processIndicator.show(Get.context);
    try {
      final response = await _networkRepository.getWebviewToken();

      if (response != null &&
          response['Status'] == true &&
          response['Data'] != null) {
        final exchangeToken = response['Data']['exchangeToken'];
        final finalUrl = Uri.https(
          'moremito.com',
          '/MobileWebView/$page',
          {
            'actionName': actionName,
            'token': exchangeToken,
            if (id != null) 'id': id,
          },
        ).toString();
        onSuccess(finalUrl);
      } else {
        CommonMethod.getXSnackBar("Error",
            response?['Message'] ?? "Failed to generate token", redColor);
      }
    } catch (e) {
      CommonMethod.getXSnackBar("Error".tr, "Connection Error: $e".tr, redColor);
    } finally {
      processIndicator.hide(Get.context);
    }
  }
}
