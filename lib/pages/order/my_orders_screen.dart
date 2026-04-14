import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:shimmer/shimmer.dart';

import 'package:more_mitro_app/controller/order_controller.dart';
import 'package:more_mitro_app/model/order_response_model.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/text_primary_button.dart';
import '../../utils/primary_text_button.dart';
import 'order_details_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrdersController controller = Get.put(OrdersController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.getOrderList();

    scrollController.addListener(() {
      if (!controller.hasMore) return;
      if (controller.loadMoreLoading.value) return;

      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;

      if (currentScroll >= maxScroll * 0.80) {
        controller.getOrderList();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  // ----------------------------------------------------------
  // SHIMMER
  // ----------------------------------------------------------
  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        height: 150.sp,
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
  // STATUS BADGE UI
  // ----------------------------------------------------------
  Widget _statusBadge(String status) {
    Color bg;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case "delivered":
        bg = const Color(0xff28C76F); // green
        break;
      case "awaiting":
        bg = const Color(0xffF4B740); // yellow/orange
        break;
      case "cancelled":
        bg = const Color(0xffEA5455); // red
        break;
      case "refunded":
        bg = const Color(0xff00CFE8); // blue
        break;
      default:
        bg = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30.sp),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.normalSemiBold12.copyWith(color: textColor),
      ),
    );
  }

// ----------------------------------------------------------
// ORDER CARD — FULLY UPDATED DYNAMIC VERSION
// ----------------------------------------------------------
  Widget _orderCard(Order order) {
    final String? shippingStatus = order.shippingStatus;
    final String? paymentStatus = order.paymentStatus;

    // Final order status
    String? status;
    if (shippingStatus != null) {
      status = shippingStatus;
    } else if (paymentStatus == "Refunded") {
      status = "Refunded";
    }

    // Dynamic tracking URL (safe)
    String? finalTrackingUrl = order.trackingUrl ??
        (order.trackingId != null && order.trackingId!.isNotEmpty
            ? "https://tools.usps.com/go/TrackConfirmAction?tLabels=${order.trackingId}"
            : null);

    return GestureDetector(
      onTap: () {
        controller.getOrderDetail(order.orderId!);
        Get.to(() => OrderDetailsScreen(orderId: order.orderId!));
      },
      child: _card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- TOP ROW ----------------
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Order Number : {orderId}".trParams({
                      "orderId": "${order.orderId ?? '-'}",
                    }),
                    style: AppTextStyle.normalSemiBold18,
                  ),
                ),
                if (status != null) _statusBadge(status),
              ],
            ),
            SizedBox(height: 6.sp),

            // ---------------- DATE ----------------
            Text(
              CommonMethod.formatDateTime(order.orderDate),
              style:
                  AppTextStyle.normalRegular12.copyWith(color: Colors.black54),
            ),

            height16,

            // ---------------- BAD ADDRESS WARNING ----------------
            // if (order.hasBadAddress == true)
            //   Container(
            //     width: double.infinity,
            //     padding: EdgeInsets.all(10.sp),
            //     margin: EdgeInsets.only(bottom: 12.sp),
            //     decoration: BoxDecoration(
            //       color: Colors.orange.shade100,
            //       borderRadius: BorderRadius.circular(6.sp),
            //     ),
            //     child: Text(
            //       order.addressWarningText ?? "Warning",
            //       style: AppTextStyle.normalSemiBold14
            //           .copyWith(color: Colors.orange.shade900),
            //     ),
            //   ),

            // ---------------- ORDER AMOUNTS ----------------
            _row("Order Amount",
                "\$${order.subTotal?.toStringAsFixed(2) ?? '0.00'}"),
            height08,
            _row("Shipping Amount",
                "\$${order.shippingFee?.toStringAsFixed(2) ?? '0.00'}"),
            height08,
            if ((order.orderTax ?? 0) > 0)
              _row("Sales Tax", "\$${order.orderTax?.toStringAsFixed(2)}"),
            if ((order.orderTax ?? 0) > 0) height08,
            _row(
              "Order Total",
              "\$${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}",
              isBold: true,
              color: primaryColor,
            ),

            height16,

            // ======================================================
            // ---------------- SHIPPING METHOD (Fully Dynamic) -----
            // ======================================================
            if (order.shippingMethod != null &&
                order.shippingMethod!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Shipping Method".tr,
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: Colors.black54),
                  ),
                  SizedBox(height: 6.sp),
                  Text(
                    order.shippingMethod!,
                    style: AppTextStyle.normalSemiBold14,
                  ),
                  height12,
                ],
              ),

            // ======================================================
            // ---------------- TRACKING ID (Fully Dynamic) ---------
            // ======================================================
            if (order.trackingId != null && order.trackingId!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tracking ID".tr,
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: Colors.black54),
                  ),
                  SizedBox(height: 4.sp),
                  InkWell(
                    onTap: () {
                      if (finalTrackingUrl != null) {
                        final uri = Uri.tryParse(finalTrackingUrl);

                        launchUrl(uri!);
                      }
                    },
                    child: Text(
                      order.trackingId!,
                      style: AppTextStyle.normalSemiBold14.copyWith(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  height12,
                ],
              ),

            // ======================================================
            // ---------------- SUPPORT LINK -----------------------
            // ======================================================
            // CommonTextActionButton(
            //   title: "Send/View messages with support team".tr,
            //   onTap: () {
            //     CommonMethod.getXSnackBar(
            //       "Support",
            //       "Chat with support coming soon",
            //       greenColor,
            //     );
            //   },
            // ),

            // ======================================================
            // ---------------- REPORT LINK (Cancelled) -------------
            // ======================================================
            // if (status?.toLowerCase() == "cancelled")
            //   IconButton(
            //     onPressed: () {},
            //     icon: Text(
            //       "Report missing/damaged items",
            //       style: AppTextStyle.normalSemiBold14.copyWith(
            //         color: redColor,
            //         decorationColor: redColor,
            //         decoration: TextDecoration.underline,
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // ROW
  // ----------------------------------------------------------
  Widget _row(String label, String value, {bool isBold = false, Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.normalRegular14.copyWith(color: Colors.black54),
        ),
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
  // BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(title: "My Order".tr, visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async {
            controller.page = 1;
            controller.hasMore = true;
            controller.orderList.clear();
            await controller.getOrderList();
          },
          child: Obx(() {
            if (controller.listLoading.value && controller.orderList.isEmpty) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16.sp),
                child: Column(
                  children: List.generate(6, (_) => _shimmerCard()),
                ),
              );
            }

            if (controller.orderList.isEmpty) {
              return NoDataFound(title: "Orders".tr);
            }

            return SingleChildScrollView(
              controller: scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              child: Column(
                children: [
                  ...controller.orderList.map((e) => _orderCard(e)).toList(),
                  if (controller.loadMoreLoading.value)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 18.sp),
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
