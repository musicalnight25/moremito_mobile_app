// To parse this JSON data, do
//
//     final categoryResponseModel = categoryResponseModelFromJson(jsonString);

import 'dart:convert';
import 'dart:ui';

import '../utils/app_asset.dart';
import '../utils/colors.dart';

CategoryResponseModel categoryResponseModelFromJson(String str) =>
    CategoryResponseModel.fromJson(json.decode(str));

String categoryResponseModelToJson(CategoryResponseModel data) =>
    json.encode(data.toJson());

class CategoryResponseModel {
  bool? status;
  dynamic message;
  List<CategoryModel>? data;

  CategoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      CategoryResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<CategoryModel>.from(
                json["Data"]!.map((x) => CategoryModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class CategoryModel {
  String? categoryName;
  String? categoryId;
  String? subCategoryId;
  String? shortDesc;
  String? subCategoryName;
  String? description;
  bool? isPopular;
  Color? color;
  String? image;
  CategoryModel({
    this.categoryName,
    this.categoryId,
    this.subCategoryId,
    this.subCategoryName,
    this.shortDesc,
    this.description,
    this.isPopular,
    this.color,
    this.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    var catName = json['CategoryName'];
    var catImage = catName == 'People Health Related'
        ? AppAsset.people
        : catName == 'Pet'
            ? AppAsset.pet
            : catName == 'Opportunity'
                ? AppAsset.opportunity
                : catName == 'Flyer & Documents'
                    ? AppAsset.documentOutline
                    : AppAsset.pet;

    Color catColor = catName == 'People Health Related'
        ? paleYellowColor
        : catName == 'Pet'
            ? mintGreenColor
            : catName == 'Opportunity'
                ? softRedColor
                : catName == 'Flyer & Documents'
                    ? lavenderColor
                    : mintGreenColor;
    return CategoryModel(
        categoryName: json["CategoryName"],
        categoryId: json["CategoryId"].toString(),
        subCategoryId: json["SubCategoryId"].toString(),
        shortDesc: json["ShortDesc"],
        subCategoryName: json["SubCategoryName"],
        description: json["Description"],
        isPopular: json["IsPopular"],
        image: catImage,
        color: catColor);
  }

  Map<String, dynamic> toJson() => {
        "SubCategoryName": subCategoryName,
        "CategoryName": categoryName,
        "CategoryId": categoryId,
        "SubCategoryId": subCategoryId,
        "ShortDesc": shortDesc,
        "Description": description,
        "IsPopular": isPopular,
      };
}
