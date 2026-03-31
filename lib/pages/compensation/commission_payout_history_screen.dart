import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/commission_payout_history_controller.dart';
import '../../model/commission_payout_history_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class CommissionPayoutHistoryScreen extends StatefulWidget {
  const CommissionPayoutHistoryScreen({super.key});

  @override
  State<CommissionPayoutHistoryScreen> createState() =>
      _CommissionPayoutHistoryScreenState();
}

class _CommissionPayoutHistoryScreenState
    extends State<CommissionPayoutHistoryScreen> {
  final controller = Get.put(CommissionPayoutHistoryController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchHistory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Commission Payout History".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          }

          final data = controller.history.value;

          if (data == null || (data.transactions?.isEmpty ?? true)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off,
                      size: 48.sp, color: Colors.grey),
                  height10,
                  Text(
                    "No payout history found".tr,
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: Colors.grey),
                  ),
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
                _buildTotalCard(data.totalApprovedAmount),
                SizedBox(height: 24.sp),
                Text(
                  "Requested Commission History".tr,
                  style: AppTextStyle.normalBold16,
                ),
                height10,
                ...(data.transactions ?? [])
                    .map((e) => _buildTransactionCard(e))
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: primaryColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Approved Amount".tr,
                style: AppTextStyle.normalRegular12
                    .copyWith(color: Colors.black54),
              ),
              SizedBox(height: 6.sp),
              Text(
                "\$${(total ?? 0).toStringAsFixed(2)}",
                style: AppTextStyle.normalBold16.copyWith(
                  color: primaryColor,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          Container(
            height: 36.sp,
            width: 36.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.08),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.payments_outlined,
              size: 18.sp,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildTransactionCard(CommissionTransaction tx) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: ShadowContainerWidget(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dataRow(
              label: "Transaction Id".tr,
              value: "${tx.transactionId ?? '-'}",
            ),
            _dataRow(
              label: "Amount".tr,
              value: "\$${tx.amount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            _dataRow(
              label: "Date".tr,
              value: CommonMethod.formatDateFromDateTime(tx.date),
            ),
            _dataRow(
              label: "Payment Method".tr,
              value: tx.paymentMethod ?? "-",
            ),
            _dataRow(
              label: "Payment Status".tr,
              value: tx.paymentStatus ?? "-",
            ),
            if ((tx.description ?? "").isNotEmpty)
              _dataRow(
                label: "Description".tr,
                value: tx.description!,
                isMultiline: true,
              ),
          ],
        ),
      ),
    );
  }

  Widget _dataRow({
    required String label,
    required String value,
    bool isMultiline = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style:
                  AppTextStyle.normalRegular14.copyWith(color: hintGreyColor),
            ),
          ),
          width15,
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style:
                  AppTextStyle.normalSemiBold14.copyWith(color: primaryBlack),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total card shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 90.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
          ),
          SizedBox(height: 24.sp),

          // List shimmer
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (_, __) {
              return Padding(
                padding: EdgeInsets.only(bottom: 14.sp),
                child: ShadowContainerWidget(
                  widget: Padding(
                    padding: EdgeInsets.all(12.sp),
                    child: Column(
                      children: [
                        _shimmerLine(80.w),
                        SizedBox(height: 12.sp),
                        _shimmerLine(double.infinity),
                        _shimmerLine(double.infinity),
                        _shimmerLine(120.w),
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

  Widget _shimmerLine(double width) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 14.h,
        width: width,
        color: Colors.white,
      ),
    );
  }
}