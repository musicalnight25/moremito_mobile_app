import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import '../../controller/notification_controller.dart';
import '../../model/notification_model.dart';
import 'notification_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            color: primaryColor,
            onRefresh: controller.refreshNotifications,
            child: ListView(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                height20,

                /// Title
                Text(
                  "Notifications",
                  style: AppTextStyle.normalExtraBold.copyWith(
                    fontSize: 26.sp,
                    letterSpacing: 0.5,
                    color: primaryBlack, // replaced
                  ),
                ),

                height20,

                /// Empty view
                if (controller.notificationList.isEmpty &&
                    !controller.isLoading.value)
                  NoDataFound(),

                /// Notification list
                ...controller.notificationList.map(
                  (element) => _buildNotificationTile(element),
                ),

                /// Pagination Loader
                if (controller.isPaginationLoading.value)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.sp),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // Single Notification Tile
  // -----------------------------------------------------------
  Widget _buildNotificationTile(NotificationModel element) {
    bool isRead = (element.isRead == true || element.isRead == 1);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        controller.notificationDetails.value = null;
        controller.notificationDetails.refresh();

        Get.to(() => NotificationDetailsScreen(
                  notificationId: element.id.toString(),
                ))!
            .then((_) => controller.refreshNotifications());
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: 14.sp),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: primaryWhite, // replaced pure white
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(
            color: isRead ? borderGreyColor : primaryColor.withOpacity(0.4),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: bgPrimaryShadowColor.withOpacity(0.4),
              // soft green-ish shadow
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON CONTAINER
            Container(
              height: 48.sp,
              width: 48.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgPrimaryShadowColor, // soft brand color
              ),
              child: Icon(
                element.icon,
                color: primaryColor,
                size: 24.sp,
              ),
            ),

            width14,

            // TEXTS SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TIME
                  if (element.createdOn != null)
                    Text(
                      CommonMethod.formatTimeIsoDateString(
                        element.createdOn!.toIso8601String(),
                      ),
                      style: AppTextStyle.normalRegular14.copyWith(
                        color: hintGreyColor, // replaced
                        fontSize: 12.sp,
                      ),
                    ),

                  height06,

                  /// TITLE
                  Text(
                    element.title ?? "",
                    style: AppTextStyle.normalBold16.copyWith(
                      fontSize: 16.sp,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                      color: primaryBlack,
                    ),
                  ),

                  height06,

                  /// BODY
                  Text(
                    element.body ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.normalRegular14.copyWith(
                      fontSize: 14.sp,
                      color: lightBlackColor, // replaced
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            width10,

            /// UNREAD DOT
            if (!isRead)
              Container(
                height: 12.sp,
                width: 12.sp,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
