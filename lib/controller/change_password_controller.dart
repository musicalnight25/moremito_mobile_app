import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../service/network_repository.dart';
import '../service/error_logger.dart';

class ChangePasswordController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool obscureCurrent = true.obs;
  RxBool obscureNew = true.obs;
  RxBool obscureConfirm = true.obs;

  Future<void> changePassword() async {
    if (currentPasswordCtrl.text.isEmpty ||
        newPasswordCtrl.text.isEmpty ||
        confirmPasswordCtrl.text.isEmpty) {
      Get.snackbar("Error", "All fields are required");
      return;
    }

    if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
      Get.snackbar("Error", "New password and confirm password do not match");
      return;
    }

    try {
      isLoading.value = true;

      final response = await _repo.changePassword(
        body: {
          "CurrentPassword": currentPasswordCtrl.text.trim(),
          "NewPassword": newPasswordCtrl.text.trim(),
          "ConfirmPassword": confirmPasswordCtrl.text.trim(),
        },
      );

      if (response != null && response["Status"] == true) {
        Get.snackbar("Success", "Password changed successfully");
        Get.back();
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "ChangePassword",
        actionType: "Update",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    currentPasswordCtrl.dispose();
    newPasswordCtrl.dispose();
    confirmPasswordCtrl.dispose();
    super.onClose();
  }
}
