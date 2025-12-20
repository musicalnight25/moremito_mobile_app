import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateWelcomeTag() async {
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
        Get.snackbar("Success", "Welcome tag updated successfully");
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "WelcomeTag",
        actionType: "Update",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    super.onClose();
  }
}
