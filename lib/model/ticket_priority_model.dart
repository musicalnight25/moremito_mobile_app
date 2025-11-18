// To parse this JSON data, do
//
//     final ticketPriorityResponse = ticketPriorityResponseFromJson(jsonString);

import 'dart:convert';

TicketPriorityResponse ticketPriorityResponseFromJson(String str) =>
    TicketPriorityResponse.fromJson(json.decode(str));

String ticketPriorityResponseToJson(TicketPriorityResponse data) =>
    json.encode(data.toJson());

class TicketPriorityResponse {
  bool? status;
  dynamic message;
  List<TicketPriorityModel>? data;

  TicketPriorityResponse({
    this.status,
    this.message,
    this.data,
  });

  factory TicketPriorityResponse.fromJson(Map<String, dynamic> json) =>
      TicketPriorityResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<TicketPriorityModel>.from(
                json["Data"]!.map((x) => TicketPriorityModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class TicketPriorityModel {
  int? id;
  String? value;

  TicketPriorityModel({
    this.id,
    this.value,
  });

  factory TicketPriorityModel.fromJson(Map<String, dynamic> json) =>
      TicketPriorityModel(
        id: json["ID"],
        value: json["Value"],
      );

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Value": value,
      };
}
