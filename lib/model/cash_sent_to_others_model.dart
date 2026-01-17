import 'dart:convert';

CashSentHistoryResponse cashSentHistoryResponseFromJson(String str) =>
    CashSentHistoryResponse.fromJson(json.decode(str));

class CashSentHistoryResponse {
  bool? status;
  CashSentHistoryData? data;

  CashSentHistoryResponse({this.status, this.data});

  factory CashSentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CashSentHistoryResponse(
      status: json['Status'],
      data: json['Data'] == null
          ? null
          : CashSentHistoryData.fromJson(json['Data']),
    );
  }
}

class CashSentHistoryData {
  double? totalSent;
  List<CashSentItem>? transfers;

  CashSentHistoryData({this.totalSent, this.transfers});

  factory CashSentHistoryData.fromJson(Map<String, dynamic> json) {
    return CashSentHistoryData(
      totalSent: (json['TotalSent'] as num?)?.toDouble(),
      transfers: (json['Transfers'] as List<dynamic>?)
          ?.map((e) => CashSentItem.fromJson(e))
          .toList(),
    );
  }
}

class CashSentItem {
  DateTime? dateTransferred;
  String? sentTo;
  String? sentToUsername;
  double? amount;
  String? message;

  CashSentItem({
    this.dateTransferred,
    this.sentTo,
    this.sentToUsername,
    this.amount,
    this.message,
  });

  factory CashSentItem.fromJson(Map<String, dynamic> json) {
    return CashSentItem(
      dateTransferred: _parseDate(json['DateTransferred']),
      sentTo: json['SentTo'],
      sentToUsername: json['SentToUsername'],
      amount: (json['Amount'] as num?)?.toDouble(),
      message: json['Message'],
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
