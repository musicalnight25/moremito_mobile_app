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
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialLoad(null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: const CommonAppBar(),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            color: primaryColor,
            onRefresh: () => controller.refreshNotifications(null),
            child: ListView(
              controller: controller.scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              children: [
                height20,
                Text(
                  "Notifications",
                  style: AppTextStyle.normalExtraBold.copyWith(
                    fontSize: 26.sp,
                    color: primaryBlack,
                  ),
                ),
                height20,

                /// FILTERS
                _filterRow(),
                height10,

                /// LOADING
                if (controller.isLoading.value)
                  ...List.generate(
                    6,
                    (_) => const NotificationShimmerCard(),
                  ),

                /// EMPTY STATE
                if (!controller.isLoading.value &&
                    controller.notificationList.isEmpty)
                  const NoDataFound(),

                /// LIST
                ...controller.notificationList.map(_buildTile),

                /// PAGINATION LOADING
                if (controller.isPaginationLoading.value)
                  ...List.generate(
                    2,
                    (_) => const NotificationShimmerCard(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// ───────────────── FILTER ROW ─────────────────
  Widget _filterRow() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            // ALL — neutral notifications
            _filterChip(
              0,
              "All",
              CupertinoIcons.bell,
            ),
            width10,

            // SYSTEM — autoship, rank, billing, account events
            _filterChip(
              1,
              "System",
              CupertinoIcons.shield,
            ),
            width10,

            // MARKETING — offers, pricing, promotions
            _filterChip(
              2,
              "Marketing",
              CupertinoIcons.tag,
            ),
            width10,

            // ANNOUNCEMENT — broadcasts & updates
            _filterChip(
              3,
              "Announcement",
              CupertinoIcons.speaker_3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(int index, String text, IconData icon) {
    final bool selected = controller.selectedFilter.value == index;

    return GestureDetector(
      onTap: () => controller.changeFilter(index: index, context: Get.context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 14.sp : 10.sp,
          vertical: 8.sp,
        ),
        decoration: BoxDecoration(
          color: selected ? primaryColor : primaryColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: selected ? Colors.white : primaryColor,
            ),
            if (selected) ...[
              width06,
              Text(
                text,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ───────────────── NOTIFICATION TILE ─────────────────

  Widget _buildTile(NotificationModel element) {
    final bool isRead = element.isRead == true || element.isRead == 1;

    return InkWell(
      onTap: () async {
        await Get.to(
          () => NotificationDetailsScreen(
            notificationId: "${element.id}",
          ),
        );
        controller.refreshNotifications(null);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
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
              radius: 24.sp,
              backgroundColor: bgPrimaryShadowColor,
              child: Icon(
                element.icon,
                color: primaryColor,
              ),
            ),
            width14,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (element.createdOn != null)
                    Text(
                      CommonMethod.formatTimeIsoDateString(
                        element.createdOn!.toIso8601String(),
                      ),
                      style: AppTextStyle.normalRegular14.copyWith(
                        fontSize: 12.sp,
                        color: hintGreyColor,
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
                      fontSize: 14.sp,
                      color: lightBlackColor,
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
