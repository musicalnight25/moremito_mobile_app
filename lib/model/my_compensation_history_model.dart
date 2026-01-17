import 'dart:convert';

MyCompensationHistoryResponse myCompensationHistoryResponseFromJson(
        String str) =>
    MyCompensationHistoryResponse.fromJson(json.decode(str));

class MyCompensationHistoryResponse {
  bool? status;
  String? message;
  MyCompensationHistoryData? data;

  MyCompensationHistoryResponse({this.status, this.message, this.data});

  factory MyCompensationHistoryResponse.fromJson(Map<String, dynamic> json) =>
      MyCompensationHistoryResponse(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : MyCompensationHistoryData.fromJson(json["Data"]),
      );
}

class MyCompensationHistoryData {
  String? totalCompensationEarned;
  List<YearItem>? yearItems;

  MyCompensationHistoryData({
    this.totalCompensationEarned,
    this.yearItems,
  });

  factory MyCompensationHistoryData.fromJson(Map<String, dynamic> json) =>
      MyCompensationHistoryData(
        totalCompensationEarned: json["TotalCompensationEarned"],
        yearItems: json["YearItems"] == null
            ? []
            : List<YearItem>.from(
                json["YearItems"].map((x) => YearItem.fromJson(x))),
      );
}

class YearItem {
  String? year;
  String? moreMitoCash;
  String? moreMitoCommission;
  String? totalCompensationEarned;
  double? averageOrderAmount;
  int? customerCount;
  double? avgEarnedPerCustomer;

  YearItem({
    this.year,
    this.moreMitoCash,
    this.moreMitoCommission,
    this.totalCompensationEarned,
    this.averageOrderAmount,
    this.customerCount,
    this.avgEarnedPerCustomer,
  });

  factory YearItem.fromJson(Map<String, dynamic> json) => YearItem(
        year: json["Year"],
        moreMitoCash: json["MoreMitoCash"],
        moreMitoCommission: json["MoreMitoCommission"],
        totalCompensationEarned: json["TotalCompensationEarned"],
        averageOrderAmount: (json["AverageOrderAmount"] as num?)?.toDouble(),
        customerCount: json["CustomerCount"],
        avgEarnedPerCustomer:
            (json["AvgEarnedPerCustomer"] as num?)?.toDouble(),
      );
}

class YearDetailsResponse {
  bool? status;
  YearDetailsData? data;

  YearDetailsResponse({this.status, this.data});

  factory YearDetailsResponse.fromJson(Map<String, dynamic> json) =>
      YearDetailsResponse(
        status: json["Status"],
        data: json["Data"] == null
            ? null
            : YearDetailsData.fromJson(json["Data"]),
      );
}

class YearDetailsData {
  int? year;
  List<MonthItem>? monthItems;

  YearDetailsData({this.year, this.monthItems});

  factory YearDetailsData.fromJson(Map<String, dynamic> json) =>
      YearDetailsData(
        year: json["Year"],
        monthItems: json["MonthItems"] == null
            ? []
            : List<MonthItem>.from(
                json["MonthItems"].map((x) => MonthItem.fromJson(x))),
      );
}

class MonthItem {
  String? month;
  String? totalEarned;
  int? customerCount;
  int? orderCount;
  double? avgAmount;
  double? avgEarnedPerCustomer;

  MonthItem({
    this.month,
    this.totalEarned,
    this.customerCount,
    this.orderCount,
    this.avgAmount,
    this.avgEarnedPerCustomer,
  });

  factory MonthItem.fromJson(Map<String, dynamic> json) => MonthItem(
        month: json["Month"],
        totalEarned: json["TotalEarned"],
        customerCount: json["CustomerCount"],
        orderCount: json["OrderCount"],
        avgAmount: (json["AvgAmount"] as num?)?.toDouble(),
        avgEarnedPerCustomer:
            (json["AvgEarnedPerCustomer"] as num?)?.toDouble(),
      );
}

class MonthDetailsResponse {
  bool? status;
  MonthDetailsData? data;

  MonthDetailsResponse({this.status, this.data});

  factory MonthDetailsResponse.fromJson(Map<String, dynamic> json) =>
      MonthDetailsResponse(
        status: json["Status"],
        data: json["Data"] == null
            ? null
            : MonthDetailsData.fromJson(json["Data"]),
      );
}

class MonthDetailsData {
  int? year;
  int? month;
  String? monthName;
  List<CommissionTypeSummary>? commissionTypeSummary;
  List<CommissionDetail>? commissionDetails;

  MonthDetailsData({
    this.year,
    this.month,
    this.monthName,
    this.commissionTypeSummary,
    this.commissionDetails,
  });

  factory MonthDetailsData.fromJson(Map<String, dynamic> json) =>
      MonthDetailsData(
        year: json["Year"],
        month: json["Month"],
        monthName: json["MonthName"],
        commissionTypeSummary: json["CommissionTypeSummary"] == null
            ? []
            : List<CommissionTypeSummary>.from(json["CommissionTypeSummary"]
                .map((x) => CommissionTypeSummary.fromJson(x))),
        commissionDetails: json["CommissionDetails"] == null
            ? []
            : List<CommissionDetail>.from(json["CommissionDetails"]
                .map((x) => CommissionDetail.fromJson(x))),
      );
}

class CommissionDetail {
  String? orderDate; // Added this field
  String? amount;
  String? description;
  String? type;
  String? commissionLevel;

  CommissionDetail({
    this.orderDate,
    this.amount,
    this.description,
    this.type,
    this.commissionLevel,
  });

  factory CommissionDetail.fromJson(Map<String, dynamic> json) =>
      CommissionDetail(
        orderDate: json["OrderDate"],
        // Map the JSON key here
        amount: json["Amount"],
        description: json["Description"],
        type: json["Type"],
        commissionLevel: json["CommissionLevel"],
      );
}

class CommissionTypeSummary {
  String? commissionType; // <--- Added this field
  String? month; // Added 'Month' as seen in your JSON
  String? moreMitoCash;
  String? moreMitoCommission;
  String? totalEarned;
  double? runningTotal;
  int? customerCount;
  int? orderCount;
  double? avgAmount;
  double? avgEarnedPerCustomer;

  CommissionTypeSummary({
    this.commissionType,
    this.month,
    this.moreMitoCash,
    this.moreMitoCommission,
    this.totalEarned,
    this.runningTotal,
    this.customerCount,
    this.orderCount,
    this.avgAmount,
    this.avgEarnedPerCustomer,
  });

  factory CommissionTypeSummary.fromJson(Map<String, dynamic> json) {
    return CommissionTypeSummary(
      // Parsing 'CommissionType' if it exists, otherwise defaulting to 'Month' or null
      commissionType: json["CommissionType"] ?? json["CommissionName"],
      month: json["Month"],
      moreMitoCash: json["MoreMitoCash"],
      moreMitoCommission: json["MoreMitoCommission"],
      totalEarned: json["TotalEarned"],
      runningTotal: (json["RunningTotal"] as num?)?.toDouble(),
      customerCount: json["CustomerCount"],
      orderCount: json["OrderCount"],
      avgAmount: (json["AvgAmount"] as num?)?.toDouble(),
      avgEarnedPerCustomer: (json["AvgEarnedPerCustomer"] as num?)?.toDouble(),
    );
  }
}
