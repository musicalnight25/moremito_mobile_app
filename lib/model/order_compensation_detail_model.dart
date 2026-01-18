class OrderCompensationDetailResponse {
  bool? status;
  String? message;
  OrderCompensationDetailData? data;

  OrderCompensationDetailResponse({
    this.status,
    this.message,
    this.data,
  });

  factory OrderCompensationDetailResponse.fromJson(Map<String, dynamic> json) =>
      OrderCompensationDetailResponse(
        status: json['Status'],
        message: json['Message'],
        data: json['Data'] == null
            ? null
            : OrderCompensationDetailData.fromJson(json['Data']),
      );
}

class OrderCompensationDetailData {
  List<OrderCompensationDetailItem>? items;
  MovedOrderDetail? movedOrderDetail;

  OrderCompensationDetailData({
    this.items,
    this.movedOrderDetail,
  });

  factory OrderCompensationDetailData.fromJson(Map<String, dynamic> json) =>
      OrderCompensationDetailData(
        items: json['Items'] == null
            ? []
            : List<OrderCompensationDetailItem>.from(json['Items']
                .map((x) => OrderCompensationDetailItem.fromJson(x))),
        movedOrderDetail: json['MovedOrderDetail'] == null
            ? null
            : MovedOrderDetail.fromJson(json['MovedOrderDetail']),
      );
}

class OrderCompensationDetailItem {
  int? orderId;
  String? orderOwner;
  DateTime? orderDate;
  double? orderAmount;
  double? commissionAmount;
  String? commissionLevel;
  bool? isCommissionPending;
  bool? isBlocked;
  String? advanceCommissionType;
  String? description;
  int? recordId;

  OrderCompensationDetailItem({
    this.orderId,
    this.orderOwner,
    this.orderDate,
    this.orderAmount,
    this.commissionAmount,
    this.commissionLevel,
    this.isCommissionPending,
    this.isBlocked,
    this.advanceCommissionType,
    this.description,
    this.recordId,
  });

  factory OrderCompensationDetailItem.fromJson(Map<String, dynamic> json) =>
      OrderCompensationDetailItem(
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
        advanceCommissionType: json['AdvanceCommissionType'],
        description: json['Description'],
        recordId: json['RecordId'],
      );
}

class MovedOrderDetail {
  DateTime? processingDate;
  DateTime? moveReturnDate;
  String? moveReturnDescription;

  MovedOrderDetail({
    this.processingDate,
    this.moveReturnDate,
    this.moveReturnDescription,
  });

  factory MovedOrderDetail.fromJson(Map<String, dynamic> json) =>
      MovedOrderDetail(
        processingDate: json['ProcessingDate'] == null
            ? null
            : DateTime.parse(json['ProcessingDate']),
        moveReturnDate: json['MoveReturnDate'] == null
            ? null
            : DateTime.parse(json['MoveReturnDate']),
        moveReturnDescription: json['MoveReturnDescription'],
      );
}
