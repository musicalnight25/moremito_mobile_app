import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/model/dashboard_model.dart';
import 'package:more_mitro_app/service/network_repository.dart';

import '../pages/main_dashboard_screen.dart';

class HomeController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();
  Rxn<DashboardModel> dashboardModel = Rxn<DashboardModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getDashboard();
    });
  }

  Future<void> getDashboard() async {
    isLoading.value = true;
    try {
      var response = await _networkRepository.getDashboard(null);
      if (response != null) {
        final model = dashboardResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          dashboardModel.value = model.data;
          unreadNotificationCount.value =
              dashboardModel.value?.unreadNotificationCount ?? 0;
          isLoading.value = false;
        }
      }
    } catch (e) {
      isLoading.value = false;
      debugPrint("Error in getDashboard: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
