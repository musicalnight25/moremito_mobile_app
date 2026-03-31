import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/colors.dart';

import '../model/my_profile_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';
import '../utils/common_method.dart';

class MyProfileController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  Rxn<MyProfileModel> profile = Rxn<MyProfileModel>();
  RxBool isLoading = false.obs;

  // Text Controllers
  final firstNameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final whatsappCtrl = TextEditingController();
  final governmentIdCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      final response = await _repo.getMyProfile();

      if (response != null) {
        final model = myProfileResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          profile.value = model.data;

          firstNameCtrl.text = model.data!.firstName ?? "";
          lastNameCtrl.text = model.data!.lastName ?? "";
          emailCtrl.text = model.data!.email ?? "";
          phoneCtrl.text = model.data!.phone ?? "";
          whatsappCtrl.text = model.data!.whatsappPhone ?? "";
          governmentIdCtrl.text = model.data!.governmentId ?? "";
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "MyProfile",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final response = await _repo.updateMyProfile(
        body: {
          "FirstName": firstNameCtrl.text.trim(),
          "LastName": lastNameCtrl.text.trim(),
          "Email": emailCtrl.text.trim(),
          "Phone": phoneCtrl.text.trim(),
          "FormattedPhone": phoneCtrl.text.trim(),
          "IsPhoneNoFormatted": true,
          "SMSCode": profile.value?.smsCode,
          "WhatsappPhone": whatsappCtrl.text.trim(),
          "GovernmentId": profile.value?.hasGovernmentId == true
              ? governmentIdCtrl.text.trim()
              : null,
        },
      );

      if (response != null && response["Status"] == true) {
        CommonMethod.getXSnackBar("Success".tr, "Profile updated successfully".tr, greenColor);
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "MyProfile",
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
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    whatsappCtrl.dispose();
    governmentIdCtrl.dispose();
    super.onClose();
  }
}
