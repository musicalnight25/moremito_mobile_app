import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

import '../../controller/my_compensation_controller.dart';
import '../../model/my_compensation_history_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import '../../utils/colors.dart';

class MonthDetailsScreen extends StatelessWidget {
  final String title;

  const MonthDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyCompensationController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: title,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          if (controller.commissions.isEmpty) {
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
                    child: Icon(Icons.receipt_long_rounded,
                        size: 40.sp, color: Colors.grey),
                  ),
                  height10,
                  Text("No commission records found",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            itemCount: controller.commissions.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.sp),
            itemBuilder: (_, index) {
              final CommissionDetail item = controller.commissions[index];
              return _buildCommissionCard(item);
            },
          );
        }),
      ),
    );
  }

  Widget _buildCommissionCard(CommissionDetail item) {
    // Determine date to show (handle nulls safely)
    final String date = item.orderDate != null && item.orderDate!.isNotEmpty
        ? item.orderDate!
        : "N/A";

    return ShadowContainerWidget(
      widget: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Amount and Type Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "\$${item.amount ?? '0.00'}",
                  style: AppTextStyle.normalBold18.copyWith(
                    color: Colors.green.shade700,
                    letterSpacing: 0.5,
                  ),
                ),
                _buildTypeBadge(item.type),
              ],
            ),

            Divider(height: 24.sp, color: Colors.grey.shade100),

            // 2. Description Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.description_outlined,
                    size: 16.sp, color: Colors.grey.shade500),
                width10,
                Expanded(
                  child: Text(
                    item.description ?? "No description available",
                    style: AppTextStyle.normalRegular14.copyWith(
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),

            height12,

            // 3. Footer: Commission Level & Order Date
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // LEFT: Commission Level
                  Row(
                    children: [
                      Icon(Icons.layers_outlined,
                          size: 14.sp, color: Colors.grey.shade600),
                      SizedBox(width: 6.sp),
                      RichText(
                        text: TextSpan(
                          text: "Level: ",
                          style: AppTextStyle.normalRegular12
                              .copyWith(color: Colors.grey.shade600),
                          children: [
                            TextSpan(
                              text: item.commissionLevel ?? "-",
                              style: AppTextStyle.normalSemiBold12
                                  .copyWith(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // RIGHT: Order Date
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 14.sp, color: Colors.grey.shade600),
                      SizedBox(width: 6.sp),
                      Text(
                        date,
                        style: AppTextStyle.normalSemiBold12
                            .copyWith(color: Colors.black87),
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

  Widget _buildTypeBadge(String? type) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Text(
        (type ?? 'Unknown').toUpperCase(),
        style: AppTextStyle.normalSemiBold10.copyWith(
          color: primaryColor,
          letterSpacing: 0.5,
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
      itemCount: 8,
      separatorBuilder: (context, index) => SizedBox(height: 12.sp),
      itemBuilder: (context, index) {
        return ShadowContainerWidget(
          widget: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Shimmer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 20.sp,
                        width: 80.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 20.sp,
                        width: 60.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.sp),
                // Description Shimmer
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 16.sp,
                        width: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                    width10,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 12.sp,
                              width: double.infinity,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.sp),
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.grey.shade100,
                            child: Container(
                              height: 12.sp,
                              width: 150.w,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.sp),
                // Footer Shimmer (Date & Level)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 12.sp,
                        width: 80.w,
                        color: Colors.white,
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 12.sp,
                        width: 80.w,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
