import 'dart:convert';

MyProfileResponse myProfileResponseFromJson(String str) =>
    MyProfileResponse.fromJson(json.decode(str));

class MyProfileResponse {
  bool? status;
  String? message;
  MyProfileModel? data;

  MyProfileResponse({this.status, this.message, this.data});

  factory MyProfileResponse.fromJson(Map<String, dynamic> json) {
    return MyProfileResponse(
      status: json["Status"],
      message: json["Message"],
      data: json["Data"] == null ? null : MyProfileModel.fromJson(json["Data"]),
    );
  }
}

class MyProfileModel {
  String? userName;
  String? smsCode;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? whatsappPhone;
  String? membershipType;
  String? joinDate;
  bool? hasGovernmentId;
  String? governmentId;

  MyProfileModel({
    this.userName,
    this.smsCode,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.whatsappPhone,
    this.membershipType,
    this.joinDate,
    this.hasGovernmentId,
    this.governmentId,
  });

  factory MyProfileModel.fromJson(Map<String, dynamic> json) {
    return MyProfileModel(
      userName: json["UserName"],
      smsCode: json["SMSCode"],
      firstName: json["FirstName"],
      lastName: json["LastName"],
      email: json["Email"],
      phone: json["Phone"],
      whatsappPhone: json["WhatsappPhone"],
      membershipType: json["MembershipType"],
      joinDate: json["JoinDate"],
      hasGovernmentId: json["HasGovernmentId"],
      governmentId: json["GovernmentId"],
    );
  }
}
