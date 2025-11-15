import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/notification_detail_model.dart';
import '../model/notification_model.dart';
import '../service/error_logger.dart';
import '../service/network_repository.dart';

class NotificationController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  RxList<NotificationModel> notificationList = <NotificationModel>[].obs;
  Rxn<NotificationDetailModel> notificationDetails =
      Rxn<NotificationDetailModel>();
  RxBool isLoading = false.obs;

  ///-----------------------------------------------------------------------
  /// GET NOTIFICATION LIST
  ///-----------------------------------------------------------------------
  Future<void> getNotification() async {
    isLoading.value = true;

    try {
      final response = await _networkRepository.getNotification();

      if (response != null) {
        final model = notificationResponseModelFromJson(json.encode(response));

        if (model.status == true) {
          notificationList.assignAll(model.data ?? []);
        }
      }
    } catch (e, stack) {
      debugPrint("Error in getNotification: $e");

      await ErrorLogger.logErrorToServer(
        pageType: "Notification",
        actionType: "getNotification",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///-----------------------------------------------------------------------
  /// GET NOTIFICATION DETAIL
  ///-----------------------------------------------------------------------
  Future<void> getNotificationDetail(
      BuildContext context, String notificationId) async {
    isLoading.value = true;

    try {
      final response = await _networkRepository.getNotificationDetail(
        null,
        notificationId,
      );

      if (response != null) {
        final model = notificationDetailResponseModelFromJson(
          json.encode(response),
        );

        if (model.status == true) {
          notificationDetails.value = model.data;
        }
      }
    } catch (e, stack) {
      debugPrint("Error in getNotificationDetail: $e");

      await ErrorLogger.logErrorToServer(
        pageType: "NotificationDetail",
        actionType: "getNotificationDetail",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
