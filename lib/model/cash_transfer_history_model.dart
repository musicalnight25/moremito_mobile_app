import 'dart:convert';

CashTransferHistoryResponse cashTransferHistoryResponseFromJson(String str) =>
    CashTransferHistoryResponse.fromJson(json.decode(str));

class CashTransferHistoryResponse {
  bool? status;
  CashTransferHistoryData? data;

  CashTransferHistoryResponse({this.status, this.data});

  factory CashTransferHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CashTransferHistoryResponse(
      status: json['Status'],
      data: json['Data'] == null
          ? null
          : CashTransferHistoryData.fromJson(json['Data']),
    );
  }
}

class CashTransferHistoryData {
  List<CashTransferItem>? recievedList;
  double? totalReceived;

  CashTransferHistoryData({this.recievedList, this.totalReceived});

  factory CashTransferHistoryData.fromJson(Map<String, dynamic> json) {
    return CashTransferHistoryData(
      recievedList: (json['RecievedList'] as List<dynamic>?)
          ?.map((e) => CashTransferItem.fromJson(e))
          .toList(),
      totalReceived: (json['TotalReceived'] as num?)?.toDouble(),
    );
  }
}

class CashTransferItem {
  String? username;
  String? uName;
  double? transferAmount;
  DateTime? transferDate; // ✅ FIXED
  String? message;

  CashTransferItem({
    this.username,
    this.uName,
    this.transferAmount,
    this.transferDate,
    this.message,
  });

  factory CashTransferItem.fromJson(Map<String, dynamic> json) {
    return CashTransferItem(
      username: json['Username'],
      uName: json['UName'],
      transferAmount: (json['Transferamount'] as num?)?.toDouble(),
      transferDate: _parseDate(json['Transferdate']),
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
