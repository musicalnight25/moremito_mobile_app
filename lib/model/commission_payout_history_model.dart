import 'dart:convert';

CommissionPayoutHistoryResponse commissionPayoutHistoryResponseFromJson(
        String str) =>
    CommissionPayoutHistoryResponse.fromJson(json.decode(str));

class CommissionPayoutHistoryResponse {
  bool? status;
  CommissionPayoutHistoryData? data;

  CommissionPayoutHistoryResponse({this.status, this.data});

  factory CommissionPayoutHistoryResponse.fromJson(Map<String, dynamic> json) {
    return CommissionPayoutHistoryResponse(
      status: json['Status'],
      data: json['Data'] == null
          ? null
          : CommissionPayoutHistoryData.fromJson(json['Data']),
    );
  }
}

class CommissionPayoutHistoryData {
  double? totalApprovedAmount;
  List<CommissionTransaction>? transactions;

  CommissionPayoutHistoryData({
    this.totalApprovedAmount,
    this.transactions,
  });

  factory CommissionPayoutHistoryData.fromJson(Map<String, dynamic> json) {
    return CommissionPayoutHistoryData(
      totalApprovedAmount: (json['TotalApprovedAmount'] as num?)?.toDouble(),
      transactions: (json['Transactions'] as List<dynamic>?)
          ?.map((e) => CommissionTransaction.fromJson(e))
          .toList(),
    );
  }
}

class CommissionTransaction {
  int? transactionId;
  double? amount;
  DateTime? date; // ✅ FIXED
  String? paymentMethod;
  String? paymentStatus;
  String? description;

  CommissionTransaction({
    this.transactionId,
    this.amount,
    this.date,
    this.paymentMethod,
    this.paymentStatus,
    this.description,
  });

  factory CommissionTransaction.fromJson(Map<String, dynamic> json) {
    return CommissionTransaction(
      transactionId: json['TransactionId'],
      amount: (json['Amount'] as num?)?.toDouble(),
      date: _parseDate(json['Date']),
      // ✅ SAFE PARSE
      paymentMethod: json['PaymentMethod'],
      paymentStatus: json['PaymentStatus'],
      description: json['Description'],
    );
  }

  /// Safely parse ISO date string
  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    try {
      return DateTime.parse(value.toString());
    } catch (_) {
      return null;
    }
  }
}
