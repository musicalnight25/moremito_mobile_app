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
  RxBool isPaginationLoading = false.obs;
  RxBool hasMoreData = true.obs;
  RxBool isDetailLoading = false.obs;

  /// filter
  RxInt selectedFilter = 0.obs; // 0=all 1=system 2=marketing 3=announcement

  int pageNumber = 1;

  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    _setupScrollListener(null);
  }

  void _setupScrollListener(BuildContext? context) {
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 100 &&
          !isPaginationLoading.value &&
          hasMoreData.value) {
        loadMoreNotifications(context);
      }
    });
  }

  /// FIRST LOAD
  Future<void> initialLoad(BuildContext? context) async {
    isLoading.value = true;
    await refreshNotifications(context);
    isLoading.value = false;
  }

  /// CHANGE FILTER
  Future<void> changeFilter({BuildContext? context, required int index}) async {
    selectedFilter.value = index;
    await refreshNotifications(context);
  }

  /// REFRESH
  Future<void> refreshNotifications(BuildContext? context) async {
    pageNumber = 1;
    hasMoreData.value = true;

    final list = await _fetchNotifications(context);

    if (list != null) {
      notificationList.assignAll(list);
    }
  }

  /// PAGINATION
  Future<void> loadMoreNotifications(BuildContext? context) async {
    if (!hasMoreData.value) return;

    isPaginationLoading.value = true;
    pageNumber++;

    final moreList = await _fetchNotifications(context);

    if (moreList != null) {
      notificationList.addAll(moreList);
    }

    isPaginationLoading.value = false;
  }

  Future<List<NotificationModel>?> _fetchNotifications(
      BuildContext? context) async {
    try {
      final response = await _networkRepository
          .getNotification(context: context, queryParameters: {
        "pageNumber": pageNumber.toString(),
        "pageSize": 10,
        "filter": selectedFilter.value.toString(),
      });

      if (response != null) {
        final model = notificationResponseModelFromJson(json.encode(response));

        if (model.status == true && model.data != null) {
          hasMoreData.value = model.data!.hasMore ?? false;
          return model.data!.notifications ?? [];
        }
      }
    } catch (e, stack) {
      await ErrorLogger.logErrorToServer(
        pageType: "Notification",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    }

    return null;
  }

  Future<void> getNotificationDetail(String notificationId) async {
    try {
      isDetailLoading.value = true;

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
      await ErrorLogger.logErrorToServer(
        pageType: "NotificationDetail",
        actionType: "Detail",
        errorMessage1: e.toString(),
        errorMessage3: stack.toString(),
      );
    } finally {
      isDetailLoading.value = false;
    }
  }
}
