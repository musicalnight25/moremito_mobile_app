import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/my_daily_compensation_controller.dart';
import '../../model/daily_compensation_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import 'order_compensation_detail_screen.dart';

class DailyOrderDetailsScreen extends StatefulWidget {
  const DailyOrderDetailsScreen({super.key});

  @override
  State<DailyOrderDetailsScreen> createState() =>
      _DailyOrderDetailsScreenState();
}

class _DailyOrderDetailsScreenState extends State<DailyOrderDetailsScreen> {
  final controller = Get.find<MyDailyCompensationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Order Details".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerLoading();
          }

          if (controller.orderItems.isEmpty) {
            return _buildEmptyState();
          }

          return ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(16.sp, 20.sp, 16.sp, 40.sp),
            itemCount: controller.orderItems.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.sp),
            itemBuilder: (_, index) {
              final item = controller.orderItems[index];
              return _buildProductionOrderCard(item);
            },
          );
        }),
      ),
    );
  }

  Widget _buildProductionOrderCard(OrderCompensationItem item) {
    final String date = item.orderDate != null
        ? DateFormat("yyyy-MM-dd").format(item.orderDate!)
        : "N/A";

    return GestureDetector(
      onTap: () {
        controller.fetchOrderDetail(item.orderId!);
        Get.to(() => const OrderCompensationDetailScreen());
      },
      child: ShadowContainerWidget(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  date ?? "Unknown Date",
                  style: AppTextStyle.normalSemiBold14
                      .copyWith(color: primaryBlack),
                ),
                const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),

            const Divider(height: 16),
            _tableRow(
              "User Name",
              item.orderOwner ?? "Unknown Customer",
            ),
            _tableRow(
              "Order No.",
              "${item.orderId ?? '-'}",
            ),

            _tableRow(
              "Order Amount",
              "\$${item.orderAmount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            _tableRow(
              "Compensation Amount",
              "\$${item.commissionAmount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            if (item.commissionLevel != null)
              _tableRow(
                "Level",
                item.commissionLevel.toString(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _tableRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyle.normalRegular14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined,
              size: 64.sp, color: Colors.grey.shade300),
          SizedBox(height: 16.sp),
          Text("No orders found".tr,
              style:
                  AppTextStyle.normalSemiBold16.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      padding: EdgeInsets.all(16.sp),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: EdgeInsets.only(bottom: 16.sp),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: Container(
            height: 180.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
            ),
          ),
        ),
      ),
    );
  }
}