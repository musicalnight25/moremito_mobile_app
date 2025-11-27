// To parse this JSON data, do
//
//     final orderDetailResponseModel = orderDetailResponseModelFromJson(jsonString);

import 'dart:convert';

OrderDetailResponseModel orderDetailResponseModelFromJson(String str) =>
    OrderDetailResponseModel.fromJson(json.decode(str));

String orderDetailResponseModelToJson(OrderDetailResponseModel data) =>
    json.encode(data.toJson());

class OrderDetailResponseModel {
  bool? status;
  dynamic message;
  OrderDetailData? data;

  OrderDetailResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory OrderDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderDetailResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : OrderDetailData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class OrderDetailData {
  OrderInfo? orderInfo;
  BillingInfo? billingInfo;
  ShippingInfo? shippingInfo;
  List<OrderItem>? orderItems;

  OrderDetailData({
    this.orderInfo,
    this.billingInfo,
    this.shippingInfo,
    this.orderItems,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) =>
      OrderDetailData(
        orderInfo: json["OrderInfo"] == null
            ? null
            : OrderInfo.fromJson(json["OrderInfo"]),
        billingInfo: json["BillingInfo"] == null
            ? null
            : BillingInfo.fromJson(json["BillingInfo"]),
        shippingInfo: json["ShippingInfo"] == null
            ? null
            : ShippingInfo.fromJson(json["ShippingInfo"]),
        orderItems: json["OrderItems"] == null
            ? []
            : List<OrderItem>.from(
                json["OrderItems"]!.map((x) => OrderItem.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "OrderInfo": orderInfo?.toJson(),
        "BillingInfo": billingInfo?.toJson(),
        "ShippingInfo": shippingInfo?.toJson(),
        "OrderItems": orderItems == null
            ? []
            : List<dynamic>.from(orderItems!.map((x) => x.toJson())),
      };
}

class BillingInfo {
  String? billingFirstName;
  String? billingLastName;
  String? billingAddress1;
  String? billingAddress2;
  String? billingZip;
  String? billingCity;
  String? billingCountryName;
  String? billingStateName;

  BillingInfo({
    this.billingFirstName,
    this.billingLastName,
    this.billingAddress1,
    this.billingAddress2,
    this.billingZip,
    this.billingCity,
    this.billingCountryName,
    this.billingStateName,
  });

  factory BillingInfo.fromJson(Map<String, dynamic> json) => BillingInfo(
        billingFirstName: json["BillingFirstName"],
        billingLastName: json["BillingLastName"],
        billingAddress1: json["BillingAddress1"],
        billingAddress2: json["BillingAddress2"],
        billingZip: json["BillingZip"],
        billingCity: json["BillingCity"],
        billingCountryName: json["BillingCountryName"],
        billingStateName: json["BillingStateName"],
      );

  Map<String, dynamic> toJson() => {
        "BillingFirstName": billingFirstName,
        "BillingLastName": billingLastName,
        "BillingAddress1": billingAddress1,
        "BillingAddress2": billingAddress2,
        "BillingZip": billingZip,
        "BillingCity": billingCity,
        "BillingCountryName": billingCountryName,
        "BillingStateName": billingStateName,
      };
}

class OrderInfo {
  dynamic orderId;
  String? customOrderNumber;
  DateTime? orderDate;
  dynamic shippingFee;
  dynamic orderTax;
  dynamic subTotal;
  dynamic orderTotal;
  String? shippingStatus;
  String? paymentStatus;
  String? shippingTrackingId;
  String? cancelledNote;
  String? notes;
  String? trackingUrl;

  OrderInfo({
    this.orderId,
    this.customOrderNumber,
    this.orderDate,
    this.shippingFee,
    this.orderTax,
    this.subTotal,
    this.orderTotal,
    this.shippingStatus,
    this.paymentStatus,
    this.shippingTrackingId,
    this.cancelledNote,
    this.notes,
    this.trackingUrl,
  });

  factory OrderInfo.fromJson(Map<String, dynamic> json) => OrderInfo(
        orderId: json["OrderId"],
        customOrderNumber: json["CustomOrderNumber"],
        orderDate: json["OrderDate"] == null
            ? null
            : DateTime.parse(json["OrderDate"]),
        shippingFee: json["ShippingFee"]?.toDouble(),
        orderTax: json["OrderTax"]?.toDouble(),
        subTotal: json["SubTotal"],
        orderTotal: json["OrderTotal"]?.toDouble(),
        shippingStatus: json["ShippingStatus"],
        paymentStatus: json["PaymentStatus"],
        shippingTrackingId: json["ShippingTrackingId"],
        cancelledNote: json["CancelledNote"],
        notes: json["Notes"],
        trackingUrl: json["TrackingURL"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "CustomOrderNumber": customOrderNumber,
        "OrderDate": orderDate?.toIso8601String(),
        "ShippingFee": shippingFee,
        "OrderTax": orderTax,
        "SubTotal": subTotal,
        "OrderTotal": orderTotal,
        "ShippingStatus": shippingStatus,
        "PaymentStatus": paymentStatus,
        "ShippingTrackingId": shippingTrackingId,
        "CancelledNote": cancelledNote,
        "Notes": notes,
        "TrackingURL": trackingUrl,
      };
}

class OrderItem {
  dynamic orderItemId;
  dynamic productId;
  String? productName;
  dynamic quantity;
  dynamic unitPrice;
  dynamic total;

  OrderItem({
    this.orderItemId,
    this.productId,
    this.productName,
    this.quantity,
    this.unitPrice,
    this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        orderItemId: json["OrderItemId"],
        productId: json["ProductId"],
        productName: json["ProductName"],
        quantity: json["Quantity"],
        unitPrice: json["UnitPrice"],
        total: json["Total"],
      );

  Map<String, dynamic> toJson() => {
        "OrderItemId": orderItemId,
        "ProductId": productId,
        "ProductName": productName,
        "Quantity": quantity,
        "UnitPrice": unitPrice,
        "Total": total,
      };
}

class ShippingInfo {
  String? shippingFirstName;
  String? shippingLastName;
  String? shippingAddress1;
  String? shippingAddress2;
  String? shippingZip;
  String? shippingCity;
  String? shippingCountryName;
  String? shippingStateName;

  ShippingInfo({
    this.shippingFirstName,
    this.shippingLastName,
    this.shippingAddress1,
    this.shippingAddress2,
    this.shippingZip,
    this.shippingCity,
    this.shippingCountryName,
    this.shippingStateName,
  });

  factory ShippingInfo.fromJson(Map<String, dynamic> json) => ShippingInfo(
        shippingFirstName: json["ShippingFirstName"],
        shippingLastName: json["ShippingLastName"],
        shippingAddress1: json["ShippingAddress1"],
        shippingAddress2: json["ShippingAddress2"],
        shippingZip: json["ShippingZip"],
        shippingCity: json["ShippingCity"],
        shippingCountryName: json["ShippingCountryName"],
        shippingStateName: json["ShippingStateName"],
      );

  Map<String, dynamic> toJson() => {
        "ShippingFirstName": shippingFirstName,
        "ShippingLastName": shippingLastName,
        "ShippingAddress1": shippingAddress1,
        "ShippingAddress2": shippingAddress2,
        "ShippingZip": shippingZip,
        "ShippingCity": shippingCity,
        "ShippingCountryName": shippingCountryName,
        "ShippingStateName": shippingStateName,
      };
}
