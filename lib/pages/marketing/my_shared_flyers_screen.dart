import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/flyers_controller.dart';
import '../../model/flyer_tracking_stats_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import 'shared_flyers_screen.dart';
import 'shared_reports_users_screen.dart';
import 'shared_reports_with_me_screen.dart';
import 'share_your_activity_screen.dart';

class MySharedFlyersScreen extends StatefulWidget {
  const MySharedFlyersScreen({super.key});

  @override
  State<MySharedFlyersScreen> createState() => _MySharedFlyersScreenState();
}

class _MySharedFlyersScreenState extends State<MySharedFlyersScreen> {
  final FlyersController controller = Get.isRegistered<FlyersController>()
      ? Get.find<FlyersController>()
      : Get.put(FlyersController());

  @override
  void initState() {
    super.initState();
    controller.getFlyerTrackingStats();
  }

  // KEY MAP (DO NOT CHANGE KEYS)
  final Map<String, String> _labelMap = {
    "Last72Hours": "Last 72 Hours",
    "Last7Days": "Last 7 Days",
    "Last2Weeks": "Last 2 weeks",
    "Last3Weeks": "Last 3 weeks",
    "Last4Weeks": "Last 4 weeks",
    "Lifetime": "Lifetime",
  };

  // ---------------- FIXED DATA ACCESS ----------------
  int _getValue(FlyerTrackingStats? stats, String key, bool isActivity) {
    if (stats == null) return 0;

    if (isActivity) {
      final a = stats.activity;
      switch (key) {
        case "Last72Hours":
          return a?.last72Hours ?? 0;
        case "Last7Days":
          return a?.last7Days ?? 0;
        case "Last2Weeks":
          return a?.last2Weeks ?? 0;
        case "Last3Weeks":
          return a?.last3Weeks ?? 0;
        case "Last4Weeks":
          return a?.last4Weeks ?? 0;
        case "Lifetime":
          return a?.lifetime ?? 0;
      }
    } else {
      final r = stats.recipients;
      switch (key) {
        case "Last72Hours":
          return r?.last72Hours ?? 0;
        case "Last7Days":
          return r?.last7Days ?? 0;
        case "Last2Weeks":
          return r?.last2Weeks ?? 0;
        case "Last3Weeks":
          return r?.last3Weeks ?? 0;
        case "Last4Weeks":
          return r?.last4Weeks ?? 0;
        case "Lifetime":
          return r?.lifetime ?? 0;
      }
    }
    return 0;
  }

  Color _getHeaderColor(String key) {
    return primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "My Mito Info Shared Links Activity Tracking".tr,
                style: AppTextStyle.normalBold18.copyWith(
                  color: primaryColor,
                  height: 1.2,
                ),
              ),
            ),
            height08,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "Track and monitor all your shared links activity.\nView recipient activity and interaction details."
                    .tr,
                style: AppTextStyle.normalRegular14.copyWith(
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
            height16,
            // ── Action buttons (Horizontal layout for space saving) ─────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSmallActionCard(
                      title: "Share\nActivity".tr,
                      icon: Icons.ios_share_rounded,
                      isPrimary: true,
                      onTap: () =>
                          Get.to(() => const ShareYourActivityScreen()),
                    ),
                  ),
                  SizedBox(width: 10.sp),
                  Expanded(
                    child: _buildSmallActionCard(
                      title: "Shared\nby Me".tr,
                      icon: Icons.people_alt_outlined,
                      isPrimary: false,
                      onTap: () =>
                          Get.to(() => const SharedReportsUsersScreen()),
                    ),
                  ),
                  SizedBox(width: 10.sp),
                  Expanded(
                    child: _buildSmallActionCard(
                      title: "Shared\nwith Me".tr,
                      icon: Icons.mark_as_unread_outlined,
                      isPrimary: false,
                      onTap: () =>
                          Get.to(() => const SharedReportsWithMeScreen()),
                    ),
                  ),
                ],
              ),
            ),
            height10,
            Expanded(
              child: Obx(() {
                if (controller.statsLoading.value) {
                  return GridView.count(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.sp,
                    mainAxisSpacing: 12.sp,
                    childAspectRatio: 1.12,
                    children: List.generate(6, (_) => _shimmerTile()),
                  );
                }

                final stats = controller.stats.value;

                return GridView.count(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.sp,
                  mainAxisSpacing: 8.sp,
                  childAspectRatio: 1.25,
                  children: _labelMap.entries.map((entry) {
                    return _tile(
                      title: entry.value,
                      recipients: _getValue(stats, entry.key, false),
                      activity: _getValue(stats, entry.key, true),
                      headerColor: _getHeaderColor(entry.key),
                      onTap: () {
                        Get.to(() => SharedFlyersScreen(
                              title: entry.value,
                              filterKey: entry.key,
                            ));
                      },
                    );
                  }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallActionCard({
    required String title,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.sp, horizontal: 4.sp),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
          border: isPrimary
              ? null
              : Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : Colors.black87,
              size: 22.sp,
            ),
            SizedBox(height: 6.sp),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.normalBold12.copyWith(
                color: isPrimary ? Colors.white : Colors.black87,
                height: 1.2,
                fontSize: 11.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _shimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 14.sp,
                width: 80.sp,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r))),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 10.sp, width: 60.sp, color: Colors.white),
                    Container(
                        height: 14.sp,
                        width: 20.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r))),
                  ],
                ),
                SizedBox(height: 8.sp),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(height: 10.sp, width: 60.sp, color: Colors.white),
                    Container(
                        height: 14.sp,
                        width: 20.sp,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r))),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required String title,
    required int recipients,
    required int activity,
    required Color headerColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade200, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppTextStyle.normalBold14.copyWith(
                color: Colors.black87,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Column(
              children: [
                _row("Recipients", recipients.toString(), Colors.black87),
                SizedBox(height: 6.sp),
                _row("Activity", activity.toString(), primaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.normalRegular12.copyWith(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.normalBold18.copyWith(
            color: color,
            height: 1.0,
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
