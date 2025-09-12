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
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        id: json["Id"],
        name: json["Name"],
        userName: json["UserName"],
        email: json["Email"],
        phone: json["Phone"],
        currentRank: json["CurrentRank"],
        highestRank: json["HighestRank"],
        userRole: json["UserRole"],
        // unreadNotificationCount: 2,
        unreadNotificationCount: json["UnreadNotificationCount"] != null &&
                json["UnreadNotificationCount"] != ''
            ? int.parse(json["UnreadNotificationCount"].toString())
            : 0,
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
      };
}
