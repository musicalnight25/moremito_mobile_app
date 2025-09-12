// To parse this JSON data, do
//
//     final categoryFileResponseModel = categoryFileResponseModelFromJson(jsonString);

import 'dart:convert';

CategoryFileResponseModel categoryFileResponseModelFromJson(String str) =>
    CategoryFileResponseModel.fromJson(json.decode(str));

String categoryFileResponseModelToJson(CategoryFileResponseModel data) =>
    json.encode(data.toJson());

class CategoryFileResponseModel {
  bool? status;
  dynamic message;
  List<CategoryFileModel>? data;

  CategoryFileResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryFileResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoryFileResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<CategoryFileModel>.from(
                json["Data"]!.map((x) => CategoryFileModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryFileModel {
  String? id;
  String? filePath;
  String? fileName;
  String? fileType;
  double? sizeInMb;
  String? shareUrl;
  bool? isPopular;

  CategoryFileModel({
    this.id,
    this.filePath,
    this.fileName,
    this.fileType,
    this.sizeInMb,
    this.shareUrl,
    this.isPopular,
  });

  factory CategoryFileModel.fromJson(Map<String, dynamic> json) =>
      CategoryFileModel(
        id: json["Id"]?.toString(),
        filePath: json["FilePath"],
        fileName: json["FileName"],
        fileType: json["FileType"],
        sizeInMb: json["SizeInMB"]?.toDouble(),
        shareUrl: json["ShareUrl"],
        isPopular: json["IsPopular"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "FilePath": filePath,
        "FileName": fileName,
        "FileType": fileType,
        "SizeInMB": sizeInMb,
        "ShareUrl": shareUrl,
        "IsPopular": isPopular,
      };
}
