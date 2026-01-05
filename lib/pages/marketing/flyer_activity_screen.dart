import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controller/flyers_controller.dart';
import '../../model/link_activity_details_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';

class FlyerActivityScreen extends StatefulWidget {
  final int sharedFlyerId;
  final String title;
  final String sharedTo;
  final int fileType;

  const FlyerActivityScreen({
    super.key,
    required this.sharedFlyerId,
    required this.title,
    required this.sharedTo,
    required this.fileType,
  });

  @override
  State<FlyerActivityScreen> createState() => _FlyerActivityScreenState();
}

class _FlyerActivityScreenState extends State<FlyerActivityScreen> {
  final FlyersController controller = Get.find<FlyersController>();

  @override
  void initState() {
    super.initState();
    controller.getLinkActivityDetails(
      fileShareId: widget.sharedFlyerId,
      fileType: widget.fileType,
      sharedTo: widget.sharedTo,
    );
  }

  // ------------------------------------------------------------
  // WEB UI MAPPINGS
  // ------------------------------------------------------------

  String _getTitle(String? type) {
    switch (type) {
      case "LinkOpen":
        return "Link Open";

      case "AudioPlayed":
      case "Audio Played":
        return "Audio Played";

      case "VideoPlayed":
      case "Video Played":
      case "VideoPlay":
      case "video_src":
        return "Video Played";

      case "FileViewed":
      case "File Viewed":
        return "File Viewed";

      case "FileDownloaded":
      case "File Downloaded":
        return "File Downloaded";

      case "MessageSent":
      case "Message Sent":
        return "Message Sent";

      case "FormFilled":
        return "Form Filled";

      case "button_click":
        return "Button Click";

      case "image_click":
        return "Image Click";

      case "product_name":
        return "Product Click";

      case "ReferralProgramCheckbox":
        return "Clicked on Referral Program Checkbox";

      case "WeeklyCallsCheckbox":
        return "Clicked on Weekly call invitation Checkbox";

      case "HealthSurvey":
        return "Health survey filled";

      default:
        return type ?? "Interaction";
    }
  }

  Color _getBadgeColor(String? type) {
    switch (type) {
      // badge-primary
      case "LinkOpen":
      case "product_name":
        return primaryColor;

      // badge-info
      case "AudioPlayed":
      case "Audio Played":
      case "VideoPlayed":
      case "Video Played":
      case "VideoPlay":
      case "video_src":
        return Colors.cyan;

      // badge-success
      case "FileViewed":
      case "File Viewed":
      case "FileDownloaded":
      case "File Downloaded":
        return greenColor;

      // badge-warning
      case "MessageSent":
      case "Message Sent":
      case "FormFilled":
        return orangeColor;

      // badge-secondary
      case "button_click":
      case "image_click":
      case "ReferralProgramCheckbox":
      case "WeeklyCallsCheckbox":
      case "HealthSurvey":
      default:
        return greySubTitleColor;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    return DateFormat('MMM dd, yyyy HH:mm').format(date.toLocal());
  }

  // ------------------------------------------------------------
  // CARD ITEM (MATCHES WEB)
  // ------------------------------------------------------------
  Widget _activityCard(LinkActivityDetailsModel item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // BADGE (FULL WIDTH)
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 6.sp),
            decoration: BoxDecoration(
              color: _getBadgeColor(item.activityType),
              borderRadius: BorderRadius.circular(20.sp),
            ),
            child: Center(
              child: Text(
                _getTitle(item.activityType),
                style:
                    AppTextStyle.normalSemiBold10.copyWith(color: Colors.white),
              ),
            ),
          ),

          SizedBox(height: 6.sp),

          // DATE (RIGHT ALIGNED)
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              _formatDate(item.activityDate),
              style: AppTextStyle.normalRegular12.copyWith(color: Colors.grey),
            ),
          ),

          // DESCRIPTION
          if ((item.interactionValue ?? item.activityDescription ?? "")
              .isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.sp),
              child: Text(
                item.interactionValue ?? item.activityDescription ?? "",
                style: AppTextStyle.normalRegular14
                    .copyWith(color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.activityLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<LinkActivityDetailsModel> items =
              controller.linkActivityDetailsModel;

          if (items.isEmpty) {
            return const NoDataFound(title: "No interactions yet");
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title, style: AppTextStyle.normalBold16),
                    const SizedBox(height: 6),
                    Text(
                      "Shared To - ${widget.sharedTo}",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16.sp),
                  itemCount: items.length,
                  itemBuilder: (_, index) {
                    return _activityCard(items[index]);
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
