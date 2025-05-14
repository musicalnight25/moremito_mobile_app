// To parse this JSON data, do
//
//     final loginResponseModel = loginResponseModelFromJson(jsonString);

import 'dart:convert';

LoginResponseModel loginResponseModelFromJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

String loginResponseModelToJson(LoginResponseModel data) =>
    json.encode(data.toJson());

class LoginResponseModel {
  bool? status;
  String? message;
  LoginModel? data;

  LoginResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null ? null : LoginModel.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class LoginModel {
  String? token;
  bool? isSurveyCompleted;

  LoginModel({
    this.token,
    this.isSurveyCompleted,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        token: json["Token"],
        isSurveyCompleted: json["IsSurveyCompleted"],
      );

  Map<String, dynamic> toJson() => {
        "Token": token,
        "IsSurveyCompleted": isSurveyCompleted,
      };
}
