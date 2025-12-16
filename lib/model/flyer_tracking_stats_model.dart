// lib/model/flyer_tracking_stats_model.dart
import 'dart:convert';

FlyerTrackingStatsResponse flyerTrackingStatsFromJson(String str) =>
    FlyerTrackingStatsResponse.fromJson(json.decode(str));

class FlyerTrackingStatsResponse {
  bool? status;
  String? message;
  FlyerTrackingStats? data;

  FlyerTrackingStatsResponse({this.status, this.message, this.data});

  factory FlyerTrackingStatsResponse.fromJson(Map<String, dynamic> json) {
    return FlyerTrackingStatsResponse(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] == null
          ? null
          : FlyerTrackingStats.fromJson(json["Data"]),
    );
  }
}

class FlyerTrackingStats {
  ActivityStats? activity;
  RecipientStats? recipients;

  FlyerTrackingStats({this.activity, this.recipients});

  factory FlyerTrackingStats.fromJson(Map<String, dynamic> json) {
    return FlyerTrackingStats(
      activity: json["Activity"] == null
          ? null
          : ActivityStats.fromJson(json["Activity"]),
      recipients: json["Recipients"] == null
          ? null
          : RecipientStats.fromJson(json["Recipients"]),
    );
  }
}

class ActivityStats {
  int? last72Hours;
  int? last7Days;
  int? days8To14;
  int? days15To21;
  int? days22To28;
  int? lifetime;

  ActivityStats.fromJson(Map<String, dynamic> json) {
    last72Hours = json["Last72Hours"];
    last7Days = json["Last7Days"];
    days8To14 = json["Days8To14"];
    days15To21 = json["Days15To21"];
    days22To28 = json["Days22To28"];
    lifetime = json["Lifetime"];
  }
}

class RecipientStats {
  int? last72Hours;
  int? last7Days;
  int? days8To14;
  int? days15To21;
  int? days22To28;
  int? lifetime;

  RecipientStats.fromJson(Map<String, dynamic> json) {
    last72Hours = json["Last72Hours"];
    last7Days = json["Last7Days"];
    days8To14 = json["Days8To14"];
    days15To21 = json["Days15To21"];
    days22To28 = json["Days22To28"];
    lifetime = json["Lifetime"];
  }
}
