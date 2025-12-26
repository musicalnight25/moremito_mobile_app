import 'dart:convert';
import 'package:get/get.dart';

import '../model/push_notification_model.dart';
import '../service/network_repository.dart';
import '../service/error_logger.dart';

class NotificationSettingsController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();

  RxBool isLoading = false.obs;

  RxBool isAllEnabled = false.obs;
  RxBool isSystemEnabled = false.obs;
  RxBool isMarketingEnabled = false.obs;
  RxBool isAnnouncementEnabled = false.obs;

  RxList<NotificationItem> systemList = <NotificationItem>[].obs;
  RxList<NotificationItem> marketingList = <NotificationItem>[].obs;
  RxList<NotificationItem> announcementList = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettings();
  }

  /// ───── FETCH ─────
  Future<void> fetchSettings() async {
    try {
      isLoading.value = true;

      final res = await _repo.getPushNotificationSettings();
      if (res != null) {
        final model = PushNotificationResponse.fromJson(
          json.decode(json.encode(res)),
        );

        final data = model.data;
        if (data != null) {
          isAllEnabled.value = data.isAllEnabled;
          isSystemEnabled.value = data.isSystemEnabled;
          isMarketingEnabled.value = data.isMarketingEnabled;
          isAnnouncementEnabled.value = data.isAnnouncementEnabled;

          systemList.assignAll(
              data.notifications.where((e) => e.category == "System"));
          marketingList.assignAll(
              data.notifications.where((e) => e.category == "Marketing"));
          announcementList.assignAll(
              data.notifications.where((e) => e.category == "Announcement"));
        }
      }
    } catch (e, s) {
      await ErrorLogger.logErrorToServer(
        pageType: "NotificationSettings",
        actionType: "Fetch",
        errorMessage1: e.toString(),
        errorMessage3: s.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// ───── SINGLE TOGGLE ─────
  Future<void> toggleSingle(NotificationItem item, bool value) async {
    item.isEnabled = value;
    systemList.refresh();
    marketingList.refresh();
    announcementList.refresh();

    await _repo.savePushNotificationSetting(body: {
      "NotificationTypeId": item.id,
      "IsEnabled": value,
    });
  }

  /// ───── CATEGORY TOGGLE ─────
  Future<void> toggleCategory(
    RxBool categoryToggle,
    List<NotificationItem> list,
    bool value,
  ) async {
    categoryToggle.value = value;

    final payload = list.map((e) {
      e.isEnabled = value;
      return {
        "NotificationTypeId": e.id,
        "IsEnabled": value,
      };
    }).toList();

    systemList.refresh();
    marketingList.refresh();
    announcementList.refresh();

    await _repo.savePushNotificationSettingsBulk(body: payload);
  }

  /// ───── ALL TOGGLE ─────
  Future<void> toggleAll(bool value) async {
    isAllEnabled.value = value;
    isSystemEnabled.value = value;
    isMarketingEnabled.value = value;
    isAnnouncementEnabled.value = value;

    final all = [
      ...systemList,
      ...marketingList,
      ...announcementList,
    ];

    final payload = all.map((e) {
      e.isEnabled = value;
      return {
        "NotificationTypeId": e.id,
        "IsEnabled": value,
      };
    }).toList();

    systemList.refresh();
    marketingList.refresh();
    announcementList.refresh();

    await _repo.savePushNotificationSettingsBulk(body: payload);
  }
}
