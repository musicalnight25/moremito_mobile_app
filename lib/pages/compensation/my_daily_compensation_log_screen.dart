import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

import '../../controller/my_daily_compensation_controller.dart';
import '../../model/daily_compensation_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/colors.dart';
import '../../utils/static_decoration.dart';
import 'daily_order_details_screen.dart';

class MyDailyCompensationLogScreen extends StatelessWidget {
  const MyDailyCompensationLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller handles the fetch in onInit() now.
    final controller = Get.put(MyDailyCompensationController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Daily Compensation Log",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          // 1. Initial Loading (Full Screen Shimmer)
          // Only show this if list is empty AND we are loading.
          // If list has data (pagination), we don't show full screen shimmer.
          if (controller.isLoading.value && controller.dailyItems.isEmpty) {
            return _buildShimmerLoading();
          }

          return Column(
            children: [
              // 2. Search Bar
              Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 4.sp),
                child: _buildSearchBar(controller),
              ),

              // 3. Content List
              Expanded(
                child: controller.dailyItems.isEmpty
                    ? _buildEmptyState(controller)
                    : _buildList(controller),
              ),
            ],
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH BAR COMPONENT
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar(MyDailyCompensationController controller) {
    return Container(
      padding: EdgeInsets.all(4.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.orderNoCtrl,
              keyboardType: TextInputType.number,
              style: AppTextStyle.normalRegular14,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.searchByOrderNo(),
              decoration: InputDecoration(
                hintText: "Search by Order No.",
                hintStyle:
                    AppTextStyle.normalRegular14.copyWith(color: Colors.grey),
                prefixIcon: Icon(Icons.search,
                    color: Colors.grey.shade400, size: 20.sp),
                isDense: true,
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 12.sp),
              ),
            ),
          ),

          // Clear Button
          if (controller.orderNoCtrl.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.cancel, size: 20.sp, color: Colors.grey),
              onPressed: controller.clearSearch,
              constraints: const BoxConstraints(),
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
            ),

          width08,

          // Go Button
          ElevatedButton(
            onPressed: controller.searchByOrderNo,
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Go",
              style:
                  AppTextStyle.normalSemiBold14.copyWith(color: Colors.white),
            ),
          ),
          SizedBox(width: 4.sp),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LIST LOGIC (WITH PAGINATION)
  // ---------------------------------------------------------------------------
  Widget _buildList(MyDailyCompensationController controller) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        // Trigger loadMore when scrolling reaches bottom
        if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 50 &&
            !controller.isLoading.value &&
            !controller.isSearchingByOrder &&
            controller.hasMore.value) {
          controller.fetchDailyLogs(loadMore: true);
        }
        return false;
      },
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
        // Add +1 item for the bottom spinner if we are loading more pages
        itemCount: controller.dailyItems.length +
            (controller.isLoading.value && !controller.isSearchingByOrder
                ? 1
                : 0),
        separatorBuilder: (_, __) => SizedBox(height: 14.sp),
        itemBuilder: (_, index) {
          // Bottom Loader Widget
          if (index == controller.dailyItems.length) {
            return Padding(
              padding: EdgeInsets.all(16.sp),
              child: const Center(child: CircularProgressIndicator.adaptive()),
            );
          }

          final item = controller.dailyItems[index];
          return _buildDailyLogCard(item, controller);
        },
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CARD COMPONENT
  // ---------------------------------------------------------------------------
  Widget _buildDailyLogCard(
    DailyCompensationItem item,
    MyDailyCompensationController controller,
  ) {
    return GestureDetector(
      onTap: () {
        if (item.orderDate != null) {
          controller.fetchOrdersByDate(item.orderDate!);
          Get.to(() => const DailyOrderDetailsScreen());
        }
      },
      child: ShadowContainerWidget(
        widget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.sp, vertical: 8.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header: Date
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
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 14.sp, color: Colors.black87),
                        width08,
                        Text(
                          item.orderDateString ?? "Unknown Date",
                          style: AppTextStyle.normalBold14
                              .copyWith(color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 16.sp, color: Colors.grey.shade400),
                ],
              ),

              Divider(height: 24.sp, color: Colors.grey.shade100),

              // 2. Primary Stat: Total Commission
              _dataRow(
                label: "Total Commission",
                value:
                    "\$${item.commissionAmount?.toStringAsFixed(2) ?? '0.00'}",
                icon: Icons.monetization_on_outlined,
                isTotal: true,
              ),

              Divider(height: 20.sp, color: Colors.grey.shade50),

              // 3. Secondary Stats Grid
              Row(
                children: [
                  Expanded(
                    child: _miniStat(
                      icon: Icons.shopping_bag_outlined,
                      label: "Orders",
                      value: "${item.orderCount ?? 0}",
                    ),
                  ),
                  Expanded(
                    child: _miniStat(
                      icon: Icons.people_outline_rounded,
                      label: "Customers",
                      value: "${item.customerCount ?? 0}",
                    ),
                  ),
                ],
              ),

              height12,

              // 4. Avg Stat
              _dataRow(
                label: "Avg / Order",
                value:
                    "\$${item.avgCommissionAmount?.toStringAsFixed(2) ?? '0.00'}",
                icon: Icons.pie_chart_outline_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HELPER WIDGETS
  // ---------------------------------------------------------------------------
  Widget _miniStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: Colors.grey.shade500),
            width06,
            Text(label,
                style: AppTextStyle.normalRegular12
                    .copyWith(color: Colors.grey.shade600)),
          ],
        ),
        SizedBox(height: 4.sp),
        Padding(
          padding: EdgeInsets.only(left: 20.sp),
          child: Text(value, style: AppTextStyle.normalSemiBold14),
        ),
      ],
    );
  }

  Widget _dataRow({
    required String label,
    required String value,
    required IconData icon,
    bool isTotal = false,
  }) {
    return Row(
      children: [
        Icon(icon,
            size: 18.sp, color: isTotal ? primaryColor : Colors.grey.shade400),
        width10,
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
    );
  }

  // ---------------------------------------------------------------------------
  // STATES: EMPTY & SHIMMER
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState(MyDailyCompensationController controller) {
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
            child: Icon(Icons.history_edu_rounded,
                size: 40.sp, color: Colors.grey),
          ),
          height10,
          Text(
            controller.isSearchingByOrder
                ? "No order found with that ID"
                : "No compensation logs found",
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.grey),
          ),
          if (controller.isSearchingByOrder) ...[
            height10,
            TextButton.icon(
              onPressed: controller.clearSearch,
              icon: const Icon(Icons.refresh),
              label: const Text("View All Logs"),
            )
          ]
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h), // Push down below header area
      child: ListView.separated(
        padding: EdgeInsets.all(16.sp),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 14.sp),
        itemBuilder: (_, __) {
          return ShadowContainerWidget(
            widget: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 24.sp, width: 100.w, color: Colors.white),
                        Container(
                            height: 16.sp, width: 20.w, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 16.sp),
                    Container(
                        height: 16.sp,
                        width: double.infinity,
                        color: Colors.white),
                    SizedBox(height: 12.sp),
                    Row(
                      children: [
                        Expanded(
                            child:
                                Container(height: 30.sp, color: Colors.white)),
                        width10,
                        Expanded(
                            child:
                                Container(height: 30.sp, color: Colors.white)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
