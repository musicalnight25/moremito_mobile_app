import 'dart:convert';

SharedReportsUsersResponse sharedReportsUsersResponseFromJson(String str) =>
    SharedReportsUsersResponse.fromJson(json.decode(str));

String sharedReportsUsersResponseToJson(SharedReportsUsersResponse data) =>
    json.encode(data.toJson());

class SharedReportsUsersResponse {
  bool? status;
  String? message;
  List<SharedReportUser>? data;

  SharedReportsUsersResponse({
    this.status,
    this.message,
    this.data,
  });

  factory SharedReportsUsersResponse.fromJson(Map<String, dynamic> json) =>
      SharedReportsUsersResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<SharedReportUser>.from(
                json["Data"]!.map((x) => SharedReportUser.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class SharedReportUser {
  int? shareId;
  int? userId;
  String? userName;
  String? firstName;
  String? lastName;
  String? email;
  DateTime? sharedDate;
  String? note;
  bool? declined;
  String? declineComment;

  SharedReportUser({
    this.shareId,
    this.userId,
    this.userName,
    this.firstName,
    this.lastName,
    this.email,
    this.sharedDate,
    this.note,
    this.declined,
    this.declineComment,
  });

  factory SharedReportUser.fromJson(Map<String, dynamic> json) =>
      SharedReportUser(
        shareId: json["ShareId"],
        userId: json["UserId"],
        userName: json["UserName"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        sharedDate: json["SharedDate"] == null
            ? null
            : DateTime.parse(json["SharedDate"]),
        note: json["Note"],
        declined: json["Declined"],
        declineComment: json["DeclineComment"],
      );

  Map<String, dynamic> toJson() => {
        "ShareId": shareId,
        "UserId": userId,
        "UserName": userName,
        "FirstName": firstName,
        "LastName": lastName,
        "Email": email,
        "SharedDate": sharedDate?.toIso8601String(),
        "Note": note,
        "Declined": declined,
        "DeclineComment": declineComment,
      };
}
