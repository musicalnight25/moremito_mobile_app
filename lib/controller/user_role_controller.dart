import 'dart:convert';
import 'package:get/get.dart';

import '../model/user_role_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class UserRoleController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  Rxn<UserRoleData> roleData = Rxn<UserRoleData>();
  RxBool isLoading = false.obs;

  Rxn<AvailableRole> selectedRole = Rxn<AvailableRole>();

  @override
  void onInit() {
    super.onInit();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    try {
      isLoading.value = true;

      final response = await _repo.getUserRoleInfo();
      if (response != null) {
        final model = userRoleResponseFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          roleData.value = model.data;
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "UserRole",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changeRole() async {
    if (selectedRole.value == null || roleData.value?.currentRole == null) {
      Get.snackbar("Error", "Please select a role");
      return;
    }

    try {
      final response = await _repo.changeUserRole(
        body: {
          "TargetRole": selectedRole.value!.roleName,
          "CurrentRoleId": roleData.value!.currentRole!.roleId,
          "NewRoleId": selectedRole.value!.roleId,
        },
      );

      if (response != null &&
          response["Status"] == true &&
          response["Data"]?["Status"] == true) {
        Get.snackbar("Success", "Role changed successfully");
        await fetchRoles();
        selectedRole.value = null;
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "UserRole",
        actionType: "Change",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }
  }
}
