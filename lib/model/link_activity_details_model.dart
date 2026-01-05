// To parse this JSON data, do
//
//     final linkActivityDetailsResponseModel = linkActivityDetailsResponseModelFromJson(jsonString);

import 'dart:convert';

LinkActivityDetailsResponseModel linkActivityDetailsResponseModelFromJson(
        String str) =>
    LinkActivityDetailsResponseModel.fromJson(json.decode(str));

String linkActivityDetailsResponseModelToJson(
        LinkActivityDetailsResponseModel data) =>
    json.encode(data.toJson());

class LinkActivityDetailsResponseModel {
  bool? status;
  dynamic message;
  Data? data;

  LinkActivityDetailsResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LinkActivityDetailsResponseModel.fromJson(
          Map<String, dynamic> json) =>
      LinkActivityDetailsResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null ? null : Data.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class Data {
  List<LinkActivityDetailsModel>? items;
  String? sharedTo;

  Data({
    this.items,
    this.sharedTo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        items: json["Items"] == null
            ? []
            : List<LinkActivityDetailsModel>.from(json["Items"]!
                .map((x) => LinkActivityDetailsModel.fromJson(x))),
        sharedTo: json["SharedTo"],
      );

  Map<String, dynamic> toJson() => {
        "Items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "SharedTo": sharedTo,
      };
}

class LinkActivityDetailsModel {
  String? activityType;
  DateTime? activityDate;
  String? interactionValue;
  String? activityDescription;
  String? sharedTo;

  LinkActivityDetailsModel({
    this.activityType,
    this.activityDate,
    this.interactionValue,
    this.activityDescription,
    this.sharedTo,
  });

  factory LinkActivityDetailsModel.fromJson(Map<String, dynamic> json) =>
      LinkActivityDetailsModel(
        activityType: json["ActivityType"],
        activityDate: json["ActivityDate"] == null
            ? null
            : DateTime.parse(json["ActivityDate"]),
        interactionValue: json["InteractionValue"],
        activityDescription: json["ActivityDescription"],
        sharedTo: json["SharedTo"],
      );

  Map<String, dynamic> toJson() => {
        "ActivityType": activityType,
        "ActivityDate": activityDate?.toIso8601String(),
        "InteractionValue": interactionValue,
        "ActivityDescription": activityDescription,
        "SharedTo": sharedTo,
      };
}
