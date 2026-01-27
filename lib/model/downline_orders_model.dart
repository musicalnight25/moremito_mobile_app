import 'dart:convert';

DownlineOrdersResponse downlineOrdersResponseFromJson(String str) =>
    DownlineOrdersResponse.fromJson(json.decode(str));

class DownlineOrdersResponse {
  bool status;
  DownlineOrdersData data;

  DownlineOrdersResponse({required this.status, required this.data});

  factory DownlineOrdersResponse.fromJson(Map<String, dynamic> json) =>
      DownlineOrdersResponse(
        status: json["Status"],
        data: DownlineOrdersData.fromJson(json["Data"]),
      );
}

class DownlineOrdersData {
  int totalCount;
  int pageNumber;
  int pageSize;
  bool hasMore;
  List<DownlineOrder> orders;

  DownlineOrdersData({
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.hasMore,
    required this.orders,
  });

  factory DownlineOrdersData.fromJson(Map<String, dynamic> json) =>
      DownlineOrdersData(
        totalCount: json["TotalCount"],
        pageNumber: json["PageNumber"],
        pageSize: json["PageSize"],
        hasMore: json["HasMore"],
        orders: List<DownlineOrder>.from(
          json["Orders"].map((x) => DownlineOrder.fromJson(x)),
        ),
      );
}

class DownlineOrder {
  int orderId;
  int userId;
  String userName;
  double orderAmount;
  String orderDate;
  String? shippingMethod;
  String? trackingId;
  String shippingStatusText;

  DownlineOrder({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.orderAmount,
    required this.orderDate,
    this.shippingMethod,
    this.trackingId,
    required this.shippingStatusText,
  });

  factory DownlineOrder.fromJson(Map<String, dynamic> json) => DownlineOrder(
        orderId: json["OrderId"],
        userId: json["UserId"],
        userName: json["UserName"],
        orderAmount: json["OrderAmount"].toDouble(),
        orderDate: json["OrderDate"],
        shippingMethod: json["ShippingMethod"],
        trackingId: json["TrackingId"],
        shippingStatusText: json["ShippingStatusText"],
      );
}
