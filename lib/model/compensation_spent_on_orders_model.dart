import 'dart:convert';

CommissionSpentResponse commissionSpentResponseFromJson(String str) =>
    CommissionSpentResponse.fromJson(json.decode(str));

class CommissionSpentResponse {
  bool? status;
  CommissionSpentData? data;

  CommissionSpentResponse({this.status, this.data});

  factory CommissionSpentResponse.fromJson(Map<String, dynamic> json) {
    return CommissionSpentResponse(
      status: json['Status'],
      data: json['Data'] == null
          ? null
          : CommissionSpentData.fromJson(json['Data']),
    );
  }
}

class CommissionSpentData {
  double? totalAmount;
  bool? hasMore;
  List<CommissionSpentItem>? items;

  CommissionSpentData({this.totalAmount, this.hasMore, this.items});

  factory CommissionSpentData.fromJson(Map<String, dynamic> json) {
    return CommissionSpentData(
      totalAmount: (json['TotalAmount'] as num?)?.toDouble(),
      hasMore: json['HasMore'],
      items: (json['Items'] as List<dynamic>?)
          ?.map((e) => CommissionSpentItem.fromJson(e))
          .toList(),
    );
  }

  /// ✅ ADD THIS
  CommissionSpentData copyWith({
    double? totalAmount,
    bool? hasMore,
    List<CommissionSpentItem>? items,
  }) {
    return CommissionSpentData(
      totalAmount: totalAmount ?? this.totalAmount,
      hasMore: hasMore ?? this.hasMore,
      items: items ?? this.items,
    );
  }
}

class CommissionSpentItem {
  int? orderId;
  double? amount;
  bool? isRefunded;
  String? commissionType;
  DateTime? date;
  String? description;

  CommissionSpentItem({
    this.orderId,
    this.amount,
    this.isRefunded,
    this.commissionType,
    this.date,
    this.description,
  });

  factory CommissionSpentItem.fromJson(Map<String, dynamic> json) {
    return CommissionSpentItem(
      orderId: json['OrderId'],
      amount: (json['Amount'] as num?)?.toDouble(),
      isRefunded: json['IsRefunded'],
      commissionType: json['CommissionType'],
      date: _parseDate(json['Date']),
      description: json['Description'],
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
