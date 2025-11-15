// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) =>
    json.encode(data.toJson());

class NotificationResponseModel {
  bool? status;
  dynamic message;
  List<NotificationModel>? data;

  NotificationResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<NotificationModel>.from(
                json["Data"]!.map((x) => NotificationModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class NotificationModel {
  dynamic? id;
  String? title;
  String? body;
  DateTime? createdOn;
  String? notificationType;
  bool? isRead;
  IconData? icon;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.createdOn,
    this.notificationType,
    this.icon,
    this.isRead,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json["Id"],
      icon: getNotificationIcon(json["NotificationType"]),
      title: json["Title"]!,
      body: json["Body"],
      isRead: json["IsRead"],
      createdOn:
          json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
      notificationType: json["NotificationType"]!,
    );
  }

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Title": title,
        "Body": body,
        "IsRead": isRead,
        "CreatedOn": createdOn?.toIso8601String(),
        "NotificationType": notificationType,
      };
}

IconData getNotificationIcon(String notificationType) {
  switch (notificationType) {
    case "AutoshipCardDecline":
      return CupertinoIcons.exclamationmark_circle;
    case "AutoshipComing":
      return CupertinoIcons.calendar;
    case "AutoshipNoCard":
      return CupertinoIcons.creditcard;
    case "RankDemotion":
      return CupertinoIcons.arrow_down_circle;
    default:
      return CupertinoIcons.bell;
  }
}
