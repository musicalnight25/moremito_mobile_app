// To parse this JSON data, do
//
//     final ticketModulesResponse = ticketModulesResponseFromJson(jsonString);

import 'dart:convert';

TicketModulesResponse ticketModulesResponseFromJson(String str) =>
    TicketModulesResponse.fromJson(json.decode(str));

String ticketModulesResponseToJson(TicketModulesResponse data) =>
    json.encode(data.toJson());

class TicketModulesResponse {
  bool? status;
  dynamic message;
  List<TicketModuleModel>? data;

  TicketModulesResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TicketModulesResponse.fromJson(Map<String, dynamic> json) =>
      TicketModulesResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<TicketModuleModel>.from(
                json["Data"]!.map((x) => TicketModuleModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TicketModuleModel {
  int? id;
  String? value;

  TicketModuleModel({
    this.id,
    this.value,
  });

  factory TicketModuleModel.fromJson(Map<String, dynamic> json) =>
      TicketModuleModel(
        id: json["ID"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Value": value,
      };
}
