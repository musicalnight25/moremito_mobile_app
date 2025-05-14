import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/notification_detail_model.dart';
import '../model/notification_model.dart';
import '../service/network_repository.dart';

class NotificationController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();
  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  Rxn<NotificationDetailModel> notificationDetails =
      Rxn<NotificationDetailModel>();
  RxBool isLoading = false.obs;

  Future<void> getNotification() async {
    isLoading.value = true;
    try {
      var response = await _networkRepository.getNotification();
      if (response != null) {
        final model = notificationResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          notificationList.assignAll(model.data ?? []);
        }
      }
    } catch (e) {
      debugPrint("Error in getNotification: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getNotificationDetail(
      BuildContext context, String notificationId) async {
    isLoading.value = true;

    try {
      var response = await _networkRepository.getNotificationDetail(
          context, notificationId);
      if (response != null) {
        final model =
            notificationDetailResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          notificationDetails.value = model.data;
          isLoading.value = false;
        }
      }
    } catch (e) {
      debugPrint("Error in getNotificationDetail: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
