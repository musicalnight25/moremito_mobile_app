// To parse this JSON data, do
//
//     final ticketListResponse = ticketListResponseFromJson(jsonString);

import 'dart:convert';

TicketListResponse ticketListResponseFromJson(String str) =>
    TicketListResponse.fromJson(json.decode(str));

String ticketListResponseToJson(TicketListResponse data) =>
    json.encode(data.toJson());

class TicketListResponse {
  bool? status;
  dynamic message;
  List<TicketModel>? data;

  TicketListResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TicketListResponse.fromJson(Map<String, dynamic> json) =>
      TicketListResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<TicketModel>.from(
                json["Data"]!.map((x) => TicketModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TicketModel {
  int? ticketId;
  int? userId;
  String? username;
  String? firstName;
  String? lastname;
  String? email;
  String? phone;
  String? ticketTitle;
  String? priorityValue;
  String? statusValue;
  String? typeValue;
  DateTime? createdDate;
  int? noOfOpenDays;
  int? noOfClosedDays;
  int? unreadAdmin;
  int? unreadUser;
  bool? isAdminCreated;

  TicketModel({
    this.ticketId,
    this.userId,
    this.username,
    this.firstName,
    this.lastname,
    this.email,
    this.phone,
    this.ticketTitle,
    this.priorityValue,
    this.statusValue,
    this.typeValue,
    this.createdDate,
    this.noOfOpenDays,
    this.noOfClosedDays,
    this.unreadAdmin,
    this.unreadUser,
    this.isAdminCreated,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        ticketId: json["TicketId"],
        userId: json["UserId"],
        username: json["Username"],
        firstName: json["FirstName"],
        lastname: json["Lastname"],
        email: json["Email"],
        phone: json["Phone"],
        ticketTitle: json["TicketTitle"],
        priorityValue: json["PriorityValue"],
        statusValue: json["StatusValue"],
        typeValue: json["TypeValue"],
        createdDate: json["CreatedDate"] == null
            ? null
            : DateTime.parse(json["CreatedDate"]),
        noOfOpenDays: json["NoOfOpenDays"],
        noOfClosedDays: json["NoOfClosedDays"],
        unreadAdmin: json["Unread_Admin"],
        unreadUser: json["Unread_User"],
        isAdminCreated: json["IsAdminCreated"],
      );

  Map<String, dynamic> toJson() => {
        "TicketId": ticketId,
        "UserId": userId,
        "Username": username,
        "FirstName": firstName,
        "Lastname": lastname,
        "Email": email,
        "Phone": phone,
        "TicketTitle": ticketTitle,
        "PriorityValue": priorityValue,
        "StatusValue": statusValue,
        "TypeValue": typeValue,
        "CreatedDate": createdDate?.toIso8601String(),
        "NoOfOpenDays": noOfOpenDays,
        "NoOfClosedDays": noOfClosedDays,
        "Unread_Admin": unreadAdmin,
        "Unread_User": unreadUser,
        "IsAdminCreated": isAdminCreated,
      };
}
