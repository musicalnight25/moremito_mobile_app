import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

import '../../controller/my_daily_compensation_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import '../../utils/colors.dart'; // Ensure colors are imported

class DailyOrderDetailsScreen extends StatelessWidget {
  const DailyOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyDailyCompensationController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Order Details",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          if (controller.orderItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.sp),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.shopping_cart_outlined,
                        size: 40.sp, color: Colors.grey),
                  ),
                  height10,
                  Text("No orders found for this date",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            itemCount: controller.orderItems.length,
            separatorBuilder: (context, index) => SizedBox(height: 14.sp),
            itemBuilder: (_, index) {
              final item = controller.orderItems[index];
              return _buildOrderCard(item);
            },
          );
        }),
      ),
    );
  }

  Widget _buildOrderCard(dynamic item) {
    return ShadowContainerWidget(
      widget: Padding(
        padding: EdgeInsets.all(12.sp), // Consistent padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Order ID
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.sp),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.receipt_long_rounded,
                      size: 18.sp, color: primaryColor),
                ),
                width10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${item.orderId}",
                      style: AppTextStyle.normalBold16.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                    // Optional: You could put status here if available
                  ],
                ),
              ],
            ),

            Divider(height: 24.sp, color: Colors.grey.shade100),

            // 2. Customer Info
            Row(
              children: [
                Icon(Icons.person_outline_rounded,
                    size: 16.sp, color: Colors.grey.shade500),
                width08,
                Expanded(
                  child: Text(
                    item.orderOwner ?? "Unknown Customer",
                    style: AppTextStyle.normalRegular14.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),

            height12,

            // 3. Financials (Row with colored background for emphasis)
            Container(
              padding: EdgeInsets.all(12.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Order Amount
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Order Amount",
                          style: AppTextStyle.normalRegular12
                              .copyWith(color: Colors.grey.shade600)),
                      height04,
                      Text(
                        "\$${item.orderAmount?.toStringAsFixed(2) ?? '0.00'}",
                        style: AppTextStyle.normalSemiBold14,
                      ),
                    ],
                  ),

                  // Vertical Divider
                  Container(
                    height: 30.h,
                    width: 1,
                    color: Colors.grey.shade300,
                  ),

                  // Commission (Highlighted)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Commission",
                          style: AppTextStyle.normalRegular12
                              .copyWith(color: Colors.grey.shade600)),
                      height04,
                      Text(
                        "\$${item.commissionAmount?.toStringAsFixed(2) ?? '0.00'}",
                        style: AppTextStyle.normalBold16.copyWith(
                          color: Colors.green.shade700, // Success color
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHIMMER LOADING
  // ---------------------------------------------------------------------------

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: EdgeInsets.all(16.sp),
      itemCount: 6,
      separatorBuilder: (context, index) => SizedBox(height: 14.sp),
      itemBuilder: (context, index) {
        return ShadowContainerWidget(
          widget: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Shimmer
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 34.sp,
                        width: 34.sp,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    width10,
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 16.sp,
                        width: 100.w,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.sp),
                // Name Row Shimmer
                Row(
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 14.sp,
                        width: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                    width08,
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 14.sp,
                        width: 150.w,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.sp),
                // Footer Box Shimmer
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 50.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
