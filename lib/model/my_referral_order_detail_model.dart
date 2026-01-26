import 'dart:convert';

MyReferralOrderDetailResponse myReferralOrderDetailResponseFromJson(
        String str) =>
    MyReferralOrderDetailResponse.fromJson(json.decode(str));

class MyReferralOrderDetailResponse {
  bool? status;
  MyReferralOrderDetailData? data;

  MyReferralOrderDetailResponse({this.status, this.data});

  factory MyReferralOrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      MyReferralOrderDetailResponse(
        status: json["Status"],
        data: json["Data"] == null
            ? null
            : MyReferralOrderDetailData.fromJson(json["Data"]),
      );
}

class MyReferralOrderDetailData {
  List<OrderItem>? items;
  MyOrders? myOrders;

  MyReferralOrderDetailData({this.items, this.myOrders});

  factory MyReferralOrderDetailData.fromJson(Map<String, dynamic> json) =>
      MyReferralOrderDetailData(
        items: json["Items"] == null
            ? []
            : List<OrderItem>.from(
                json["Items"].map((x) => OrderItem.fromJson(x))),
        myOrders: json["myOrders"] == null
            ? null
            : MyOrders.fromJson(json["myOrders"]),
      );
}

class OrderItem {
  String? productName;
  double? unitPrice;
  int? quantity;
  double? total;

  OrderItem({this.productName, this.unitPrice, this.quantity, this.total});

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productName: json["ProductName"],
        unitPrice: json["UnitPrice"]?.toDouble(),
        quantity: json["Quantity"],
        total: json["Total"]?.toDouble(),
      );
}

class MyOrders {
  String? orderId;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? address1;
  String? zipPostalCode;
  String? countryName;
  String? stateName;
  double? orderTotal;
  double? shippingTotal;
  String? createdOn;

  MyOrders({
    this.orderId,
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.address1,
    this.zipPostalCode,
    this.countryName,
    this.stateName,
    this.orderTotal,
    this.shippingTotal,
    this.createdOn,
  });

  factory MyOrders.fromJson(Map<String, dynamic> json) => MyOrders(
        orderId: json["OrderId"],
        firstName: json["FirstName"],
        lastName: json["LastName"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        address1: json["Address1"],
        zipPostalCode: json["ZipPostalCode"],
        countryName: json["CountryName"],
        stateName: json["StateName"],
        orderTotal: json["OrderTotal"]?.toDouble(),
        shippingTotal: json["ShippingTotal"]?.toDouble(),
        createdOn: json["CreatedOn"],
      );
}
