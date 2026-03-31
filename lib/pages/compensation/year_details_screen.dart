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
        title: "$year Details".tr,
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
                  Text("No data available for $year".tr,
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
              return buildMonthRow(item, controller);
            },
          );
        }),
      ),
    );
  }

  Widget buildMonthRow(
    MonthItem item,
    MyCompensationController controller,
  ) {
    return InkWell(
      onTap: () {
        final monthIndex = _monthToInt(item.month);
        controller.fetchMonth(year, monthIndex);
        Get.to(() => MonthDetailsScreen(title: item.month ?? ""));
      },
      child: ShadowContainerWidget(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.month ?? "",
                  style: AppTextStyle.normalSemiBold16
                      .copyWith(color: primaryBlack),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),

            const Divider(height: 16),

            _tableRow("MoreMito Cash", "\$0.00"),
            _tableRow(
              "MoreMito Commission",
              "\$${item.totalEarned ?? "0.00"}",
            ),
            _tableRow(
              "Total Compensation Earned",
              "\$${item.totalEarned ?? "0.00"}",
            ),
            _tableRow(
              "Average Order Amount",
              "\$${item.avgAmount?.toStringAsFixed(2) ?? "0.00"}",
            ),
            _tableRow(
              "Customer Count",
              "${item.customerCount ?? 0}",
            ),
            _tableRow(
              "Order Count",
              "${item.orderCount ?? 0}",
            ),
            _tableRow(
              "Avg Earned / Customer",
              "\$${item.avgEarnedPerCustomer?.toStringAsFixed(2) ?? "0.00"}",
            ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyle.normalRegular14.copyWith(
                color: hintGreyColor,
              ),
            ),
          ),
          width15,
          Text(
            value,
            style: AppTextStyle.normalRegular14,
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
