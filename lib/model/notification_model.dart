// To parse this JSON data, do
//
//     final notificationResponseModel = notificationResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  autoshipCardDecline,
  autoshipNoCard,
  autoshipComing,
  orderPlaced,
  orderInTransit,
  orderDelivered,
  badShippingAddress,
  callAnnouncement,
  otherAnnouncements,
  smsBroadcast,
  rankDemotion,
  orderComment,
  supportTicketComment,
  newSignUp,
  filesMarketing,
  flyerMarketing,
  smsLead,
  unknown,
}

NotificationType parseNotificationType(String? type) {
  switch (type) {
    case "AutoshipCardDecline":
      return NotificationType.autoshipCardDecline;
    case "AutoshipNoCard":
      return NotificationType.autoshipNoCard;
    case "AutoshipComing":
      return NotificationType.autoshipComing;

    case "OrderPlaced":
      return NotificationType.orderPlaced;
    case "OrderInTransit":
      return NotificationType.orderInTransit;
    case "OrderDelivered":
      return NotificationType.orderDelivered;
    case "BadShippingAddress":
      return NotificationType.badShippingAddress;

    case "CallAnnouncement":
      return NotificationType.callAnnouncement;
    case "OtherAnnouncements":
      return NotificationType.otherAnnouncements;
    case "SmsBroadcast":
      return NotificationType.smsBroadcast;

    case "RankDemotion":
      return NotificationType.rankDemotion;

    case "OrderComment":
      return NotificationType.orderComment;
    case "SupportTicketComment":
      return NotificationType.supportTicketComment;

    case "NewSignUp":
      return NotificationType.newSignUp;

    case "FilesMarketing":
      return NotificationType.filesMarketing;
    case "FlyerMarketing":
      return NotificationType.flyerMarketing;
    case "SmsLead":
      return NotificationType.smsLead;

    default:
      return NotificationType.unknown;
  }
}

NotificationResponseModel notificationResponseModelFromJson(String str) =>
    NotificationResponseModel.fromJson(json.decode(str));

String notificationResponseModelToJson(NotificationResponseModel data) =>
    json.encode(data.toJson());

class NotificationResponseModel {
  bool? status;
  dynamic message;
  NotificationData? data;

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
            ? null
            : NotificationData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class NotificationData {
  List<NotificationModel>? notifications;
  int? totalCount;
  bool? hasMore;

  NotificationData({
    this.notifications,
    this.totalCount,
    this.hasMore,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        notifications: json["Notifications"] == null
            ? []
            : List<NotificationModel>.from(json["Notifications"]!
                .map((x) => NotificationModel.fromJson(x))),
        totalCount: json["TotalCount"],
        hasMore: json["HasMore"],
      );

  Map<String, dynamic> toJson() => {
        "Notifications": notifications == null
            ? []
            : List<dynamic>.from(notifications!.map((x) => x.toJson())),
        "TotalCount": totalCount,
        "HasMore": hasMore,
      };
}

class NotificationModel {
  dynamic? id;
  String? title;
  String? body;
  DateTime? createdOn;
  String? notificationType;
  bool? isRead;
  NotificationType type;

  NotificationModel({
    this.id,
    this.title,
    this.body,
    this.createdOn,
    this.notificationType,
    this.isRead,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final parsedType = parseNotificationType(json["NotificationType"]);

    return NotificationModel(
      id: json["Id"],
      title: json["Title"]!,
      body: json["Body"],
      isRead: json["IsRead"],
      createdOn:
          json["CreatedOn"] == null ? null : DateTime.parse(json["CreatedOn"]),
      notificationType: json["NotificationType"]!,
      type: parsedType,
    );
  }

  IconData get icon => getNotificationIcon(type);

  Map<String, dynamic> toJson() => {
        "Id": id,
        "Title": title,
        "Body": body,
        "IsRead": isRead,
        "CreatedOn": createdOn?.toIso8601String(),
        "NotificationType": notificationType,
      };
}

IconData getNotificationIcon(NotificationType type) {
  switch (type) {
    // ───── AUTOSHIP / PAYMENT ─────
    case NotificationType.autoshipCardDecline:
      return CupertinoIcons.exclamationmark_triangle;
    // Payment failed (warning)

    case NotificationType.autoshipNoCard:
      return CupertinoIcons.creditcard;
    // No card on file

    case NotificationType.autoshipComing:
      return CupertinoIcons.clock;
    // Upcoming autoship

    // ───── ORDER FLOW ─────
    case NotificationType.orderPlaced:
      return CupertinoIcons.cube_box;
    // Order created

    case NotificationType.orderInTransit:
      return CupertinoIcons.car_detailed;
    // Shipping / transit (truck alternative)

    case NotificationType.orderDelivered:
      return CupertinoIcons.checkmark_seal;
    // Delivered successfully

    case NotificationType.badShippingAddress:
      return CupertinoIcons.location_slash;
    // Invalid address

    // ───── COMMENTS / SUPPORT ─────
    case NotificationType.orderComment:
      return CupertinoIcons.text_bubble;
    // Order discussion

    case NotificationType.supportTicketComment:
      return CupertinoIcons.chat_bubble_2;
    // Support reply

    // ───── RANK ─────
    case NotificationType.rankDemotion:
      return CupertinoIcons.arrow_down_circle;
    // Rank demotion

    // ───── ANNOUNCEMENTS ─────
    case NotificationType.callAnnouncement:
      return CupertinoIcons.phone;
    // Call related

    case NotificationType.otherAnnouncements:
      return CupertinoIcons.speaker_3;
    // Announcement / broadcast

    case NotificationType.smsBroadcast:
      return CupertinoIcons.chat_bubble_text;
    // Mass SMS

    // ───── USER ─────
    case NotificationType.newSignUp:
      return CupertinoIcons.person_add;
    // New member

    // ───── MARKETING ─────
    case NotificationType.filesMarketing:
      return CupertinoIcons.doc;
    // File marketing

    case NotificationType.flyerMarketing:
      return CupertinoIcons.doc_text;
    // Flyer / document

    case NotificationType.smsLead:
      return CupertinoIcons.envelope;
    // Incoming SMS lead

    // ───── FALLBACK ─────
    case NotificationType.unknown:
    default:
      return CupertinoIcons.bell;
  }
}
