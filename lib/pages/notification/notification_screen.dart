import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/notification/widget/notification_shimmer_card.dart';
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
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialLoad();
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
            onRefresh: controller.refreshNotifications,
            color: primaryColor,
            child: ListView(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                height20,
                Text(
                  "Notifications",
                  style: AppTextStyle.normalExtraBold
                      .copyWith(fontSize: 26.sp, color: primaryBlack),
                ),

                height20,

                _filterRow(), // <-- add filter row

                height10,

                if (controller.isLoading.value)
                  ...List.generate(6, (_) => const NotificationShimmerCard()),

                if (!controller.isLoading.value &&
                    controller.notificationList.isEmpty)
                  NoDataFound(),

                ...controller.notificationList.map(_buildTile),

                if (controller.isPaginationLoading.value)
                  ...List.generate(2, (_) => const NotificationShimmerCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _filterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            _filterChip(0, "All", CupertinoIcons.bell_fill),
            width10,
            _filterChip(1, "System", CupertinoIcons.gear_alt_fill),
            width10,
            _filterChip(2, "Marketing", CupertinoIcons.gift_fill),
            width10,
            _filterChip(3, "Announcement", Icons.campaign_rounded),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(int index, String text, IconData icon) {
    final selected = controller.selectedFilter.value == index;

    return GestureDetector(
      onTap: () => controller.changeFilter(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: selected ? primaryColor : primaryColor.withOpacity(.15),
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 16.sp, color: selected ? Colors.white : primaryColor),
            width06,
            Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: selected ? Colors.white : primaryColor,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTile(NotificationModel element) {
    final isRead = element.isRead == true || element.isRead == 1;

    return InkWell(
      onTap: () async {
        await Get.to(
          () => NotificationDetailsScreen(notificationId: "${element.id}"),
        );
        controller.refreshNotifications();
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: 14.sp),
        padding: EdgeInsets.all(14.sp),
        decoration: BoxDecoration(
          color: isRead ? primaryWhite : primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(
            color: isRead ? borderGreyColor : primaryColor.withOpacity(0.4),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: bgPrimaryShadowColor,
              radius: 24.sp,
              child: Icon(element.icon, color: primaryColor),
            ),
            width14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (element.createdOn != null)
                    Text(
                      CommonMethod.formatTimeIsoDateString(
                          element.createdOn!.toIso8601String()),
                      style: AppTextStyle.normalRegular14.copyWith(
                        color: hintGreyColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  height06,
                  Text(
                    element.title ?? "",
                    style: AppTextStyle.normalBold16.copyWith(
                      fontSize: 16.sp,
                      fontWeight: isRead ? FontWeight.w500 : FontWeight.w700,
                      color: primaryBlack,
                    ),
                  ),
                  height06,
                  Text(
                    element.body ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.normalRegular14.copyWith(
                      color: lightBlackColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
