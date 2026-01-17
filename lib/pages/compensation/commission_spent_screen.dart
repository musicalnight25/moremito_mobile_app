import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/compensation/widget/commission_spent_shimmer.dart';
import '../../controller/commission_spent_controller.dart';
import '../../model/compensation_spent_on_orders_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class CommissionSpentScreen extends StatefulWidget {
  const CommissionSpentScreen({super.key});

  @override
  State<CommissionSpentScreen> createState() => _CommissionSpentScreenState();
}

class _CommissionSpentScreenState extends State<CommissionSpentScreen> {
  final controller = Get.put(CommissionSpentController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetch();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Compensation Spent On Orders",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          final data = controller.data.value;
          final items = data?.items ?? [];
          final isListEmpty = items.isEmpty;

          // 1. Initial Loading (Full Screen Shimmer)
          if (controller.isLoading.value && isListEmpty) {
            return const CommissionSpentShimmer();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 2. Search Bar
              Padding(
                padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 4.sp),
                child: _buildSearchBar(controller),
              ),

              // 3. Content List with Pagination
              Expanded(
                child: isListEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: controller.refreshAll,
                        child: NotificationListener<ScrollNotification>(
                          onNotification: (ScrollNotification scrollInfo) {
                            // Trigger loadMore when scrolling reaches the bottom
                            if (!controller.isLoading.value &&
                                !controller.isPaginationLoading.value &&
                                scrollInfo.metrics.pixels >=
                                    scrollInfo.metrics.maxScrollExtent - 50 &&
                                controller.hasMore) {
                              controller.loadMore();
                            }
                            return false;
                          },
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.sp, vertical: 16.sp),

                            // CALCULATE ITEM COUNT:
                            // 1 (Total Card) + Items Length + 1 (Bottom Loader if hasMore)
                            itemCount:
                                1 + items.length + (controller.hasMore ? 1 : 0),

                            separatorBuilder: (_, __) =>
                                SizedBox(height: 14.sp),
                            itemBuilder: (_, index) {
                              // --- A. Header (Total Card) ---
                              if (index == 0) {
                                return _buildTotalCard(data?.totalAmount);
                              }

                              // --- B. Bottom Loader ---
                              // If we are at the last index AND hasMore is true
                              if (index == items.length + 1) {
                                return Padding(
                                  padding:
                                      EdgeInsets.symmetric(vertical: 10.sp),
                                  child: const Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
                                );
                              }

                              // --- C. List Item ---
                              // Adjust index by -1 because index 0 is the Header
                              return _buildItemCard(items[index - 1]);
                            },
                          ),
                        ),
                      ),
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
  Widget _buildSearchBar(CommissionSpentController controller) {
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
              controller: controller.orderController,
              keyboardType: TextInputType.number,
              style: AppTextStyle.normalRegular14,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => controller.searchByOrder(),
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
          IconButton(
            icon: Icon(Icons.refresh, size: 20.sp, color: Colors.grey),
            onPressed: () {
              controller.refreshAll();
            },
            constraints: const BoxConstraints(),
            padding: EdgeInsets.symmetric(horizontal: 8.sp),
            tooltip: "Clear & Refresh",
          ),
          width08,
          ElevatedButton(
            onPressed: controller.searchByOrder,
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
  // TOTAL CARD
  // ---------------------------------------------------------------------------
  Widget _buildTotalCard(double? total) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.12),
            primaryColor.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: primaryColor.withOpacity(0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total Amount",
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 6.sp),
          Text(
            "\$${(total ?? 0).toStringAsFixed(2)}",
            style: AppTextStyle.normalBold16.copyWith(color: primaryBlack),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ITEM CARD
  // ---------------------------------------------------------------------------
  Widget _buildItemCard(CommissionSpentItem item) {
    final isRefunded = item.isRefunded == true;

    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isRefunded) Center(child: _refundChip()),
          _tableRow("OrderId", "${item.orderId ?? '-'}"),
          _tableRow(
            "Amount Paid",
            "\$${item.amount?.toStringAsFixed(2) ?? '0.00'}",
            isBoldValue: isRefunded,
          ),
          _tableRow("Commission Type", item.commissionType ?? "-"),
          _tableRow("Date", CommonMethod.formatDate(item.date)),
        ],
      ),
    );
  }

  Widget _refundChip() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        "Refunded",
        style: AppTextStyle.normalSemiBold12.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _tableRow(String label, String value, {bool isBoldValue = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style:
                  AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
            ),
          ),
          width15,
          Expanded(
            child: Text(
              value,
              style: isBoldValue
                  ? AppTextStyle.normalSemiBold14
                  : AppTextStyle.normalRegular14,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STATES: EMPTY
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
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
          Text(
            "No records found",
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
