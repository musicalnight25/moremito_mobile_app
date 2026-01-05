// // To parse this JSON data, do
// //
// //     final flyerInteractionResponseModel = flyerInteractionResponseModelFromJson(jsonString);
//
// import 'dart:convert';
//
// FlyerInteractionResponseModel flyerInteractionResponseModelFromJson(
//         String str) =>
//     FlyerInteractionResponseModel.fromJson(json.decode(str));
//
// String flyerInteractionResponseModelToJson(
//         FlyerInteractionResponseModel data) =>
//     json.encode(data.toJson());
//
// class FlyerInteractionResponseModel {
//   bool? status;
//   dynamic message;
//   List<FlyerInteractionModel>? data;
//
//   FlyerInteractionResponseModel({
//     this.status,
//     this.message,
//     this.data,
//   });
//
//   factory FlyerInteractionResponseModel.fromJson(Map<String, dynamic> json) =>
//       FlyerInteractionResponseModel(
//         status: json["Status"],
//         message: json["Message"],
//         data: json["Data"] == null
//             ? []
//             : List<FlyerInteractionModel>.from(
//                 json["Data"]!.map((x) => FlyerInteractionModel.fromJson(x))),
//       );
//
//   Map<String, dynamic> toJson() => {
//         "Status": status,
//         "Message": message,
//         "Data": data == null
//             ? []
//             : List<dynamic>.from(data!.map((x) => x.toJson())),
//       };
// }
//
// class FlyerInteractionModel {
//   String? interactionType;
//   String? interactionValue;
//   String? customInteractionValue;
//   String? ipAddress;
//   DateTime? createdOn;
//   int? sharedLinkFlyerId;
//
//   FlyerInteractionModel({
//     this.interactionType,
//     this.interactionValue,
//     this.customInteractionValue,
//     this.ipAddress,
//     this.createdOn,
//     this.sharedLinkFlyerId,
//   });
//
//   factory FlyerInteractionModel.fromJson(Map<String, dynamic> json) =>
//       FlyerInteractionModel(
//         interactionType: json["InteractionType"],
//         interactionValue: json["InteractionValue"],
//         customInteractionValue: json["CustomInteractionValue"],
//         ipAddress: json["IpAddress"],
//         createdOn: json["CreatedOn"] == null
//             ? null
//             : DateTime.parse(json["CreatedOn"]),
//         sharedLinkFlyerId: json["SharedLinkFlyerId"],
//       );
//
//   Map<String, dynamic> toJson() => {
//         "InteractionType": interactionType,
//         "InteractionValue": interactionValue,
//         "CustomInteractionValue": customInteractionValue,
//         "IpAddress": ipAddress,
//         "CreatedOn": createdOn?.toIso8601String(),
//         "SharedLinkFlyerId": sharedLinkFlyerId,
//       };
// }
