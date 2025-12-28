import 'dart:convert';

import 'package:more_mitro_app/model/preview_response_model.dart';

FlyerTemplateResponse flyerTemplateResponseFromJson(String str) =>
    FlyerTemplateResponse.fromJson(json.decode(str));

class FlyerTemplateResponse {
  final bool status;
  final List<FlyerTemplateModel> data;

  FlyerTemplateResponse({
    required this.status,
    required this.data,
  });

  factory FlyerTemplateResponse.fromJson(Map<String, dynamic> json) {
    return FlyerTemplateResponse(
      status: json["Status"] ?? false,
      data: json["Data"] == null
          ? []
          : List<FlyerTemplateModel>.from(
              json["Data"].map((x) => FlyerTemplateModel.fromJson(x))),
    );
  }
}
