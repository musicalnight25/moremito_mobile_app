// To parse this JSON data, do
//
//     final notificationDetailResponseModel = notificationDetailResponseModelFromJson(jsonString);

import 'dart:convert';

NotificationDetailResponseModel notificationDetailResponseModelFromJson(
        String str) =>
    NotificationDetailResponseModel.fromJson(json.decode(str));

String notificationDetailResponseModelToJson(
        NotificationDetailResponseModel data) =>
    json.encode(data.toJson());

class NotificationDetailResponseModel {
  bool? status;
  dynamic message;
  NotificationDetailModel? data;

  NotificationDetailResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory NotificationDetailResponseModel.fromJson(Map<String, dynamic> json) =>
      NotificationDetailResponseModel(
        status: json["Status"],
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : NotificationDetailModel.fromJson(json["Data"]),
      );

  Map<String, dynamic> toJson() => {
        "Status": status,
        "Message": message,
        "Data": data?.toJson(),
      };
}

class NotificationDetailModel {
  AutoShipComing? autoShipComing;
  MessageDetails? messageDetails;

  NotificationDetailModel({
    this.autoShipComing,
    this.messageDetails,
  });

  factory NotificationDetailModel.fromJson(Map<String, dynamic> json) =>
      NotificationDetailModel(
        autoShipComing: json["AutoShipComing"] == null
            ? null
            : AutoShipComing.fromJson(json["AutoShipComing"]),
        messageDetails: json["MessageDetails"] == null
            ? null
            : MessageDetails.fromJson(json["MessageDetails"]),
      );

  Map<String, dynamic> toJson() => {
        "AutoShipComing": autoShipComing?.toJson(),
        "MessageDetails": messageDetails?.toJson(),
      };
}

class AutoShipComing {
  String? title;
  String? message;
  DateTime? notificationDate;
  dynamic? orderId;
  DateTime? autoshipDate;
  String? name;
  dynamic? orderSubTotal;
  double? shippingFee;
  double? orderTotal;
  List<ProductList>? productList;
  ShippingAddress? shippingAddress;

  AutoShipComing({
    this.title,
    this.message,
    this.notificationDate,
    this.orderId,
    this.autoshipDate,
    this.name,
    this.orderSubTotal,
    this.shippingFee,
    this.orderTotal,
    this.productList,
    this.shippingAddress,
  });

  factory AutoShipComing.fromJson(Map<String, dynamic> json) => AutoShipComing(
        title: json["Title"],
        message: json["Message"],
        notificationDate: json["NotificationDate"] == null
            ? null
            : DateTime.parse(json["NotificationDate"]),
        orderId: json["OrderId"],
        autoshipDate: json["AutoshipDate"] == null
            ? null
            : DateTime.parse(json["AutoshipDate"]),
        name: json["Name"],
        orderSubTotal: json["OrderSubTotal"],
        shippingFee: json["ShippingFee"]?.toDouble(),
        orderTotal: json["OrderTotal"]?.toDouble(),
        productList: json["ProductList"] == null
            ? []
            : List<ProductList>.from(
                json["ProductList"]!.map((x) => ProductList.fromJson(x))),
        shippingAddress: json["ShippingAddress"] == null
            ? null
            : ShippingAddress.fromJson(json["ShippingAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Message": message,
        "NotificationDate": notificationDate?.toIso8601String(),
        "OrderId": orderId,
        "AutoshipDate": autoshipDate?.toIso8601String(),
        "Name": name,
        "OrderSubTotal": orderSubTotal,
        "ShippingFee": shippingFee,
        "OrderTotal": orderTotal,
        "ProductList": productList == null
            ? []
            : List<dynamic>.from(productList!.map((x) => x.toJson())),
        "ShippingAddress": shippingAddress?.toJson(),
      };
}

class ProductList {
  String? productName;
  dynamic? quantity;
  dynamic? unitPrice;
  dynamic? price;

  ProductList({
    this.productName,
    this.quantity,
    this.unitPrice,
    this.price,
  });

  factory ProductList.fromJson(Map<String, dynamic> json) => ProductList(
        productName: json["ProductName"],
        quantity: json["Quantity"],
        unitPrice: json["UnitPrice"],
        price: json["Price"],
      );

  Map<String, dynamic> toJson() => {
        "ProductName": productName,
        "Quantity": quantity,
        "UnitPrice": unitPrice,
        "Price": price,
      };
}

class ShippingAddress {
  String? countryName;
  String? countryCode;
  String? stateName;
  String? stateCode;
  String? address1;
  String? city;
  String? zip;

  ShippingAddress({
    this.countryName,
    this.countryCode,
    this.stateName,
    this.stateCode,
    this.address1,
    this.city,
    this.zip,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) =>
      ShippingAddress(
        countryName: json["CountryName"],
        countryCode: json["CountryCode"],
        stateName: json["StateName"],
        stateCode: json["StateCode"],
        address1: json["Address1"],
        city: json["City"],
        zip: json["Zip"],
      );

  Map<String, dynamic> toJson() => {
        "CountryName": countryName,
        "CountryCode": countryCode,
        "StateName": stateName,
        "StateCode": stateCode,
        "Address1": address1,
        "City": city,
        "Zip": zip,
      };
}

class MessageDetails {
  String? title;
  String? message;
  DateTime? notificationDate;
  dynamic? orderId;
  String? message1;
  String? message2;
  String? message3;
  dynamic message4;
  dynamic message5;

  MessageDetails({
    this.title,
    this.message,
    this.notificationDate,
    this.orderId,
    this.message1,
    this.message2,
    this.message3,
    this.message4,
    this.message5,
  });

  factory MessageDetails.fromJson(Map<String, dynamic> json) => MessageDetails(
        title: json["Title"],
        message: json["Message"],
        notificationDate: json["NotificationDate"] == null
            ? null
            : DateTime.parse(json["NotificationDate"]),
        orderId: json["OrderId"],
        message1: json["Message1"],
        message2: json["Message2"],
        message3: json["Message3"],
        message4: json["Message4"],
        message5: json["Message5"],
      );

  Map<String, dynamic> toJson() => {
        "Title": title,
        "Message": message,
        "NotificationDate": notificationDate?.toIso8601String(),
        "OrderId": orderId,
        "Message1": message1,
        "Message2": message2,
        "Message3": message3,
        "Message4": message4,
        "Message5": message5,
      };
}
