import 'dart:convert';

WelcomeTagResponse welcomeTagResponseFromJson(String str) =>
    WelcomeTagResponse.fromJson(json.decode(str));

class WelcomeTagResponse {
  bool? status;
  String? message;
  WelcomeTagModel? data;

  WelcomeTagResponse({this.status, this.message, this.data});

  factory WelcomeTagResponse.fromJson(Map<String, dynamic> json) {
    return WelcomeTagResponse(
      status: json["Status"],
      message: json["Message"],
      data:
          json["Data"] == null ? null : WelcomeTagModel.fromJson(json["Data"]),
    );
  }
}

class WelcomeTagModel {
  String? welcomeName;
  String? welcomeEmail;
  String? welcomePhone;
  bool? useDisplay;

  WelcomeTagModel({
    this.welcomeName,
    this.welcomeEmail,
    this.welcomePhone,
    this.useDisplay,
  });

  factory WelcomeTagModel.fromJson(Map<String, dynamic> json) {
    return WelcomeTagModel(
      welcomeName: json["WelcomeName"],
      welcomeEmail: json["WelcomeEmail"],
      welcomePhone: json["WelcomePhone"],
      useDisplay: json["UseDisplay"],
    );
  }
}
