// To parse this JSON data, do
//
//     final previewResponseModel = previewResponseModelFromJson(jsonString);

import 'dart:convert';

PreviewResponseModel previewResponseModelFromJson(String str) =>
    PreviewResponseModel.fromJson(json.decode(str));

String previewResponseModelToJson(PreviewResponseModel data) =>
    json.encode(data.toJson());

class PreviewResponseModel {
  bool? status;
  dynamic message;
  PreviewModel? data;

  PreviewResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory PreviewResponseModel.fromJson(Map<String, dynamic> json) =>
      PreviewResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null ? null : PreviewModel.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class PreviewModel {
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
  List<ProductModel>? products;
  List<dynamic>? testimonials;
  UserFlyerInfoModel? userFlyerInfo;

  PreviewModel({
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

  factory PreviewModel.fromJson(Map<String, dynamic> json) => PreviewModel(
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
            : List<ProductModel>.from(
                json["Products"]!.map((x) => ProductModel.fromJson(x))),
        testimonials: json["Testimonials"] == null
            ? []
            : List<dynamic>.from(json["Testimonials"]!.map((x) => x)),
        userFlyerInfo: json["userFlyerInfo"] == null
            ? null
            : UserFlyerInfoModel.fromJson(json["userFlyerInfo"]),
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
        "Products": products == null
            ? []
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "Testimonials": testimonials == null
            ? []
            : List<dynamic>.from(testimonials!.map((x) => x)),
        "userFlyerInfo": userFlyerInfo?.toJson(),
      };
}

class ProductModel {
  int? id;
  String? productName;
  String? productDescription;
  String? productLink;
  int? displayOrder;
  bool? isActive;

  ProductModel({
    this.id,
    this.productName,
    this.productDescription,
    this.productLink,
    this.displayOrder,
    this.isActive,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["Id"],
        productName: json["ProductName"],
        productDescription: json["ProductDescription"],
        productLink: json["ProductLink"],
        displayOrder: json["DisplayOrder"],
        isActive: json["IsActive"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "ProductName": productName,
        "ProductDescription": productDescription,
        "ProductLink": productLink,
        "DisplayOrder": displayOrder,
        "IsActive": isActive,
      };
}

class UserFlyerInfoModel {
  int? id;
  int? userId;
  String? name;
  String? email;
  String? phone;
  String? websiteLink;
  String? qrCodeUrl;
  String? qrCodeImagePath;
  dynamic productDescription;
  DateTime? createdOn;
  DateTime? modifiedOn;
  bool? isDeleted;
  int? templateId;
  String? flyerGuid;
  dynamic userName;

  UserFlyerInfoModel({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.websiteLink,
    this.qrCodeUrl,
    this.qrCodeImagePath,
    this.productDescription,
    this.createdOn,
    this.modifiedOn,
    this.isDeleted,
    this.templateId,
    this.flyerGuid,
    this.userName,
  });

  factory UserFlyerInfoModel.fromJson(Map<String, dynamic> json) =>
      UserFlyerInfoModel(
        id: json["Id"],
        userId: json["UserId"],
        name: json["Name"],
        email: json["Email"],
        phone: json["Phone"],
        websiteLink: json["WebsiteLink"],
        qrCodeUrl: json["QRCodeUrl"],
        qrCodeImagePath: json["QRCodeImagePath"],
        productDescription: json["ProductDescription"],
        createdOn: json["CreatedOn"] == null
            ? null
            : DateTime.parse(json["CreatedOn"]),
        modifiedOn: json["ModifiedOn"] == null
            ? null
            : DateTime.parse(json["ModifiedOn"]),
        isDeleted: json["IsDeleted"],
        templateId: json["TemplateId"],
        flyerGuid: json["FlyerGuid"],
        userName: json["UserName"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "UserId": userId,
        "Name": name,
        "Email": email,
        "Phone": phone,
        "WebsiteLink": websiteLink,
        "QRCodeUrl": qrCodeUrl,
        "QRCodeImagePath": qrCodeImagePath,
        "ProductDescription": productDescription,
        "CreatedOn": createdOn?.toIso8601String(),
        "ModifiedOn": modifiedOn?.toIso8601String(),
        "IsDeleted": isDeleted,
        "TemplateId": templateId,
        "FlyerGuid": flyerGuid,
        "UserName": userName,
      };
}
