// To parse this JSON data, do
//
//     final ticketDetailResponse = ticketDetailResponseFromJson(jsonString);

import 'dart:convert';

TicketDetailResponse ticketDetailResponseFromJson(String str) =>
    TicketDetailResponse.fromJson(json.decode(str));

String ticketDetailResponseToJson(TicketDetailResponse data) =>
    json.encode(data.toJson());

class TicketDetailResponse {
  bool? status;
  dynamic message;
  TicketDetailResponseData? data;

  TicketDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TicketDetailResponse.fromJson(Map<String, dynamic> json) =>
      TicketDetailResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : TicketDetailResponseData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class TicketDetailResponseData {
  List<TicketComment>? ticketComments;
  List<dynamic>? fileDetails;

  TicketDetailResponseData({
    this.ticketComments,
    this.fileDetails,
  });

  factory TicketDetailResponseData.fromJson(Map<String, dynamic> json) =>
      TicketDetailResponseData(
        ticketComments: json["TicketComments"] == null
            ? []
            : List<TicketComment>.from(
                json["TicketComments"]!.map((x) => TicketComment.fromJson(x))),
        fileDetails: json["FileDetails"] == null
            ? []
            : List<dynamic>.from(json["FileDetails"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "TicketComments": ticketComments == null
            ? []
            : List<dynamic>.from(ticketComments!.map((x) => x.toJson())),
        "FileDetails": fileDetails == null
            ? []
            : List<dynamic>.from(fileDetails!.map((x) => x)),
      };
}

class TicketComment {
  int? ticketCommentId;
  int? userId;
  int? ticketId;
  String? username;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? ticketTitle;
  String? priorityValue;
  String? statusValue;
  String? typeValue;
  String? ticketDescription;
  String? ticketComment;
  DateTime? createdDate;
  dynamic usernames;
  dynamic phoneNo;
  bool? isPrivateComment;

  TicketComment({
    this.ticketCommentId,
    this.userId,
    this.ticketId,
    this.username,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.ticketTitle,
    this.priorityValue,
    this.statusValue,
    this.typeValue,
    this.ticketDescription,
    this.ticketComment,
    this.createdDate,
    this.usernames,
    this.phoneNo,
    this.isPrivateComment,
  });

  factory TicketComment.fromJson(Map<String, dynamic> json) => TicketComment(
        ticketCommentId: json["TicketCommentId"],
        userId: json["UserId"],
        ticketId: json["TicketId"],
        username: json["Username"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phone: json["Phone"],
        ticketTitle: json["TicketTitle"],
        priorityValue: json["PriorityValue"],
        statusValue: json["StatusValue"],
        typeValue: json["TypeValue"],
        ticketDescription: json["TicketDescription"],
        ticketComment: json["TicketComment"],
        createdDate: json["CreatedDate"] == null
            ? null
            : DateTime.parse(json["CreatedDate"]),
        usernames: json["Usernames"],
        phoneNo: json["PhoneNo"],
        isPrivateComment: json["IsPrivateComment"],
      );

  Map<String, dynamic> toJson() => {
        "TicketCommentId": ticketCommentId,
        "UserId": userId,
        "TicketId": ticketId,
        "Username": username,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "Phone": phone,
        "TicketTitle": ticketTitle,
        "PriorityValue": priorityValue,
        "StatusValue": statusValue,
        "TypeValue": typeValue,
        "TicketDescription": ticketDescription,
        "TicketComment": ticketComment,
        "CreatedDate": createdDate?.toIso8601String(),
        "Usernames": usernames,
        "PhoneNo": phoneNo,
        "IsPrivateComment": isPrivateComment,
      };
}
