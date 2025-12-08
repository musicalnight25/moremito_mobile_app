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

  /// Pagination variables
  int pageNumber = 1;
  RxBool isPaginationLoading = false.obs;
  RxBool hasMoreData = true.obs;

  /// Scroll Controller
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener();
  }

  void _setupScrollListener() {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 50 &&
          !isPaginationLoading.value &&
          hasMoreData.value) {
        loadMoreNotifications();
      }
    });
  }

  /// --------------------------------------------------------
  /// REFRESH LIST
  /// --------------------------------------------------------
  Future<void> refreshNotifications() async {
    pageNumber = 1;
    hasMoreData.value = true;
    notificationList.clear();
    await getNotification(isFromPagination: false);
  }

  /// --------------------------------------------------------
  /// PAGINATION
  /// --------------------------------------------------------
  Future<void> loadMoreNotifications() async {
    if (!hasMoreData.value) return;

    isPaginationLoading.value = true;

    pageNumber++;
    await getNotification(isFromPagination: true);

    isPaginationLoading.value = false;
  }

  /// --------------------------------------------------------
  /// GET NOTIFICATION LIST
  /// --------------------------------------------------------
  Future<void> getNotification({bool isFromPagination = false}) async {
    if (!isFromPagination) {
      isLoading.value = true;
    }

    try {
      var queryParameters = {
        "pageNumber": pageNumber.toString(),
        "pageSize": 10,
      };

      final response =
          await _networkRepository.getNotification(queryParameters);

      if (response != null) {
        final model = notificationResponseModelFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          List<NotificationModel> list = model.data!.notifications ?? [];

          if (isFromPagination) {
            notificationList.addAll(list);
          } else {
            notificationList.assignAll(list);
          }

          /// backend sends flag hasMore
          hasMoreData.value = model.data!.hasMore ?? false;
        } else {
          hasMoreData.value = false;
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
      if (!isFromPagination) {
        isLoading.value = false;
      }
    }
  }

  /// --------------------------------------------------------
  /// GET NOTIFICATION DETAIL
  /// --------------------------------------------------------
  Future<void> getNotificationDetail(
      BuildContext context, String notificationId) async {
    isLoading.value = true;

    try {
      final response =
          await _networkRepository.getNotificationDetail(null, notificationId);

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
