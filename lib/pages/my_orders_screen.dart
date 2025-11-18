import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';

import '../utils/primary_text_button.dart';

class MyOrdersScreen extends StatelessWidget {
  final RxBool isLoading = false.obs;

  // Dummy orders for UI (replace with API response)
  final RxList<Map<String, dynamic>> orders = <Map<String, dynamic>>[
    {
      "orderNumber": "91216",
      "orderDate": "2025-10-02 11:00:53 (UTC)",
      "orderAmount": 30.0,
      "shipping": 0.0,
      "tax": 0.0,
      "total": 30.0,
      "shippingMethod": null,
      "trackingId": null,
      "trackingStatus": null,
    },
    {
      "orderNumber": "89674",
      "orderDate": "2025-09-15 14:06:12 (UTC)",
      "orderAmount": 30.0,
      "shipping": 0.0,
      "tax": 0.0,
      "total": 30.0,
      "shippingMethod": null,
      "trackingId": null,
      "trackingStatus": null,
    },
    {
      "orderNumber": "88461",
      "orderDate": "2025-09-01 16:11:55 (UTC)",
      "orderAmount": 60.0,
      "shipping": 9.34,
      "tax": 6.17,
      "total": 75.51,
      "shippingMethod": "UPS 3 Day Select®",
      "trackingId": "-",
      "trackingStatus": "Awaiting Shipping Label",
    },
  ].obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(title: "My Orders", visibleBackButton: true),
      body: Obx(() {
        if (isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (orders.isEmpty) {
          return const NoDataFound(title: "Orders");
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: orders.map((order) => _orderCard(order)).toList(),
          ),
        );
      }),
    );
  }

  // ===================== ORDER CARD =====================
  Widget _orderCard(Map<String, dynamic> order) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _orderRow("Order Number", order["orderNumber"]),
          customHeight(10),
          _orderRow("Order Date", order["orderDate"]),
          customHeight(10),
          _orderRow("Order Amount", "\$${order["orderAmount"]}"),
          customHeight(10),
          _orderRow("Shipping Amount", "\$${order["shipping"]}"),
          customHeight(10),
          if ((order["tax"] ?? 0) > 0)
            Column(
              children: [
                _orderRow("Sales Tax", "\$${order["tax"]}"),
                customHeight(10),
              ],
            ),
          _orderRow("Order Total", "\$${order["total"]}",
              isBold: true, color: primaryColor),
          customHeight(14),
          if (order["shippingMethod"] != null) ...[
            _orderRow("Shipping Method", order["shippingMethod"]),
            customHeight(10),
          ],
          if (order["trackingId"] != null) ...[
            _orderRow("Tracking Id", order["trackingId"]),
            customHeight(10),
            _orderRow("Status", order["trackingStatus"]),
            customHeight(14),
          ],
          _chatButton(),
        ],
      ),
    );
  }

  // ===================== ROW ITEM =====================
  Widget _orderRow(String label, String value,
      {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                AppTextStyle.normalRegular14.copyWith(color: Colors.black87)),
        Text(
          value,
          style: (isBold
                  ? AppTextStyle.normalBold16
                  : AppTextStyle.normalRegular14)
              .copyWith(color: color ?? Colors.black87),
        ),
      ],
    );
  }

  // ===================== CHAT BUTTON =====================
  Widget _chatButton() {
    return PrimaryTextButton(
      title: 'Send/View messages with support team',
      onPressed: () {
        CommonMethod.getXSnackBar(
            "Support", "Chat with support coming soon", greenColor);
      },
    );
  }
}
