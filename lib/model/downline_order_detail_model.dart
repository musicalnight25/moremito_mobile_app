import 'dart:convert';

DownlineOrderDetailResponse downlineOrderDetailResponseFromJson(String str) =>
    DownlineOrderDetailResponse.fromJson(json.decode(str));

class DownlineOrderDetailResponse {
  bool status;
  DownlineOrderDetailData data;

  DownlineOrderDetailResponse({
    required this.status,
    required this.data,
  });

  factory DownlineOrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      DownlineOrderDetailResponse(
        status: json["Status"],
        data: DownlineOrderDetailData.fromJson(json["Data"]),
      );
}

class DownlineOrderDetailData {
  String orderStatus;
  String paymentMethodStatus;
  double orderTotal;
  String createdOn;
  MyOrders myOrders;
  List<OrderItem> items;

  DownlineOrderDetailData({
    required this.orderStatus,
    required this.paymentMethodStatus,
    required this.orderTotal,
    required this.createdOn,
    required this.myOrders,
    required this.items,
  });

  factory DownlineOrderDetailData.fromJson(Map<String, dynamic> json) =>
      DownlineOrderDetailData(
        orderStatus: json["OrderStatus"],
        paymentMethodStatus: json["PaymentMethodStatus"],
        orderTotal: json["OrderTotal"].toDouble(),
        createdOn: json["myOrders"]["CreatedOn"],
        myOrders: MyOrders.fromJson(json["myOrders"]),
        items: List<OrderItem>.from(
            json["Items"].map((x) => OrderItem.fromJson(x))),
      );
}

class MyOrders {
  String orderId;
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String address1;
  String zipPostalCode;
  String countryName;
  String stateName;
  double subTotal;
  double shippingTotal;
  double orderTax;

  MyOrders({
    required this.orderId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNumber,
    required this.address1,
    required this.zipPostalCode,
    required this.countryName,
    required this.stateName,
    required this.subTotal,
    required this.shippingTotal,
    required this.orderTax,
  });

  factory MyOrders.fromJson(Map<String, dynamic> json) => MyOrders(
        orderId: json["OrderId"],
        firstName: json["FirstName"] ?? "",
        lastName: json["LastName"] ?? "",
        email: json["Email"] ?? "",
        phoneNumber: json["PhoneNumber"] ?? "",
        address1: json["Address1"] ?? "",
        zipPostalCode: json["ZipPostalCode"] ?? "",
        countryName: json["CountryName"] ?? "",
        stateName: json["StateName"] ?? "",
        subTotal: json["SubTotal"].toDouble(),
        shippingTotal: json["ShippingTotal"].toDouble(),
        orderTax: json["OrderTax"].toDouble(),
      );
}

class OrderItem {
  String productName;
  int quantity;
  double unitPrice;
  double total;

  OrderItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json["ProductName"],
        quantity: json["Quantity"],
        unitPrice: json["UnitPrice"].toDouble(),
        total: json["Total"].toDouble(),
      );
}
