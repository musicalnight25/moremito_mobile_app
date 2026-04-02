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

  /// Only icon + color mapping
  ({Color color, IconData icon}) _getIconStyle(String? type) {
    switch (type) {
      case "VideoPlay":
      case "Video Played":
      case "VideoPlayed":
      case "video_src":
        return (color: redColor, icon: Icons.play_circle_fill_rounded);

      case "AudioPlayed":
      case "Audio Played":
        return (color: orangeColor, icon: Icons.audiotrack_rounded);

      case "LinkOpen":
        return (color: primaryColor, icon: Icons.link);

      case "FileViewed":
      case "File Viewed":
        return (color: greenColor, icon: Icons.visibility_rounded);

      case "FileDownloaded":
      case "File Downloaded":
        return (color: greenColor, icon: Icons.download_rounded);

      case "FormFilled":
      case "ReferralProgramCheckbox":
      case "WeeklyCallsCheckbox":
      case "HealthSurvey":
        return (color: primaryColor, icon: Icons.assignment_turned_in_rounded);

      case "MessageSent":
      case "Message Sent":
        return (color: orangeColor, icon: Icons.send_rounded);

      case "button_click":
        return (color: lightBlackColor, icon: Icons.touch_app_rounded);

      case "image_click":
        return (color: hintGreyColor, icon: Icons.image_rounded);

      default:
        return (color: primaryColor, icon: Icons.notifications_active_rounded);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('MMM dd, hh:mm a').format(date.toLocal());
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.all(16.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: AppTextStyle.normalBold16.copyWith(
              fontSize: 16.sp,
              color: primaryBlack,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 16.sp, color: subTitleColor.withOpacity(0.7)),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  widget.sharedTo.isEmpty ? "Unknown User" : widget.sharedTo,
                  style: AppTextStyle.normalRegular14
                      .copyWith(fontSize: 13.sp, color: Colors.black87),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _activityCard(LinkActivityDetailsModel item) {
    final style = _getIconStyle(item.activityType);
    final title = item.activityDescription ?? item.activityType ?? "";
    final subtitle = item.interactionValue ?? "";
    final hasSubtitle = subtitle.trim().isNotEmpty;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderGreyColor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: style.color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(style.icon, color: style.color, size: 22.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.normalSemiBold14.copyWith(
                    fontSize: 15.sp,
                    color: primaryBlack,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          if (hasSubtitle) ...[
            SizedBox(height: 10.h),
            Text(
              subtitle,
              style: AppTextStyle.normalRegular14.copyWith(
                fontSize: 13.sp,
                color: lightBlackColor.withOpacity(0.9),
                height: 1.45,
              ),
              softWrap: true,
            ),
          ],
          SizedBox(height: 10.h),
          Row(
            children: [
              Icon(Icons.access_time_rounded,
                  size: 12.sp, color: hintGreyColor),
              SizedBox(width: 4.w),
              Text(
                _formatDate(item.activityDate),
                style: AppTextStyle.normalRegular12.copyWith(
                  fontSize: 11.sp,
                  color: hintGreyColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.activityLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }

          final items = controller.linkActivityDetailsModel;

          if (items.isEmpty) {
            return NoDataFound(title: "No interactions yet".tr);
          }

          return SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: 20.h),
                  itemCount: items.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (_, i) => _activityCard(items[i]),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}