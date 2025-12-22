import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';

import '../model/welcome_tag_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class WelcomeTagController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  Rxn<WelcomeTagModel> welcomeTag = Rxn<WelcomeTagModel>();
  RxBool isLoading = false.obs;

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();

  RxBool useDisplay = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWelcomeTag();
  }

  // ───────────────── FETCH ─────────────────
  Future<void> fetchWelcomeTag() async {
    try {
      isLoading.value = true;

      final response = await _repo.getWelcomeTag();

      if (response != null) {
        final model = welcomeTagResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          welcomeTag.value = model.data;

          nameCtrl.text = model.data!.welcomeName ?? "";
          emailCtrl.text = model.data!.welcomeEmail ?? "";
          phoneCtrl.text = model.data!.welcomePhone ?? "";
          useDisplay.value = model.data!.useDisplay ?? true;
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "WelcomeTag",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage2: "fetchWelcomeTag failed",
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────── VALIDATION ─────────────────
  bool _validate() {
    if (nameCtrl.text.trim().isEmpty) {
      _showError("Welcome name is required");
      return false;
    }

    if (emailCtrl.text.trim().isEmpty) {
      _showError("Welcome email is required");
      return false;
    }

    if (!GetUtils.isEmail(emailCtrl.text.trim())) {
      _showError("Please enter a valid email address");
      return false;
    }

    if (phoneCtrl.text.trim().isEmpty) {
      _showError("Welcome phone is required");
      return false;
    }

    if (phoneCtrl.text.trim().length < 8) {
      _showError("Please enter a valid phone number");
      return false;
    }

    return true;
  }

  // ───────────────── UPDATE ─────────────────
  Future<void> updateWelcomeTag() async {
    if (!_validate()) return;

    if (isLoading.value) return; // prevent double click
    isLoading.value = true;

    try {
      final response = await _repo.updateWelcomeTag(
        body: {
          "WelcomeName": nameCtrl.text.trim(),
          "WelcomeEmail": emailCtrl.text.trim(),
          "WelcomePhone": phoneCtrl.text.trim(),
          "UseDisplay": useDisplay.value,
        },
      );

      if (response != null && response["Status"] == true) {
        CommonMethod.getXSnackBar(
          "Success",
          "Welcome tag updated successfully",
          greenColor,
        );
      } else {
        _showError(response?["Message"] ?? "Failed to update welcome tag");
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "WelcomeTag",
        actionType: "Update",
        errorMessage1: e.toString(),
        errorMessage2: "updateWelcomeTag failed",
        errorMessage3: stack.toString(),
      );

      _showError("Something went wrong. Please try again.");
    } finally {
      isLoading.value = false;
    }
  }

  // ───────────────── HELPERS ─────────────────
  void _showError(String msg) {
    CommonMethod.getXSnackBar("Error", msg, redColor);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
