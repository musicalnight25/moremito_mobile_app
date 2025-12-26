class PushNotificationResponse {
  final bool? status;
  final PushNotificationData? data;

  PushNotificationResponse({this.status, this.data});

  factory PushNotificationResponse.fromJson(Map<String, dynamic> json) {
    return PushNotificationResponse(
      status: json['Status'],
      data: json['Data'] != null
          ? PushNotificationData.fromJson(json['Data'])
          : null,
    );
  }
}

class PushNotificationData {
  final bool isAllEnabled;
  final bool isSystemEnabled;
  final bool isMarketingEnabled;
  final bool isAnnouncementEnabled;
  final List<NotificationItem> notifications;

  PushNotificationData({
    required this.isAllEnabled,
    required this.isSystemEnabled,
    required this.isMarketingEnabled,
    required this.isAnnouncementEnabled,
    required this.notifications,
  });

  factory PushNotificationData.fromJson(Map<String, dynamic> json) {
    return PushNotificationData(
      isAllEnabled: json['IsAllEnabled'] ?? false,
      isSystemEnabled: json['IsSystemEnabled'] ?? false,
      isMarketingEnabled: json['IsMarketingEnabled'] ?? false,
      isAnnouncementEnabled: json['IsAnnouncementEnabled'] ?? false,
      notifications: (json['Notifications'] as List? ?? [])
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
    );
  }
}

class NotificationItem {
  final int id;
  final String description;
  final String category;
  bool isEnabled;

  NotificationItem({
    required this.id,
    required this.description,
    required this.category,
    required this.isEnabled,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['NotificationTypeId'],
      description: json['Description'] ?? '',
      category: json['Category'] ?? '',
      isEnabled: json['IsEnabled'] ?? false,
    );
  }
}
