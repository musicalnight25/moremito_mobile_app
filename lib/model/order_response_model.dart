// To parse this JSON data, do
//
//     final orderResponseModel = orderResponseModelFromJson(jsonString);

import 'dart:convert';

OrderResponseModel orderResponseModelFromJson(String str) =>
    OrderResponseModel.fromJson(json.decode(str));

String orderResponseModelToJson(OrderResponseModel data) =>
    json.encode(data.toJson());

class OrderResponseModel {
  bool? status;
  dynamic message;
  OrderData? data;

  OrderResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) =>
      OrderResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null ? null : OrderData.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class OrderData {
  List<Order>? orders;
  dynamic totalCount;
  bool? hasMore;

  OrderData({
    this.orders,
    this.totalCount,
    this.hasMore,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
        orders: json["Orders"] == null
            ? []
            : List<Order>.from(json["Orders"]!.map((x) => Order.fromJson(x))),
        totalCount: json["TotalCount"],
        hasMore: json["HasMore"],
      );

  Map<String, dynamic> toJson() => {
        "Orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
        "TotalCount": totalCount,
        "HasMore": hasMore,
      };
}

class Order {
  dynamic? orderId;
  DateTime? orderDate;
  dynamic shippingFee;
  dynamic orderTax;
  dynamic subTotal;
  dynamic orderTotal;
  String? shippingStatus;
  String? paymentStatus;
  bool? hasBadAddress;
  String? addressWarningText;
  String? trackingId;
  String? trackingUrl;
  String? shippingMethod;

  Order({
    this.orderId,
    this.orderDate,
    this.shippingFee,
    this.orderTax,
    this.subTotal,
    this.orderTotal,
    this.shippingStatus,
    this.paymentStatus,
    this.hasBadAddress,
    this.addressWarningText,
    this.trackingId,
    this.trackingUrl,
    this.shippingMethod,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["OrderId"],
        orderDate: json["OrderDate"] == null
            ? null
            : DateTime.parse(json["OrderDate"]),
        shippingFee: json["ShippingFee"]?.toDouble(),
        orderTax: json["OrderTax"]?.toDouble(),
        subTotal: json["SubTotal"],
        orderTotal: json["OrderTotal"]?.toDouble(),
        shippingStatus: json["ShippingStatus"],
        paymentStatus: json["PaymentStatus"],
        hasBadAddress: json["HasBadAddress"],
        addressWarningText: json["AddressWarningText"],
        trackingId: json["TrackingId"],
        trackingUrl: json["TrackingUrl"],
        shippingMethod: json["ShippingMethod"],
      );

  Map<String, dynamic> toJson() => {
        "OrderId": orderId,
        "OrderDate": orderDate?.toIso8601String(),
        "ShippingFee": shippingFee,
        "OrderTax": orderTax,
        "SubTotal": subTotal,
        "OrderTotal": orderTotal,
        "ShippingStatus": shippingStatus,
        "PaymentStatus": paymentStatus,
        "HasBadAddress": hasBadAddress,
        "AddressWarningText": addressWarningText,
      };
}
