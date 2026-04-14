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
          if (controller.detailLoading.value) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: Column(
                children: [
                  _shimmerCard(height: 90),
                  height16,
                  _shimmerCard(height: 180),
                  height12,
                  _shimmerCard(height: 180),
                  height12,
                  _shimmerCard(height: 200),
                  height12,
                  _shimmerCard(height: 140),
                ],
              ),
            );
          }

          final OrderDetailData? data = controller.orderDetail.value;
          if (data == null) {
            return NoDataFound(title: "Order Details".tr);
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 20.sp),
              child: Column(
                children: [
                  _orderHeader(data.orderInfo),
                  height16,
                  _addressCard(
                    title: "Billing Address".tr,
                    billing: data.billingInfo,
                    shipping: null,
                    info: data.orderInfo,
                  ),
                  height12,
                  _addressCard(
                    title: "Shipping Address".tr,
                    billing: null,
                    shipping: data.shippingInfo,
                    info: data.orderInfo,
                  ),
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
  // ORDER HEADER
  // ----------------------------------------------------------
  Widget _orderHeader(OrderInfo? info) {
    final date = info?.orderDate?.toUtc().toString().split(".").first ?? "—";

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Order Number - {orderNumber}".trParams({
              "orderNumber": _value(info?.customOrderNumber),
            }),
            style: AppTextStyle.normalSemiBold18.copyWith(color: primaryBlack),
          ),
          height06,
          Text(
            "Order Date: {date} (UTC)".trParams({
              "date": date,
            }),
            style: AppTextStyle.normalRegular14.copyWith(color: textGreyColor),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // ADDRESS CARD
  // ----------------------------------------------------------
  Widget _addressCard({
    required String title,
    BillingInfo? billing,
    ShippingInfo? shipping,
    OrderInfo? info,
  }) {
    final name = billing != null
        ? "${billing.billingFirstName} ${billing.billingLastName}"
        : "${shipping?.shippingFirstName ?? ""} ${shipping?.shippingLastName ?? ""}";

    final line1 = billing?.billingAddress1 ?? shipping?.shippingAddress1;
    final line2 = billing?.billingAddress2 ?? shipping?.shippingAddress2;
    final city = billing?.billingCity ?? shipping?.shippingCity;
    final state = billing?.billingStateName ?? shipping?.shippingStateName;
    final country =
        billing?.billingCountryName ?? shipping?.shippingCountryName;
    final zip = billing?.billingZip ?? shipping?.shippingZip;

    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack)),
          // height06,
          // Text(
          //   "Order Number - ${_value(info?.customOrderNumber)}",
          //   style: AppTextStyle.normalRegular13.copyWith(color: textGreyColor),
          // ),
          height12,
          _row("Name", _value(name)),
          height08,
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
  // PRODUCT LIST
  // ----------------------------------------------------------
  Widget _productCard(List<OrderItem> items) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Products".tr,
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: primaryBlack)),
          height12,
          ...items.map((item) {
            return Container(
              margin: EdgeInsets.only(bottom: 14.sp),
              padding: EdgeInsets.only(bottom: 14.sp),
              decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.black12, width: .3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _row("Product", _value(item.productName)),
                  height06,
                  _row("Quantity", _value(item.quantity)),
                  height06,
                  _row(
                    "Unit Price",
                    "\$${(item.unitPrice ?? 0).toStringAsFixed(2)}",
                  ),
                  height06,
                  _row(
                    "Item Total",
                    "\$${(item.total ?? 0).toStringAsFixed(2)}",
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // PRICE SUMMARY
  // ----------------------------------------------------------
  Widget _priceCard(OrderInfo? info) {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Sub Total", "\$${(info?.subTotal ?? 0).toStringAsFixed(2)}"),
          height08,
          _row("Shipping Fee",
              "\$${(info?.shippingFee ?? 0).toStringAsFixed(2)}"),
          height08,
          _row("Tax", "\$${(info?.orderTax ?? 0).toStringAsFixed(2)}"),
          height12,
          _row(
            "Order Total",
            "\$${(info?.orderTotal ?? 0).toStringAsFixed(2)}",
            isTotal: true,
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // REUSABLE ROW
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
            textAlign: TextAlign.right,
            style: isTotal
                ? AppTextStyle.normalSemiBold18.copyWith(color: orangeColor)
                : AppTextStyle.normalRegular14.copyWith(color: primaryBlack),
          ),
        ),
      ],
    );
  }
}
