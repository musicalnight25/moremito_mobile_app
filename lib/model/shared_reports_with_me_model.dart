import 'dart:convert';

SharedReportsWithMeResponse sharedReportsWithMeResponseFromJson(String str) =>
    SharedReportsWithMeResponse.fromJson(json.decode(str));

class SharedReportsWithMeResponse {
  bool? status;
  String? message;
  SharedReportsWithMeData? data;

  SharedReportsWithMeResponse({this.status, this.message, this.data});

  factory SharedReportsWithMeResponse.fromJson(Map<String, dynamic> json) =>
      SharedReportsWithMeResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : SharedReportsWithMeData.fromJson(json["Data"]),
      );
}

class SharedReportsWithMeData {
  List<SharedReportWithMeItem>? items;
  int? pageNumber;
  int? pageSize;
  int? totalRecords;
  int? totalPages;
  bool? hasMore;

  SharedReportsWithMeData({
    this.items,
    this.pageNumber,
    this.pageSize,
    this.totalRecords,
    this.totalPages,
    this.hasMore,
  });

  factory SharedReportsWithMeData.fromJson(Map<String, dynamic> json) =>
      SharedReportsWithMeData(
        items: json["Items"] == null
            ? []
            : List<SharedReportWithMeItem>.from(
                json["Items"]!.map((x) => SharedReportWithMeItem.fromJson(x))),
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        totalRecords: json["TotalRecords"],
        totalPages: json["TotalPages"],
        hasMore: json["HasMore"],
      );
}

class SharedReportWithMeItem {
  int? id;
  int? sharedByUserId;
  String? sharedByUserName;
  String? sharedByName;
  DateTime? createdUtc;
  String? note;

  SharedReportWithMeItem({
    this.id,
    this.sharedByUserId,
    this.sharedByUserName,
    this.sharedByName,
    this.createdUtc,
    this.note,
  });

  factory SharedReportWithMeItem.fromJson(Map<String, dynamic> json) =>
      SharedReportWithMeItem(
        id: json["Id"],
        sharedByUserId: json["SharedByUserId"],
        sharedByUserName: json["SharedByUserName"],
        sharedByName: json["SharedByName"],
        createdUtc: json["CreatedUtc"] == null
            ? null
            : DateTime.parse(json["CreatedUtc"]),
        note: json["Note"],
      );
}
