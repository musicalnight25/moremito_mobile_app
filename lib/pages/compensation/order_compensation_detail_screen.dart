import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/compensation/widget/order_compensation_detail_shimmer.dart';

import '../../controller/my_daily_compensation_controller.dart';
import '../../model/order_compensation_detail_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class OrderCompensationDetailScreen extends StatelessWidget {
  const OrderCompensationDetailScreen({super.key});

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
          /// ✅ SHIMMER INSTEAD OF CIRCULAR LOADER
          if (controller.isOrderDetailLoading.value) {
            return const OrderCompensationDetailShimmer();
          }

          if (controller.orderDetailItems.isEmpty) {
            return const Center(child: Text("No details found"));
          }

          final items = controller.orderDetailItems;
          final orderId = items.first.orderId;

          return ListView(
            padding: EdgeInsets.fromLTRB(16.sp, 20.sp, 16.sp, 40.sp),
            children: [
              /// Order Header
              Text(
                "$orderId",
                style:
                    AppTextStyle.normalSemiBold16.copyWith(color: primaryColor),
              ),
              height06,
              Text(
                "Commission processing date",
                style:
                    AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
              ),
              height16,

              /// Cards
              ...items.map(_buildCompensationCard),
            ],
          );
        }),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMPENSATION CARD
  // ---------------------------------------------------------------------------
  Widget _buildCompensationCard(OrderCompensationDetailItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: ShadowContainerWidget(
        widget: Column(
          children: [
            _row("User Name", item.orderOwner ?? "-"),
            _row("Compensation Type", item.advanceCommissionType ?? "U1"),
            _row(
              "Order Amount",
              "\$${item.orderAmount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            _row(
              "Gross Order Amount",
              "\$${item.orderAmount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            _row(
              "Compensation %",
              "25.00", // backend not sending %
            ),
            _row(
              "Compensation Amount",
              "\$${item.commissionAmount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            _row("Level", item.commissionLevel ?? "-"),
            _row("Type", "COMMISSION"),
            _row("Description", item.description ?? "-"),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // COMMON ROW
  // ---------------------------------------------------------------------------
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
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
              textAlign: TextAlign.right,
              style: AppTextStyle.normalRegular14,
            ),
          ),
        ],
      ),
    );
  }
}
