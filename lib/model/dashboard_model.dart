// To parse this JSON data, do
//
//     final dashboardResponseModel = dashboardResponseModelFromJson(jsonString);

import 'dart:convert';

DashboardResponseModel dashboardResponseModelFromJson(String str) =>
    DashboardResponseModel.fromJson(json.decode(str));

String dashboardResponseModelToJson(DashboardResponseModel data) =>
    json.encode(data.toJson());

class DashboardResponseModel {
  bool? status;
  dynamic message;
  DashboardModel? data;

  DashboardResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) =>
      DashboardResponseModel(
        status: json["Status"],
        message: json["Message"],
        data:
            json["Data"] == null ? null : DashboardModel.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class DashboardModel {
  int? id;
  String? name;
  String? userName;
  String? email;
  String? phone;
  String? currentRank;
  String? highestRank;
  String? userRole;
  int? unreadNotificationCount;

  CallDetails? callDetails;
  List<AnnouncementDetails>? announcementDetails;

  DashboardModel({
    this.id,
    this.name,
    this.userName,
    this.email,
    this.phone,
    this.currentRank,
    this.highestRank,
    this.userRole,
    this.unreadNotificationCount,
    this.callDetails,
    this.announcementDetails,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) =>
      DashboardModel(
        id: json["Id"],
        name: json["Name"],
        userName: json["UserName"],
        email: json["Email"],
        phone: json["Phone"],
        currentRank: json["CurrentRank"],
        highestRank: json["HighestRank"],
        userRole: json["UserRole"],
        unreadNotificationCount:
        int.tryParse(json["UnreadNotificationCount"].toString()) ?? 0,

        callDetails: json["CallDetails"] == null
            ? null
            : CallDetails.fromJson(json["CallDetails"]),

        announcementDetails: json["AnnouncementDetails"] == null
            ? []
            : List<AnnouncementDetails>.from(
          json["AnnouncementDetails"].map(
                (x) => AnnouncementDetails.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Name": name,
    "UserName": userName,
    "Email": email,
    "Phone": phone,
    "CurrentRank": currentRank,
    "HighestRank": highestRank,
    "UserRole": userRole,
    "UnreadNotificationCount": unreadNotificationCount,
    "CallDetails": callDetails?.toJson(),
    "AnnouncementDetails":
    announcementDetails?.map((x) => x.toJson()).toList(),
  };
}

class CallDetails {
  String? emailTemplate;
  String? title;
  String? subject;
  String? phone;
  String? internetLink;
  String? previousCallLink;

  CallDetails({
    this.emailTemplate,
    this.title,
    this.subject,
    this.phone,
    this.internetLink,
    this.previousCallLink,
  });

  factory CallDetails.fromJson(Map<String, dynamic> json) => CallDetails(
    emailTemplate: json["EmailTemplate"],
    title: json["Title"],
    subject: json["Subject"],
    phone: json["Phone"],
    internetLink: json["InternetLink"],
    previousCallLink: json["PreviousCallLink"],
  );

  Map<String, dynamic> toJson() => {
    "EmailTemplate": emailTemplate,
    "Title": title,
    "Subject": subject,
    "Phone": phone,
    "InternetLink": internetLink,
    "PreviousCallLink": previousCallLink,
  };
}

class AnnouncementDetails {
  int? id;
  String? announcementName;

  AnnouncementDetails({this.id, this.announcementName});

  factory AnnouncementDetails.fromJson(Map<String, dynamic> json) =>
      AnnouncementDetails(
        id: json["Id"],
        announcementName: json["AnnouncementName"],
      );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "AnnouncementName": announcementName,
  };
}
