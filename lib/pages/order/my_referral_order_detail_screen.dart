import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/my_referral_order_detail_controller.dart';
import '../../model/my_referral_order_detail_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class MyReferralOrderDetailScreen extends StatefulWidget {
  final int orderId;
  final int ownerId;

  const MyReferralOrderDetailScreen({
    super.key,
    required this.orderId,
    required this.ownerId,
  });

  @override
  State<MyReferralOrderDetailScreen> createState() =>
      _MyReferralOrderDetailScreenState();
}

class _MyReferralOrderDetailScreenState
    extends State<MyReferralOrderDetailScreen> {
  final controller = Get.put(MyReferralOrderDetailController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrderDetail(
        orderId: widget.orderId,
        ownerId: widget.ownerId,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Order Details",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmer();
          }

          final data = controller.orderDetail.value;

          if (data == null) {
            return Center(
              child: Text(
                "No order details found",
                style:
                    AppTextStyle.normalRegular14.copyWith(color: Colors.grey),
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _orderInfoCard(data.myOrders),
                SizedBox(height: 16.sp),
                _productListCard(data.items ?? []),
                SizedBox(height: 16.sp),
                _totalCard(data.myOrders),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _orderInfoCard(MyOrders? order) {
    if (order == null) return const SizedBox();

    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Billing Address", style: AppTextStyle.normalBold16),
          SizedBox(height: 10.sp),
          _row("Name", "${order.firstName ?? ""} ${order.lastName ?? ""}"),
          _row("Email", order.email ?? "-"),
          _row("Phone", order.phoneNumber ?? "-"),
          _row("Address", order.address1 ?? "-"),
          _row("Zip", order.zipPostalCode ?? "-"),
          _row("Country", order.countryName ?? "-"),
          _row("State", order.stateName ?? "-"),
          _row(
            "Order Date",
            CommonMethod.formatDateFromDateTime(
              order.createdOn == null ? null : DateTime.parse(order.createdOn!),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _productListCard(List<OrderItem> items) {
    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Products", style: AppTextStyle.normalBold16),
          SizedBox(height: 10.sp),
          ...items.map((e) => _productRow(e)).toList(),
        ],
      ),
    );
  }

  Widget _productRow(OrderItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Column(
        children: [
          _row("Product", item.productName ?? "-"),
          _row("Price", "\$${item.unitPrice?.toStringAsFixed(2) ?? '0.00'}"),
          _row("Quantity", "${item.quantity ?? 0}"),
          _row("Total", "\$${item.total?.toStringAsFixed(2) ?? '0.00'}"),
          Divider(color: Colors.grey.shade300),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _totalCard(MyOrders? order) {
    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Order Summary", style: AppTextStyle.normalBold16),
          SizedBox(height: 10.sp),
          _row("Sub Total",
              "\$${order?.orderTotal?.toStringAsFixed(2) ?? '0.00'}"),
          _row("Shipping",
              "\$${order?.shippingTotal?.toStringAsFixed(2) ?? '0.00'}"),
          Divider(),
          _row(
            "Order Total",
            "\$${order?.orderTotal?.toStringAsFixed(2) ?? '0.00'}",
            isBold: true,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _row(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style:
                  AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
            ),
          ),
          width15,
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: isBold
                  ? AppTextStyle.normalBold14.copyWith(color: primaryBlack)
                  : AppTextStyle.normalSemiBold14.copyWith(color: primaryBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Billing Address shimmer
          _shimmerCard(),

          SizedBox(height: 14.sp),

          // Products shimmer
          _shimmerProductCard(),

          SizedBox(height: 14.sp),

          // Order Summary shimmer
          _shimmerSummaryCard(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _shimmerCard() {
    return ShadowContainerWidget(
      widget: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 18.sp, width: 120.w, color: Colors.white),
            SizedBox(height: 12.sp),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
            _shimmerRow(),
          ],
        ),
      ),
    );
  }

  Widget _shimmerProductCard() {
    return ShadowContainerWidget(
      widget: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 18.sp, width: 100.w, color: Colors.white),
            SizedBox(height: 12.sp),
            _shimmerProductRow(),
            Divider(color: Colors.white),
            _shimmerProductRow(),
          ],
        ),
      ),
    );
  }

  Widget _shimmerSummaryCard() {
    return ShadowContainerWidget(
      widget: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 18.sp, width: 120.w, color: Colors.white),
            SizedBox(height: 12.sp),
            _shimmerRow(),
            _shimmerRow(),
            Container(height: 1, color: Colors.white),
            SizedBox(height: 10.sp),
            _shimmerRow(),
          ],
        ),
      ),
    );
  }

  Widget _shimmerRow() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 14.sp,
              color: Colors.white,
            ),
          ),
          width15,
          Expanded(
            flex: 5,
            child: Container(
              height: 14.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerProductRow() {
    return Column(
      children: [
        _shimmerRow(),
        _shimmerRow(),
        _shimmerRow(),
        _shimmerRow(),
      ],
    );
  }
}
