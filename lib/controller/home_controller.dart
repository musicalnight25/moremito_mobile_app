import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:more_mitro_app/model/dashboard_model.dart';
import 'package:more_mitro_app/service/fcm_service.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import '../pages/main_dashboard_screen.dart';
import '../utils/preferences_util.dart';

class HomeController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  Rxn<DashboardModel> dashboardModel = Rxn<DashboardModel>();
  RxBool isLoading = false.obs;
  RxString loginUserRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      getDashboard();
    });
  }

  Future<void> getUserRoleFromToken() async {
    final String? token = await PreferencesUtil.getUserToken();

    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      loginUserRole.value = (decodedToken['UserRole'] ?? '');

      debugPrint("UserRole from token: ${loginUserRole.value}");
    }
  }

  Future<void> getDashboard() async {
    await getUserRoleFromToken();

    isLoading.value = true;
    try {
      var response = await _networkRepository.getDashboard(null);
      if (response != null) {
        final model = dashboardResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          dashboardModel.value = model.data;
          final count = dashboardModel.value?.unreadNotificationCount ?? 0;
          unreadNotificationCount.value = count;

          // Sync launcher icon badge with real count from server
          await FcmService.syncBadgeFromApiCount(count);
        }
      }
    } catch (e) {
      debugPrint("Error in getDashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
