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

// ---------------- ACTIVITY ----------------
class ActivityStats {
  int? last72Hours;
  int? last7Days;
  int? last2Weeks;
  int? last3Weeks;
  int? last4Weeks;
  int? lifetime;

  ActivityStats.fromJson(Map<String, dynamic> json) {
    last72Hours = json["Last72Hours"];
    last7Days = json["Last7Days"];
    last2Weeks = json["Last2Weeks"] ?? json["Days8To14"];
    last3Weeks = json["Last3Weeks"] ?? json["Days15To21"];
    last4Weeks = json["Last4Weeks"] ?? json["Days22To28"];
    lifetime = json["Lifetime"];
  }
}

// ---------------- RECIPIENTS ----------------
class RecipientStats {
  int? last72Hours;
  int? last7Days;
  int? last2Weeks;
  int? last3Weeks;
  int? last4Weeks;
  int? lifetime;

  RecipientStats.fromJson(Map<String, dynamic> json) {
    last72Hours = json["Last72Hours"];
    last7Days = json["Last7Days"];
    last2Weeks = json["Last2Weeks"] ?? json["Days8To14"];
    last3Weeks = json["Last3Weeks"] ?? json["Days15To21"];
    last4Weeks = json["Last4Weeks"] ?? json["Days22To28"];
    lifetime = json["Lifetime"];
  }
}
