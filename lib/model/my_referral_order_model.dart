import 'dart:convert';

MyReferralOrdersResponse myReferralOrdersResponseFromJson(String str) =>
    MyReferralOrdersResponse.fromJson(json.decode(str));

class MyReferralOrdersResponse {
  bool? status;
  MyReferralOrdersData? data;

  MyReferralOrdersResponse({this.status, this.data});

  factory MyReferralOrdersResponse.fromJson(Map<String, dynamic> json) =>
      MyReferralOrdersResponse(
        status: json["Status"],
        data: json["Data"] == null
            ? null
            : MyReferralOrdersData.fromJson(json["Data"]),
      );
}

class MyReferralOrdersData {
  List<MyReferralOrder>? orderList;

  MyReferralOrdersData({this.orderList});

  factory MyReferralOrdersData.fromJson(Map<String, dynamic> json) =>
      MyReferralOrdersData(
        orderList: json["OrderList"] == null
            ? []
            : List<MyReferralOrder>.from(
                json["OrderList"].map((x) => MyReferralOrder.fromJson(x))),
      );
}

class MyReferralOrder {
  int? userId;
  String? userName;
  int? orderId;
  double? orderTotal;
  String? createdOn;
  String? orderStatus;
  String? shippingMethodName;
  String? shippingTrackingId;

  MyReferralOrder({
    this.userId,
    this.userName,
    this.orderId,
    this.orderTotal,
    this.createdOn,
    this.orderStatus,
    this.shippingMethodName,
    this.shippingTrackingId,
  });

  factory MyReferralOrder.fromJson(Map<String, dynamic> json) =>
      MyReferralOrder(
        userId: json["UserId"],
        userName: json["UserName"],
        orderId: json["OrderId"],
        orderTotal: json["OrderTotal"]?.toDouble(),
        createdOn: json["CreatedOn"],
        orderStatus: json["OrderStatus"],
        shippingMethodName: json["ShippingMethodName"],
        shippingTrackingId: json["ShippingTrackingId"],
      );
}
