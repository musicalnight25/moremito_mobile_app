import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/my_referral_orders_controller.dart';
import '../../model/my_referral_order_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';
import 'my_referral_order_detail_screen.dart';

class MyReferralOrdersScreen extends StatefulWidget {
  const MyReferralOrdersScreen({super.key});

  @override
  State<MyReferralOrdersScreen> createState() => _MyReferralOrdersScreenState();
}

class _MyReferralOrdersScreenState extends State<MyReferralOrdersScreen> {
  final controller = Get.put(MyReferralOrdersController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Referral & Downline Orders",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          final list = controller.ordersData.value?.orderList ?? [];

          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined,
                      size: 48.sp, color: Colors.grey),
                  height10,
                  Text(
                    "No orders found",
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            child: Column(
              children: list.map((e) => _orderCard(e)).toList(),
            ),
          );
        }),
      ),
    );
  }

  Widget _orderCard(MyReferralOrder order) {
    return GestureDetector(
      onTap: () {
        Get.to(() => MyReferralOrderDetailScreen(
              orderId: order.orderId!,
              ownerId: order.userId!,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ShadowContainerWidget(
          widget: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header: Name + Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      order.userName ?? "Unknown User",
                      style: AppTextStyle.normalSemiBold14
                          .copyWith(color: primaryBlack),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),

              const Divider(height: 16),

              _tableRow("Order No", "#${order.orderId ?? '-'}"),
              _tableRow(
                "Amount",
                "\$${order.orderTotal?.toStringAsFixed(2) ?? '0.00'}",
              ),
              _tableRow(
                "Date",
                CommonMethod.formatDateFromDateTime(
                  order.createdOn == null
                      ? null
                      : DateTime.parse(order.createdOn!),
                ),
              ),
              _tableRow("Status", order.orderStatus ?? "-"),
              _tableRow("Shipping", order.shippingMethodName ?? "N/A"),
              _tableRow("Tracking", order.shippingTrackingId ?? "N/A"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tableRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
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
              style:
                  AppTextStyle.normalSemiBold14.copyWith(color: primaryBlack),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: ListView.separated(
        padding: EdgeInsets.all(16.sp),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 14.sp),
        itemBuilder: (_, __) {
          return ShadowContainerWidget(
            widget: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header shimmer (Name + arrow)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 16.sp,
                        width: 140.w,
                        color: Colors.white,
                      ),
                      Container(
                        height: 16.sp,
                        width: 16.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),

                  SizedBox(height: 12.sp),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white,
                  ),
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
        },
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
}
