// To parse this JSON data, do
//
//     final flyerTemplateDetailResponseModel = flyerTemplateDetailResponseModelFromJson(jsonString);

import 'dart:convert';

import 'package:more_mitro_app/model/preview_response_model.dart';

FlyerTemplateDetailResponseModel flyerTemplateDetailResponseModelFromJson(
        String str) =>
    FlyerTemplateDetailResponseModel.fromJson(json.decode(str));

String flyerTemplateDetailResponseModelToJson(
        FlyerTemplateDetailResponseModel data) =>
    json.encode(data.toJson());

class FlyerTemplateDetailResponseModel {
  bool? status;
  dynamic message;
  FlyerTemplateDetailModel? data;

  FlyerTemplateDetailResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory FlyerTemplateDetailResponseModel.fromJson(
          Map<String, dynamic> json) =>
      FlyerTemplateDetailResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : FlyerTemplateDetailModel.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class FlyerTemplateDetailModel {
  FlyerTemplateModel? template;
  UserFlyerInfoModel? userFlyer;

  FlyerTemplateDetailModel({
    this.template,
    this.userFlyer,
  });

  factory FlyerTemplateDetailModel.fromJson(Map<String, dynamic> json) =>
      FlyerTemplateDetailModel(
        template: json["Template"] == null
            ? null
            : FlyerTemplateModel.fromJson(json["Template"]),
        userFlyer: json["UserFlyer"] == null
            ? null
            : UserFlyerInfoModel.fromJson(json["UserFlyer"]),
      );

  Map<String, dynamic> toJson() => {
        "Template": template?.toJson(),
        "UserFlyer": userFlyer?.toJson(),
      };
}
