import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

// Ensure these imports match your project structure
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import '../../controller/my_compensation_controller.dart';
import '../../model/my_compensation_history_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import '../../utils/colors.dart';
import 'month_details_screen.dart';

class YearDetailsScreen extends StatelessWidget {
  final int year;

  const YearDetailsScreen({super.key, required this.year});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyCompensationController>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "$year Details",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          if (controller.months.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 48.sp, color: Colors.grey),
                  height10,
                  Text("No data available for $year",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 20.sp),
            itemCount: controller.months.length,
            separatorBuilder: (context, index) => SizedBox(height: 14.sp),
            itemBuilder: (_, index) {
              final MonthItem item = controller.months[index];
              return _buildMonthCard(item, controller);
            },
          );
        }),
      ),
    );
  }

  Widget _buildMonthCard(MonthItem item, MyCompensationController controller) {
    return GestureDetector(
      onTap: () {
        final monthIndex = _monthToInt(item.month);
        controller.fetchMonth(year, monthIndex);
        Get.to(() => MonthDetailsScreen(title: item.month ?? ""));
      },
      child: ShadowContainerWidget(
        widget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header Row (Month Name)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      item.month ?? "Unknown",
                      style: AppTextStyle.normalBold16.copyWith(
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16.sp, color: Colors.grey.shade400),
                ],
              ),
              Divider(height: 24.sp, color: Colors.grey.shade100),

              // 2. Primary Stat: Total Earned
              _dataRow(
                label: "Total Compensation Earned",
                value: "\$${item.totalEarned ?? '0.00'}",
                isTotal: true, // Highlights this row
              ),

              Divider(height: 24.sp, color: Colors.grey.shade100),

              // 3. Performance Metrics (Matching your screenshot columns)
              Text("Metrics",
                  style: AppTextStyle.normalSemiBold12
                      .copyWith(color: Colors.grey)),
              height08,
              _dataRow(
                label: "Avg. Order Amount",
                value: "\$${item.avgAmount?.toStringAsFixed(2) ?? '0.00'}",
              ),
              _dataRow(
                label: "Order Count",
                value: "${item.orderCount ?? 0}",
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
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.normalRegular14.copyWith(
                color: isTotal ? Colors.black87 : Colors.grey.shade600,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              ),
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
                        width: 100.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        height: 16.sp,
                        width: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.sp),
                // Rows Shimmer
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
                            height: 14.sp,
                            width: 120.w,
                            color: Colors.white,
                          ),
                        ),
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            height: 14.sp,
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
        );
      },
    );
  }

  int _monthToInt(String? month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    if (month == null) return 1;
    int index = months.indexOf(month);
    return index == -1 ? 1 : index + 1;
  }
}
