import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import 'package:more_mitro_app/service/error_logger.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

class ChangePasswordController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  final currentPasswordCtrl = TextEditingController();
  final newPasswordCtrl = TextEditingController();
  final confirmPasswordCtrl = TextEditingController();

  RxBool isLoading = false.obs;

  Future<void> changePassword() async {
    // 1. Validation
    if (currentPasswordCtrl.text.isEmpty ||
        newPasswordCtrl.text.isEmpty ||
        confirmPasswordCtrl.text.isEmpty) {
      CommonMethod.getXSnackBar(
          "Required", "Please fill in all fields", Colors.red);
      return;
    }

    if (newPasswordCtrl.text != confirmPasswordCtrl.text) {
      CommonMethod.getXSnackBar(
          "Mismatch",
          "New password and confirm password do not match",
          snackPosition: SnackPosition.BOTTOM,
          Colors.red);
      return;
    }

    // Optional: Check min length
    if (newPasswordCtrl.text.length < 6) {
      CommonMethod.getXSnackBar("Weak Password",
          "Password must be at least 6 characters", Colors.red);
      return;
    }

    // 2. API Call
    try {
      isLoading.value = true;
      FocusManager.instance.primaryFocus?.unfocus(); // Hide keyboard

      final response = await _repo.changePassword(
        body: {
          "CurrentPassword": currentPasswordCtrl.text.trim(),
          "NewPassword": newPasswordCtrl.text.trim(),
          "ConfirmPassword": confirmPasswordCtrl.text.trim(),
        },
      );

      if (response != null && response["Status"] == true) {
        Get.back(); // Return to settings

        CommonMethod.getXSnackBar(
            "Success", "Password updated successfully", greenColor);
      } else {
        // Handle API specific error message if available
        String msg = response?["Message"] ?? "Failed to update password";
        CommonMethod.getXSnackBar("Error", msg, Colors.red);
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "ChangePassword",
        actionType: "Update",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
      CommonMethod.getXSnackBar(
          "Error", "Something went wrong. Please try again.", Colors.red);
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
