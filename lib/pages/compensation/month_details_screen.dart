import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:shimmer/shimmer.dart';

// Ensure these imports match your project structure
import '../../controller/my_compensation_controller.dart';
import '../../model/my_compensation_history_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/colors.dart';
import '../../utils/static_decoration.dart';

class MonthDetailsScreen extends StatelessWidget {
  final String title;

  const MonthDetailsScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyCompensationController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CommonAppBar(
        title: title,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            SizedBox(height: 16.sp),
            // Custom Segmented Control Tab
            _buildCustomTabBar(controller),

            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildShimmerLoading();
                }

                // Toggle between views
                return controller.selectedTab.value == 0
                    ? _buildSummaryList(controller)
                    : _buildDetailsList(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.separated(
      padding: EdgeInsets.all(16.sp),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 6,
      separatorBuilder: (_, __) => SizedBox(height: 16.sp),
      itemBuilder: (_, __) {
        return ShadowContainerWidget(
          widget: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Column(
              children: List.generate(5, (index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          height: 12.sp,
                          width: 120.w,
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
                );
              }),
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 1. SLEEK TAB BAR
  // ---------------------------------------------------------------------------
  Widget _buildCustomTabBar(MyCompensationController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.sp),
      padding: EdgeInsets.all(4.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Row(
            children: [
              _buildTabItem(
                label: "Commission Type Summary".tr,
                isSelected: controller.selectedTab.value == 0,
                onTap: () => controller.selectedTab.value = 0,
              ),
              _buildTabItem(
                label: "Commissions Details".tr,
                isSelected: controller.selectedTab.value == 1,
                onTap: () => controller.selectedTab.value = 1,
              ),
            ],
          )),
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(vertical: 10.sp),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyle.normalSemiBold14.copyWith(
                color: isSelected ? Colors.white : Colors.grey.shade600,
                fontSize: 13.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. SUMMARY TAB (Card View of Web Table)
  // ---------------------------------------------------------------------------
  Widget _buildSummaryList(MyCompensationController controller) {
    if (controller.commissionSummary.isEmpty) {
      return _buildEmptyState("No summary data available");
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.sp),
      itemCount: controller.commissionSummary.length,
      separatorBuilder: (_, __) => SizedBox(height: 16.sp),
      itemBuilder: (context, index) {
        final item = controller.commissionSummary[index];
        return buildSummaryRow(item);
      },
    );
  }

  Widget buildSummaryRow(CommissionTypeSummary item) {
    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (item.commissionType != null)
            _tableRow(
              "Commission Type",
              "\$${item.commissionType ?? '-'}",
            ),
          _tableRow(
            "MoreMito Cash",
            "\$${item.moreMitoCash ?? '0.00'}",
          ),
          _tableRow(
            "MoreMito Commission",
            "\$${item.moreMitoCommission ?? '0.00'}",
          ),
          _tableRow(
            "Total Earned",
            "\$${item.totalEarned ?? '0.00'}",
          ),
          _tableRow(
            "Running Total",
            "\$${item.runningTotal?.toStringAsFixed(2) ?? '0.00'}",
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
            "Average Amount",
            "\$${item.avgAmount?.toStringAsFixed(2) ?? '0.00'}",
          ),
        ],
      ),
    );
  }

  Widget _tableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Text(
              label,
              style: AppTextStyle.normalRegular14.copyWith(
                color: hintGreyColor,
              ),
            ),
          ),
          width15,
          Expanded(
            child: Text(
              value,
              style: AppTextStyle.normalRegular14,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. DETAILS TAB (Card View of Web Details)
  // ---------------------------------------------------------------------------
  Widget _buildDetailsList(MyCompensationController controller) {
    if (controller.commissions.isEmpty) {
      return _buildEmptyState("No commission details found");
    }

    return ListView.separated(
      padding: EdgeInsets.all(16.sp),
      itemCount: controller.commissions.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.sp),
      itemBuilder: (context, index) {
        final item = controller.commissions[index];
        return buildDetailRow(item);
      },
    );
  }

  Widget buildDetailRow(CommissionDetail item) {
    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _tableRow(
            "Order Date",
            item.orderDate ?? "N/A",
          ),
          _tableRow(
            "Amount",
            "\$${item.amount ?? '0.00'}",
          ),
          _tableRow(
            "Description",
            item.description ?? "N/A",
          ),
          _tableRow(
            "Type",
            item.type ?? "N/A",
          ),
          _tableRow(
            "Commission Level",
            item.commissionLevel ?? "-",
          ),
        ],
      ),
    );
  }

  Widget _buildTag(
      {required String label, required Color color, required Color textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: color.withOpacity(0.5)), // Subtle border
      ),
      child: Text(
        label,
        style: AppTextStyle.normalSemiBold12
            .copyWith(color: textColor, fontSize: 11.sp),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.feed_outlined, size: 48.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.sp),
          Text(message,
              style: AppTextStyle.normalRegular14.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}
