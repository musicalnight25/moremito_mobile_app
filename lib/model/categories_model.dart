import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CategoryResponseModel {
  final bool? status;
  final dynamic message;
  final List<CategoryModel>? data;

  CategoryResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return CategoryResponseModel(
      status: json['Status'],
      message: json['Message'],
      data: json['Data'] == null
          ? []
          : List<CategoryModel>.from(
              json['Data'].map((x) => CategoryModel.fromJson(x)),
            ),
    );
  }
}

class CategoryModel {
  String? categoryName;
  String? categoryId;
  String? subCategoryId;
  String? shortDesc;
  String? subCategoryName;
  String? description;
  bool? isPopular;

  /// UI icon
  IconData? icon;

  CategoryModel({
    this.categoryName,
    this.categoryId,
    this.subCategoryId,
    this.subCategoryName,
    this.shortDesc,
    this.description,
    this.isPopular,
    this.icon,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final categoryName = (json['CategoryName'] ?? '').toString().toLowerCase();
    final subCategoryName =
        (json['SubCategoryName'] ?? '').toString().toLowerCase();

    IconData icon = PhosphorIconsRegular.folder;

    // ---------------- SUB-CATEGORIES ----------------
    if (json['SubCategoryName'] != null) {
      if (subCategoryName.contains('heart')) {
        icon = PhosphorIconsRegular.heart;
      } else if (subCategoryName.contains('brain') ||
          subCategoryName.contains('neurological')) {
        icon = PhosphorIconsRegular.brain;
      } else if (subCategoryName.contains('eye')) {
        icon = PhosphorIconsRegular.eye;
      } else if (subCategoryName.contains('kidney') ||
          subCategoryName.contains('liver')) {
        icon = PhosphorIconsRegular.drop;
      } else if (subCategoryName.contains('diabetes') ||
          subCategoryName.contains('sugar')) {
        icon = PhosphorIconsRegular.pulse;
      } else if (subCategoryName.contains('weight')) {
        icon = PhosphorIconsRegular.scales;
      } else if (subCategoryName.contains('emotional')) {
        icon = PhosphorIconsRegular.smiley;
      } else if (subCategoryName.contains('parasite')) {
        icon = PhosphorIconsRegular.bug;
      } else if (subCategoryName.contains('circulation')) {
        icon = PhosphorIconsRegular.waveform;
      }
    }

    // ---------------- MAIN CATEGORIES ----------------
    else {
      if (categoryName.contains('people')) {
        icon = PhosphorIconsRegular.users;
      } else if (categoryName.contains('pet')) {
        icon = PhosphorIconsRegular.pawPrint;
      } else if (categoryName.contains('mitochondria')) {
        icon = PhosphorIconsRegular.atom;
      } else if (categoryName.contains('opportunity')) {
        icon = PhosphorIconsRegular.briefcase;
      } else if (categoryName.contains('document') ||
          categoryName.contains('flyer')) {
        icon = PhosphorIconsRegular.fileText;
      }
    }

    return CategoryModel(
      categoryName: json["CategoryName"],
      categoryId: json["CategoryId"]?.toString(),
      subCategoryId: json["SubCategoryId"]?.toString(),
      subCategoryName: json["SubCategoryName"],
      shortDesc: json["ShortDesc"],
      description: json["Description"],
      isPopular: json["IsPopular"],
      icon: icon,
    );
  }
}
