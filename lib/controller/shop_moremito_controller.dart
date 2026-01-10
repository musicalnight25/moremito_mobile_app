import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/common_web_view.dart';
import '../service/webview_helper.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

class ShopMoremitoController extends GetxController {
  Future<void> getShopMoremitoWebview(String actionName) async {
    await WebviewHelper.getDynamicWebviewURL(
      actionName: actionName,
      page: "MemberPage",
      onSuccess: (url) {
        Get.to(() => CommonWebView(url: url, title: "Shop Moremito"));
      },
      onError: (msg) {
        CommonMethod.getXSnackBar("Error", msg, redColor);
      },
    );
  }
}
