import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/cash_sent_history_controller.dart';
import '../../model/cash_sent_to_others_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/shadow_container_widget.dart';
import '../../utils/static_decoration.dart';

class CashSentHistoryScreen extends StatefulWidget {
  const CashSentHistoryScreen({super.key});

  @override
  State<CashSentHistoryScreen> createState() => _CashSentHistoryScreenState();
}

class _CashSentHistoryScreenState extends State<CashSentHistoryScreen> {
  final controller = Get.put(CashSentHistoryController());

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
        title: "MoreMito Cash Sent To Others",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _buildShimmerEffect();
          }

          final data = controller.history.value;

          if (data == null || (data.transfers?.isEmpty ?? true)) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu_outlined,
                      size: 48.sp, color: Colors.grey),
                  height10,
                  Text(
                    "No sent history found",
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
                Text("MoreMito Cash Transfer History",
                    style: AppTextStyle.normalBold20),
                const SizedBox(height: 6),
                Text(
                  "Below is the history of the MoreMito Cash you have transferred.",
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
                SizedBox(height: 16.sp),

                /// Total Card
                _buildTotalCard(data.totalSent),

                SizedBox(height: 16.sp),

                /// List Items
                ...(data.transfers ?? [])
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
            "MoreMito Cash Transferred By You",
            style: AppTextStyle.normalRegular16.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 6.sp),
          Row(
            children: [
              Text(
                "Total Sent: ",
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
  // ITEM CARD
  // ---------------------------------------------------------------------------
  Widget _buildTransferCard(CashSentItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: ShadowContainerWidget(
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _dataRow(
              label: "Date Transferred",
              value: CommonMethod.formatDateFromDateTime(item.dateTransferred),
            ),
            _dataRow(
              label: "Sent To",
              value: item.sentTo ?? "-",
            ),
            _dataRow(
              label: "Amount",
              value: "\$${item.amount?.toStringAsFixed(2) ?? '0.00'}",
            ),
            if ((item.message ?? "").isNotEmpty)
              _dataRow(
                label: "Message",
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
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Row(
        crossAxisAlignment:
            isMultiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
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
            // flex: 5,
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
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
                    SizedBox(height: 12.sp),
                    _shimmerLine(160.w),
                  ],
                ),
              ),
            ),
          );
        },
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
