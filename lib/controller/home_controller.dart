import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/model/dashboard_model.dart';
import 'package:more_mitro_app/service/fcm_service.dart';
import 'package:more_mitro_app/service/network_repository.dart';

class HomeController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  Rxn<DashboardModel> dashboardModel = Rxn<DashboardModel>();
  RxBool isLoading = false.obs;
  RxString loginUserRole = ''.obs;
  RxInt unreadNotificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 500));
      getDashboard();
    });
  }

  Future<void> getDashboard() async {
    isLoading.value = true;
    int retryCount = 0;
    const maxRetries = 2;

    while (retryCount < maxRetries) {
      try {
        var response = await _networkRepository.getDashboard(null);
        if (response != null) {
          final model = dashboardResponseModelFromJson(json.encode(response));
          if (model.status == true && model.data != null) {
            dashboardModel.value = model.data;

            // Get user role from dashboard API response
            loginUserRole.value = (model.data?.role ?? '');
            debugPrint("✓ UserRole from dashboard: ${loginUserRole.value}");

            final count = dashboardModel.value?.unreadNotificationCount ?? 0;
            unreadNotificationCount.value = count;

            // Sync launcher icon badge with real count from server
            await FcmService.syncBadgeFromApiCount(count);
            break; // Success - exit retry loop
          } else {
            debugPrint("⚠ Dashboard response status false or data null");
            retryCount++;
          }
        } else {
          debugPrint("⚠ Dashboard response is null");
          retryCount++;
        }
      } catch (e) {
        debugPrint(
            "✗ Error in getDashboard (attempt ${retryCount + 1}/$maxRetries): $e");
        retryCount++;

        if (retryCount < maxRetries) {
          // Wait before retrying
          await Future.delayed(const Duration(seconds: 1));
        }
      }
    }

    isLoading.value = false;
  }

  /// Reset dashboard data (called on logout)
  void resetDashboard() {
    dashboardModel.value = null;
    loginUserRole.value = '';
    unreadNotificationCount.value = 0;
    debugPrint("✓ Dashboard reset on logout");
  }
}
