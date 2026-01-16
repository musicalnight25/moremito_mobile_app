import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// Import your actual file paths here
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import '../../controller/my_compensation_controller.dart';
import '../../model/my_compensation_history_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import '../../utils/common_method.dart';
import 'year_details_screen.dart';

class MyCompensationHistoryScreen extends StatelessWidget {
  const MyCompensationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ensure controller is loaded
    final controller = Get.put(MyCompensationController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "My Compensation",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          }

          final history = controller.history.value;

          if (history == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off,
                      size: 48.sp, color: Colors.grey),
                  height10,
                  Text("No compensation history found",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTotalCard(history.totalCompensationEarned),
                SizedBox(height: 24.sp),
                Text("Yearly Details", style: AppTextStyle.normalBold16),
                height10,
                ...(history.yearItems ?? [])
                    .map((e) => _buildYearCard(e, controller))
                    .toList(),
                SizedBox(height: 20.sp),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MAIN WIDGETS
  // ---------------------------------------------------------------------------

  Widget _buildTotalCard(String? total) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: primaryColor.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Compensation Earned",
                  style: AppTextStyle.normalSemiBold14
                      .copyWith(color: Colors.black54)),
              Container(
                padding: EdgeInsets.all(8.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Icon(Icons.account_balance_wallet_outlined,
                    color: primaryColor, size: 20.sp),
              )
            ],
          ),
          height10,
          Text(
            "\$${total ?? '0.00'}",
            style: AppTextStyle.normalBold24.copyWith(
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearCard(YearItem item, MyCompensationController controller) {
    return GestureDetector(
      onTap: () {
        if (item.year != null) {
          final year = int.parse(item.year!);
          controller.fetchYear(year);
          Get.to(() => YearDetailsScreen(year: year));
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 14.sp),
        child: ShadowContainerWidget(
          widget: Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 8.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header: Year
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.sp, vertical: 6.sp),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        item.year ?? "N/A",
                        style: AppTextStyle.normalBold16
                            .copyWith(color: Colors.black87),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_rounded,
                        size: 16.sp, color: Colors.grey.shade400),
                  ],
                ),
                Divider(height: 24.sp, color: Colors.grey.shade100),

                // 2. Earnings Breakdown Section
                Text("Earnings",
                    style: AppTextStyle.normalSemiBold12
                        .copyWith(color: Colors.grey)),
                height08,
                _dataRow(
                  label: "MoreMito Cash",
                  value: "\$${item.moreMitoCash ?? '0.00'}",
                ),
                _dataRow(
                  label: "MoreMito Commission",
                  value: "\$${item.moreMitoCommission ?? '0.00'}",
                ),
                Divider(height: 16.sp, color: Colors.grey.shade50),
                _dataRow(
                  label: "Total Earned",
                  value: "\$${item.totalCompensationEarned ?? '0.00'}",
                  isTotal: true, // Make this bold/colored
                ),

                Divider(height: 24.sp, color: Colors.grey.shade100),

                // 3. Performance Metrics Section
                Text("Performance Metrics",
                    style: AppTextStyle.normalSemiBold12
                        .copyWith(color: Colors.grey)),
                height08,
                _dataRow(
                  label: "Avg. Order Amount",
                  value:
                      "\$${item.averageOrderAmount?.toStringAsFixed(2) ?? '0.00'}",
                ),
                _dataRow(
                  label: "Customer Count",
                  value: "${item.customerCount ?? 0}",
                ),
                _dataRow(
                  label: "Avg. Earned / Customer",
                  value:
                      "\$${item.avgEarnedPerCustomer?.toStringAsFixed(2) ?? '0.00'}",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataRow({
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyle.normalRegular14.copyWith(
              color: isTotal ? Colors.black87 : Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyle.normalBold16.copyWith(color: primaryColor)
                : AppTextStyle.normalSemiBold14.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHIMMER LOADING
  // ---------------------------------------------------------------------------

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Card Shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 100.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 24.sp),

          // Title Shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 20.h,
              width: 150.w,
              color: Colors.white,
            ),
          ),
          height10,

          // List Items Shimmer
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 14.sp),
                child: ShadowContainerWidget(
                  widget: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                      children: [
                        // Header Shimmer
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              child: Container(
                                height: 24.h,
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
                        // Row lines Shimmer
                        for (int i = 0; i < 4; i++) ...[
                          Padding(
                            padding: EdgeInsets.only(bottom: 10.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 14.h,
                                    width: 100.w,
                                    color: Colors.white,
                                  ),
                                ),
                                Shimmer.fromColors(
                                  baseColor: Colors.grey.shade300,
                                  highlightColor: Colors.grey.shade100,
                                  child: Container(
                                    height: 14.h,
                                    width: 60.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
