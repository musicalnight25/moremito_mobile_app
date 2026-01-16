// lib/model/shared_flyers_model.dart
import 'dart:convert';

SharedFlyersResponse sharedFlyersResponseFromJson(String str) =>
    SharedFlyersResponse.fromJson(json.decode(str));

class SharedFlyersResponse {
  bool? status;
  String? message;
  SharedFlyersData? data;

  SharedFlyersResponse({this.status, this.message, this.data});

  factory SharedFlyersResponse.fromJson(Map<String, dynamic> json) {
    return SharedFlyersResponse(
      status: json["Status"],
      message: json["Message"],
      data:
          json["Data"] == null ? null : SharedFlyersData.fromJson(json["Data"]),
    );
  }
}

class SharedFlyersData {
  List<SharedFlyerItem>? items;
  int? pageNumber;
  bool? hasMore;
  int? pageSize;
  int? totalRecords;
  int? totalPages;

  SharedFlyersData.fromJson(Map<String, dynamic> json) {
    items = json["Items"] == null
        ? []
        : List<SharedFlyerItem>.from(
            json["Items"].map((x) => SharedFlyerItem.fromJson(x)));

    pageNumber = json["PageNumber"];
    pageSize = json["PageSize"];
    totalRecords = json["TotalRecords"];
    totalPages = json["TotalPages"];

    // ✅ FIX HERE
    hasMore = json["HasMore"] ?? false;
  }
}

class SharedFlyerItem {
  int? fileShareId;
  String? title;
  String? subTitle;
  String? sharedTo;
  String? sharedBy;
  String? sharedFrom;
  String? sharedOn;
  int? totalInteractions;
  int? fileType;
  String? lastInteractionDate;

  SharedFlyerItem.fromJson(Map<String, dynamic> json) {
    fileShareId = json["FileShareId"];
    title = json["Title"];
    sharedBy = json["SharedBy"];
    subTitle = json["SubTitle"];
    sharedTo = json["SharedTo"];
    sharedFrom = json["SharedFrom"];
    fileType = json["FileType"];
    sharedOn = json["SharedOn"];
    totalInteractions = json["TotalInteractions"];
    lastInteractionDate = json["LastInteractionDate"];
  }
}
