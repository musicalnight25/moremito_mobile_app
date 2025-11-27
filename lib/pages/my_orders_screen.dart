import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:more_mitro_app/controller/order_controller.dart';
import 'package:more_mitro_app/model/order_response_model.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../utils/primary_text_button.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrdersController controller = Get.put(OrdersController());

  @override
  void initState() {
    super.initState();
    controller.getOrderList();
  }

  // ----------------------------------------------------------
  // SHIMMER LOADER
  // ----------------------------------------------------------
  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        height: 120.sp,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(14.sp),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CARD WRAPPER
  // ----------------------------------------------------------
  Widget _card({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: child,
    );
  }

  // ----------------------------------------------------------
  // UI BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: CommonAppBar(title: "My Orders", visibleBackButton: true),
      body: RefreshIndicator(
        color: primaryColor,
        backgroundColor: Colors.white,
        onRefresh: () async {
          controller.page = 1;
          controller.hasMore = true;
          controller.orderList.clear();
          await controller.getOrderList();
        },
        child: Obx(() {
          // ------------ SHIMMER WHEN FIRST TIME LOADING ----------
          if (controller.listLoading.value && controller.orderList.isEmpty) {
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: List.generate(6, (_) => _shimmerCard()),
              ),
            );
          }

          if (controller.orderList.isEmpty) {
            return const NoDataFound(title: "Orders");
          }

          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.sp),
            child: Column(
              children: controller.orderList
                  .map((order) => _orderCard(order))
                  .toList(),
            ),
          );
        }),
      ),
    );
  }

  // ----------------------------------------------------------
  // ORDER CARD
  // ----------------------------------------------------------
  Widget _orderCard(Order order) {
    return GestureDetector(
      onTap: () {
        controller.getOrderDetail(order.orderId!);
        Get.to(() => OrderDetailsScreen(orderId: order.orderId!));
      },
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row("Order Number", "#${order.orderId}"),
            height10,
            _row("Order Date",
                order.orderDate?.toLocal().toString().split(".").first ?? "—"),
            height10,
            _row("Subtotal",
                "\$${order.subTotal?.toStringAsFixed(2) ?? '0.00'}"),
            height10,
            _row(
                "Shipping", "\$${(order.shippingFee ?? 0).toStringAsFixed(2)}"),
            height10,
            if ((order.orderTax ?? 0) > 0)
              _row(
                  "Sales Tax", "\$${(order.orderTax ?? 0).toStringAsFixed(2)}"),
            if ((order.orderTax ?? 0) > 0) height10,
            _row("Order Total",
                "\$${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}",
                isBold: true, color: primaryColor),
            height14,
            if (order.shippingStatus != null)
              _row("Shipping Status", order.shippingStatus ?? "—"),
            if (order.shippingStatus != null) height10,
            if (order.paymentStatus != null)
              _row("Payment Status", order.paymentStatus ?? "—"),
            customHeight(12),
            _supportButton(),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // REUSABLE LABEL-VALUE ROW
  // ----------------------------------------------------------
  Widget _row(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style:
                AppTextStyle.normalRegular14.copyWith(color: Colors.black54)),
        Text(
          value,
          style: (isBold
                  ? AppTextStyle.normalSemiBold16
                  : AppTextStyle.normalRegular14)
              .copyWith(color: color ?? primaryBlack),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // SUPPORT BUTTON
  // ----------------------------------------------------------
  Widget _supportButton() {
    return PrimaryTextButton(
      title: 'Send/View messages with support team',
      onPressed: () {
        CommonMethod.getXSnackBar(
          "Support",
          "Chat with support coming soon",
          greenColor,
        );
      },
    );
  }
}
