import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/cash_transfer_history_controller.dart';
import '../../model/cash_transfer_history_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class CashTransferHistoryScreen extends StatelessWidget {
  const CashTransferHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CashTransferHistoryController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Transfer History".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          }

          final data = controller.history.value;

          if (data == null || (data.recievedList?.isEmpty ?? true)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.swap_horiz_outlined,
                      size: 48.sp, color: Colors.grey),
                  height10,
                  Text(
                    "No transfer history found".tr,
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
                Text("MoreMito Cash Transfer History".tr,
                    style: AppTextStyle.normalBold20),
                const SizedBox(height: 6),
                Text(
                  "Below is the history of the MoreMito Cash you have received.".tr,
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
                SizedBox(height: 16.sp),
                _buildTotalCard(data.totalReceived),
                SizedBox(height: 16.sp),
                ...(data.recievedList ?? [])
                    .map((e) => _buildTransferCard(e))
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
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: primaryColor.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "MoreMito Cash Transferred To You".tr,
            style: AppTextStyle.normalRegular16.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 6.sp),
          Row(
            children: [
              Text(
                "Total Received: ".tr,
                style: AppTextStyle.normalRegular14.copyWith(
                  color: hintGreyColor,
                  letterSpacing: 0.3,
                ),
              ),
              Text(
                "\$${(total ?? 0).toStringAsFixed(2)}",
                style: AppTextStyle.normalBold14.copyWith(
                  color: primaryBlack,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TRANSFER CARD
  // ---------------------------------------------------------------------------

  Widget _buildTransferCard(CashTransferItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: ShadowContainerWidget(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dataRow(
              label: "Date Received".tr,
              value: CommonMethod.formatDateFromDateTime(item.transferDate),
            ),
            _dataRow(
              label: "Sent By".tr,
              value: item.uName ?? "-",
            ),
            _dataRow(
              label: "Amount".tr,
              value: "\$${item.transferAmount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            if ((item.message ?? "").isNotEmpty)
              _dataRow(
                label: "Message".tr,
                value: item.message!,
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
  // SHIMMER
  // ---------------------------------------------------------------------------

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                        _shimmerLine(120.w),
                        SizedBox(height: 12.sp),
                        _shimmerLine(double.infinity),
                        _shimmerLine(160.w),
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