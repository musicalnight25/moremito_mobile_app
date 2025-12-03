import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import 'package:more_mitro_app/controller/order_controller.dart';
import 'package:more_mitro_app/model/order_detail_response_model.dart';

import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrdersController controller = Get.find<OrdersController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getOrderDetail(widget.orderId);
    });
  }

  Future<void> _onRefresh() async {
    await controller.getOrderDetail(widget.orderId);
  }

  // ----------------------------------------------------------
  // FORMATTER
  // ----------------------------------------------------------
  String _value(dynamic v) {
    if (v == null) return "—";
    if (v.toString().trim().isEmpty) return "—";
    return v.toString();
  }

  // ----------------------------------------------------------
  // SHIMMER WIDGET
  // ----------------------------------------------------------
  Widget _shimmerCard({required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: Get.width,
        height: height,
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
      width: Get.width,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
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
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          // ------------------------------------------------------
          // SHIMMER LOADER
          // ------------------------------------------------------
          if (controller.detailLoading.value) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shimmerCard(height: 90),
                  height16,
                  _shimmerCard(height: 170),
                  height12,
                  _shimmerCard(height: 170),
                  height12,
                  _shimmerCard(height: 120),
                  height12,
                  _shimmerCard(height: 180),
                  height12,
                  _shimmerCard(height: 140),
                ],
              ),
            );
          }

          final OrderDetailData? data = controller.orderDetail.value;
          if (data == null) return const NoDataFound(title: "Order Details");

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _orderHeader(data.orderInfo),
                  height16,
                  _addressCard("Billing Address", data.billingInfo),
                  height12,
                  _addressCard("Shipping Address", data.shippingInfo),
                  height12,
                  _paymentCard(data.orderInfo),
                  height12,
                  _productCard(data.orderItems ?? []),
                  height12,
                  _priceCard(data.orderInfo),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // ----------------------------------------------------------
  // ORDER HEADER CARD
  // ----------------------------------------------------------
  Widget _orderHeader(OrderInfo? info) {
    final date = info?.orderDate?.toUtc().toString().split(".").first ?? "—";

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Date",
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack)),
          height08,
          Text("$date (UTC)",
              style:
                  AppTextStyle.normalRegular14.copyWith(color: textGreyColor)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ADDRESS CARD
  // ----------------------------------------------------------
  Widget _addressCard(String title, dynamic model) {
    late final String? line1;
    late final String? line2;
    late final String? city;
    late final String? state;
    late final String? country;
    late final String? zip;

    // Billing
    if (model is BillingInfo) {
      line1 = model.billingAddress1;
      line2 = model.billingAddress2;
      city = model.billingCity;
      state = model.billingStateName;
      country = model.billingCountryName;
      zip = model.billingZip;
    }
    // Shipping
    else if (model is ShippingInfo) {
      line1 = model.shippingAddress1;
      line2 = model.shippingAddress2;
      city = model.shippingCity;
      state = model.shippingStateName;
      country = model.shippingCountryName;
      zip = model.shippingZip;
    } else {
      return const SizedBox();
    }

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack)),
          height12,
          _row("Address Line 1", _value(line1)),
          height08,
          _row("Address Line 2", _value(line2)),
          height08,
          _row("City", _value(city)),
          height08,
          _row("State", _value(state)),
          height08,
          _row("Country", _value(country)),
          height08,
          _row("Zip Code", _value(zip)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PAYMENT CARD
  // ----------------------------------------------------------
  Widget _paymentCard(OrderInfo? info) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Payment Details",
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack)),
          height12,
          _row("Payment Status", _value(info?.paymentStatus)),
          height08,
          _row("Commission Paid",
              "\$${(info?.orderTotal ?? 0).toStringAsFixed(2)}"),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRODUCT LIST CARD
  // ----------------------------------------------------------
  Widget _productCard(List<OrderItem> items) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Products",
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack)),
          height12,
          ...items.map((item) {
            return Container(
              margin: EdgeInsets.only(bottom: 14.sp),
              padding: EdgeInsets.only(bottom: 14.sp),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row("Name", _value(item.productName)),
                  height06,
                  _row("Quantity", _value(item.quantity)),
                  height06,
                  _row("Price",
                      "\$${(item.unitPrice?.toDouble() ?? 0).toStringAsFixed(2)}"),
                ],
              ),
            );
          })
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRICE DETAILS CARD
  // ----------------------------------------------------------
  Widget _priceCard(OrderInfo? info) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Sub-Total", "\$${(info?.subTotal ?? 0).toStringAsFixed(2)}"),
          height08,
          _row("Shipping", "\$${(info?.shippingFee ?? 0).toStringAsFixed(2)}"),
          height08,
          _row("Sales Tax", "\$${(info?.orderTax ?? 0).toStringAsFixed(2)}"),
          height12,
          _row("Total", "\$${(info?.orderTotal ?? 0).toStringAsFixed(2)}",
              isTotal: true),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // REUSABLE ROW (Label + Value)
  // ----------------------------------------------------------
  Widget _row(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyle.normalRegular14.copyWith(color: textGreyColor)),
        width15,
        Flexible(
          child: Text(
            value,
            style: isTotal
                ? AppTextStyle.normalSemiBold18.copyWith(color: orangeColor)
                : AppTextStyle.normalRegular14.copyWith(color: primaryBlack),
          ),
        ),
      ],
    );
  }
}
