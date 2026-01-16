class DailyCompensationResponse {
  bool? status;
  DailyCompensationData? data;

  DailyCompensationResponse({this.status, this.data});

  factory DailyCompensationResponse.fromJson(Map<String, dynamic> json) =>
      DailyCompensationResponse(
        status: json['Status'],
        data: json['Data'] == null
            ? null
            : DailyCompensationData.fromJson(json['Data']),
      );
}

class DailyCompensationData {
  List<DailyCompensationItem>? items;
  bool? hasMore;

  DailyCompensationData({this.items, this.hasMore});

  factory DailyCompensationData.fromJson(Map<String, dynamic> json) =>
      DailyCompensationData(
        items: json['Items'] == null
            ? []
            : List<DailyCompensationItem>.from(
                json['Items'].map((x) => DailyCompensationItem.fromJson(x))),
        hasMore: json['HasMore'],
      );
}

class DailyCompensationItem {
  DateTime? orderDate;
  String? orderDateString;
  int? orderCount;
  int? customerCount;
  double? commissionAmount;
  double? avgCommissionAmount;

  DailyCompensationItem({
    this.orderDate,
    this.orderDateString,
    this.orderCount,
    this.customerCount,
    this.commissionAmount,
    this.avgCommissionAmount,
  });

  factory DailyCompensationItem.fromJson(Map<String, dynamic> json) =>
      DailyCompensationItem(
        orderDate: json['OrderDate'] == null
            ? null
            : DateTime.parse(json['OrderDate']),
        orderDateString: json['OrderDateString'],
        orderCount: json['OrderCount'],
        customerCount: json['CustomerCount'],
        commissionAmount: (json['CommissionAmount'] as num?)?.toDouble(),
        avgCommissionAmount: (json['AvgCommissionAmount'] as num?)?.toDouble(),
      );
}

class OrderCompensationResponse {
  bool? status;
  OrderCompensationData? data;

  OrderCompensationResponse({this.status, this.data});

  factory OrderCompensationResponse.fromJson(Map<String, dynamic> json) =>
      OrderCompensationResponse(
        status: json['Status'],
        data: json['Data'] == null
            ? null
            : OrderCompensationData.fromJson(json['Data']),
      );
}

class OrderCompensationData {
  List<OrderCompensationItem>? items;

  OrderCompensationData({this.items});

  factory OrderCompensationData.fromJson(Map<String, dynamic> json) =>
      OrderCompensationData(
        items: json['Items'] == null
            ? []
            : List<OrderCompensationItem>.from(
                json['Items'].map((x) => OrderCompensationItem.fromJson(x))),
      );
}

class OrderCompensationItem {
  int? orderId;
  String? orderOwner;
  DateTime? orderDate;
  double? orderAmount;
  double? commissionAmount;
  String? commissionLevel;
  bool? isCommissionPending;
  bool? isBlocked;

  OrderCompensationItem({
    this.orderId,
    this.orderOwner,
    this.orderDate,
    this.orderAmount,
    this.commissionAmount,
    this.commissionLevel,
    this.isCommissionPending,
    this.isBlocked,
  });

  factory OrderCompensationItem.fromJson(Map<String, dynamic> json) =>
      OrderCompensationItem(
        orderId: json['OrderId'],
        orderOwner: json['OrderOwner'],
        orderDate: json['OrderDate'] == null
            ? null
            : DateTime.parse(json['OrderDate']),
        orderAmount: (json['OrderAmount'] as num?)?.toDouble(),
        commissionAmount: (json['CommissionAmount'] as num?)?.toDouble(),
        commissionLevel: json['CommissionLevel'],
        isCommissionPending: json['IsCommissionPending'],
        isBlocked: json['IsBlocked'],
      );
}
