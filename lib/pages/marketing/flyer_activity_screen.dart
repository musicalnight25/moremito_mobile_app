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
  // UI HELPERS (Strictly using App Colors)
  // ------------------------------------------------------------

  /// Returns a record containing (Display Title, Base Color, Icon Data)
  ({String title, Color color, IconData icon}) _getActivityStyle(String? type) {
    switch (type) {
      // --- Primary Interactions (Blue) ---
      case "LinkOpen":
        return (title: "Link Opened", color: primaryColor, icon: Icons.link);

      case "FormFilled":
      case "ReferralProgramCheckbox":
      case "WeeklyCallsCheckbox":
      case "HealthSurvey":
        return (
          title: "Form / Survey",
          color: primaryColor,
          icon: Icons.assignment_turned_in_rounded
        );

      case "product_name":
        return (
          title: "Product Interest",
          color: primaryColor,
          icon: Icons.shopping_bag_rounded
        );

      // --- Media (Red & Orange) ---
      case "VideoPlayed":
      case "Video Played":
      case "VideoPlay":
      case "video_src":
        return (
          title: "Video Watched",
          color: redColor, // Using app red
          icon: Icons.play_circle_fill_rounded
        );

      case "AudioPlayed":
      case "Audio Played":
        return (
          title: "Audio Played",
          color: orangeColor, // Using app orange for distinction
          icon: Icons.audiotrack_rounded
        );

      // --- Success / Files (Green) ---
      case "FileViewed":
      case "File Viewed":
        return (
          title: "File Viewed",
          color: greenColor, // Using app green
          icon: Icons.visibility_rounded
        );

      case "FileDownloaded":
      case "File Downloaded":
        return (
          title: "File Downloaded",
          color: greenColor,
          icon: Icons.download_rounded
        );

      // --- Communication (Orange) ---
      case "MessageSent":
      case "Message Sent":
        return (
          title: "Message Sent",
          color: orangeColor,
          icon: Icons.send_rounded
        );

      // --- Passive Clicks (Grey) ---
      case "button_click":
        return (
          title: "Button Clicked",
          color: lightBlackColor,
          icon: Icons.touch_app_rounded
        );

      case "image_click":
        return (
          title: "Image Clicked",
          color: hintGreyColor,
          icon: Icons.image_rounded
        );

      default:
        return (
          title: type ?? "Interaction",
          color: primaryColor,
          icon: Icons.notifications_active_rounded
        );
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "";
    return DateFormat('MMM dd, hh:mm a').format(date.toLocal());
  }

  // ------------------------------------------------------------
  // WIDGETS
  // ------------------------------------------------------------

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
              color: primaryBlack, // Using App Black
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Row(
            children: [
              // Subtle Icon
              Icon(
                Icons.person_outline_rounded,
                size: 16.sp,
                color: subTitleColor.withOpacity(0.7),
              ),
              SizedBox(width: 6.w),

              // Label and Value combined with hierarchy
              Expanded(
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style:
                        AppTextStyle.normalRegular14.copyWith(fontSize: 13.sp),
                    children: [
                      TextSpan(
                        text: "Activity by: ",
                        style: TextStyle(color: subTitleColor.withOpacity(0.6)),
                      ),
                      TextSpan(
                        text: widget.sharedTo,
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight:
                              FontWeight.w600, // Make the name stand out
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _activityCard(LinkActivityDetailsModel item) {
    final style = _getActivityStyle(item.activityType);
    final description = item.interactionValue ?? item.activityDescription ?? "";
    final hasDescription = description.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h, left: 16.w, right: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(12.r),
        // Using your specific borderGreyColor
        border: Border.all(color: borderGreyColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. ICON CONTAINER
          Container(
            height: 40.w,
            width: 40.w,
            decoration: BoxDecoration(
              // Using opacity for a soft background matching the icon color
              color: style.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(style.icon, color: style.color, size: 20.sp),
          ),

          SizedBox(width: 14.w),

          // 2. CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Date Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        style.title,
                        style: AppTextStyle.normalSemiBold14.copyWith(
                          color: lightBlackColor, // App Black
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      _formatDate(item.activityDate),
                      style: AppTextStyle.normalRegular12.copyWith(
                        color: hintGreyColor, // App Hint Grey
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),

                // Description (if valid)
                if (hasDescription) ...[
                  SizedBox(height: 6.h),
                  Text(
                    description,
                    style: AppTextStyle.normalRegular14.copyWith(
                      color: subTitleColor, // App Subtitle Color
                      fontSize: 13.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
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
      appBar: const CommonAppBar(
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.activityLoading.value) {
            return const Center(
                child: CircularProgressIndicator(color: primaryColor));
          }

          final List<LinkActivityDetailsModel> items =
              controller.linkActivityDetailsModel;

          if (items.isEmpty) {
            return const NoDataFound(title: "No interactions yet");
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
                  itemBuilder: (_, index) {
                    return _activityCard(items[index]);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
