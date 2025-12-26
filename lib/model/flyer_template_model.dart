import 'dart:convert';

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

class FlyerTemplateModel {
  int? id;
  int? templateId;
  String? templateName;
  String? templateCode;
  String? title;
  String? subtitle;
  String? videoUrl;
  String? scientistTitle;
  String? scientistIntro;
  bool? isActive;
  DateTime? createdOn;
  DateTime? modifiedOn;
  List<dynamic>? sections;
  List<dynamic>? products;
  List<dynamic>? testimonials;
  dynamic userFlyerInfo;

  FlyerTemplateModel({
    this.id,
    this.templateId,
    this.templateName,
    this.templateCode,
    this.title,
    this.subtitle,
    this.videoUrl,
    this.scientistTitle,
    this.scientistIntro,
    this.isActive,
    this.createdOn,
    this.modifiedOn,
    this.sections,
    this.products,
    this.testimonials,
    this.userFlyerInfo,
  });

  factory FlyerTemplateModel.fromJson(Map<String, dynamic> json) =>
      FlyerTemplateModel(
        id: json["Id"],
        templateId: json["TemplateId"],
        templateName: json["TemplateName"],
        templateCode: json["TemplateCode"],
        title: json["Title"],
        subtitle: json["Subtitle"],
        videoUrl: json["VideoUrl"],
        scientistTitle: json["ScientistTitle"],
        scientistIntro: json["ScientistIntro"],
        isActive: json["IsActive"],
        createdOn: json["CreatedOn"] == null
            ? null
            : DateTime.parse(json["CreatedOn"]),
        modifiedOn: json["ModifiedOn"] == null
            ? null
            : DateTime.parse(json["ModifiedOn"]),
        sections: json["Sections"] == null
            ? []
            : List<dynamic>.from(json["Sections"]!.map((x) => x)),
        products: json["Products"] == null
            ? []
            : List<dynamic>.from(json["Products"]!.map((x) => x)),
        testimonials: json["Testimonials"] == null
            ? []
            : List<dynamic>.from(json["Testimonials"]!.map((x) => x)),
        userFlyerInfo: json["userFlyerInfo"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "TemplateId": templateId,
        "TemplateName": templateName,
        "TemplateCode": templateCode,
        "Title": title,
        "Subtitle": subtitle,
        "VideoUrl": videoUrl,
        "ScientistTitle": scientistTitle,
        "ScientistIntro": scientistIntro,
        "IsActive": isActive,
        "CreatedOn": createdOn?.toIso8601String(),
        "ModifiedOn": modifiedOn?.toIso8601String(),
        "Sections":
            sections == null ? [] : List<dynamic>.from(sections!.map((x) => x)),
        "Products":
            products == null ? [] : List<dynamic>.from(products!.map((x) => x)),
        "Testimonials": testimonials == null
            ? []
            : List<dynamic>.from(testimonials!.map((x) => x)),
        "userFlyerInfo": userFlyerInfo,
      };
}
