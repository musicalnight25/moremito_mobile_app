// lib/model/flyer_models.dart
import 'dart:convert';

// ------------------ TRACKING STATS MODEL ------------------
FlyerTrackingStatsResponse flyerTrackingStatsFromJson(String str) =>
    FlyerTrackingStatsResponse.fromJson(json.decode(str));

class FlyerTrackingStatsResponse {
  FlyerTrackingStatsResponse({this.status, this.message, this.data});

  bool? status;
  String? message;
  FlyerTrackingStats? data;

  factory FlyerTrackingStatsResponse.fromJson(Map<String, dynamic> json) =>
      FlyerTrackingStatsResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : FlyerTrackingStats.fromJson(json["data"]),
      );
}

class FlyerTrackingStats {
  FlyerTrackingStats({
    required this.last72HoursRecipients,
    required this.last72HoursActivity,
    required this.last7DaysRecipients,
    required this.last7DaysActivity,
    required this.days8to14Recipients,
    required this.days8to14Activity,
    required this.days15to21Recipients,
    required this.days15to21Activity,
    required this.days22to28Recipients,
    required this.days22to28Activity,
    required this.lifetimeRecipients,
    required this.lifetimeActivity,
  });

  int last72HoursRecipients;
  int last72HoursActivity;

  int last7DaysRecipients;
  int last7DaysActivity;

  int days8to14Recipients;
  int days8to14Activity;

  int days15to21Recipients;
  int days15to21Activity;

  int days22to28Recipients;
  int days22to28Activity;

  int lifetimeRecipients;
  int lifetimeActivity;

  factory FlyerTrackingStats.fromJson(Map<String, dynamic> json) {
    // Defensive parsing: if backend keys differ, adapt here.
    return FlyerTrackingStats(
      last72HoursRecipients:
          json["last72HoursRecipients"] ?? json["last72hoursRecipients"] ?? 0,
      last72HoursActivity:
          json["last72HoursActivity"] ?? json["last72hoursActivity"] ?? 0,
      last7DaysRecipients:
          json["last7DaysRecipients"] ?? json["last7daysRecipients"] ?? 0,
      last7DaysActivity:
          json["last7DaysActivity"] ?? json["last7daysActivity"] ?? 0,
      days8to14Recipients:
          json["days8to14Recipients"] ?? json["days8to14"]?["recipients"] ?? 0,
      days8to14Activity:
          json["days8to14Activity"] ?? json["days8to14"]?["activity"] ?? 0,
      days15to21Recipients: json["days15to21Recipients"] ??
          json["days15to21"]?["recipients"] ??
          0,
      days15to21Activity:
          json["days15to21Activity"] ?? json["days15to21"]?["activity"] ?? 0,
      days22to28Recipients: json["days22to28Recipients"] ??
          json["days22to28"]?["recipients"] ??
          0,
      days22to28Activity:
          json["days22to28Activity"] ?? json["days22to28"]?["activity"] ?? 0,
      lifetimeRecipients:
          json["lifetimeRecipients"] ?? json["lifetime"]?["recipients"] ?? 0,
      lifetimeActivity:
          json["lifetimeActivity"] ?? json["lifetime"]?["activity"] ?? 0,
    );
  }
}

// ------------------ SHARED FLYERS PAGINATED ------------------
SharedFlyersResponse sharedFlyersResponseFromJson(String str) =>
    SharedFlyersResponse.fromJson(json.decode(str));

class SharedFlyersResponse {
  SharedFlyersResponse({this.status, this.message, this.data});

  bool? status;
  String? message;
  SharedFlyersData? data;

  factory SharedFlyersResponse.fromJson(Map<String, dynamic> json) =>
      SharedFlyersResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : SharedFlyersData.fromJson(json["data"]),
      );
}

class SharedFlyersData {
  SharedFlyersData({this.items, this.hasMore});

  List<SharedFlyerItem>? items;
  bool? hasMore;

  factory SharedFlyersData.fromJson(Map<String, dynamic> json) =>
      SharedFlyersData(
        items: json["items"] == null
            ? []
            : List<SharedFlyerItem>.from(
                json["items"].map((x) => SharedFlyerItem.fromJson(x))),
        hasMore: json["hasMore"] ?? false,
      );
}

class SharedFlyerItem {
  SharedFlyerItem({
    this.sharedLinkId,
    this.title,
    this.sharedOn,
    this.recipients,
    this.activity,
  });

  int? sharedLinkId;
  String? title;
  String? sharedOn;
  int? recipients;
  int? activity;

  factory SharedFlyerItem.fromJson(Map<String, dynamic> json) =>
      SharedFlyerItem(
        sharedLinkId: json["sharedLinkId"],
        title: json["title"],
        sharedOn: json["sharedOn"],
        recipients: json["recipients"] ?? 0,
        activity: json["activity"] ?? 0,
      );
}

// ------------------ INTERACTIONS ------------------
List<FlyerInteraction> flyerInteractionsFromJson(String str) {
  final parsed = json.decode(str);
  if (parsed == null) return [];
  if (parsed is Map && parsed["data"] is List) {
    return List<FlyerInteraction>.from(
        parsed["data"].map((x) => FlyerInteraction.fromJson(x)));
  }
  return [];
}

class FlyerInteraction {
  FlyerInteraction({
    this.userName,
    this.action,
    this.timestamp,
  });

  String? userName;
  String? action;
  String? timestamp;

  factory FlyerInteraction.fromJson(Map<String, dynamic> json) =>
      FlyerInteraction(
        userName: json["userName"],
        action: json["action"],
        timestamp: json["timestamp"],
      );
}
