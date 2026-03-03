import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/flyers_controller.dart';
import '../../model/flyer_tracking_stats_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import 'shared_flyers_screen.dart';

class SharedLinksActivityScreen extends StatefulWidget {
  final int userId;
  final String userName; // display name e.g. "AAKASH KUMAR"
  final String? userHandle; // e.g. "aakashbth82351"

  const SharedLinksActivityScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.userHandle,
  });

  @override
  State<SharedLinksActivityScreen> createState() =>
      _SharedLinksActivityScreenState();
}

class _SharedLinksActivityScreenState extends State<SharedLinksActivityScreen> {
  final FlyersController controller = Get.isRegistered<FlyersController>()
      ? Get.find<FlyersController>()
      : Get.put(FlyersController());

  // KEY MAP — same as MySharedFlyersScreen (DO NOT CHANGE KEYS)
  final Map<String, String> _labelMap = {
    'Last72Hours': 'Last 72 Hours',
    'Last7Days': 'Last 7 Days',
    'Last2Weeks': 'Last 2 weeks',
    'Last3Weeks': 'Last 3 weeks',
    'Last4Weeks': 'Last 4 weeks',
    'Lifetime': 'Lifetime',
  };

  @override
  void initState() {
    super.initState();
    controller.getSharedLinksForUser(widget.userId);
  }

  int _getValue(FlyerTrackingStats? stats, String key, bool isActivity) {
    if (stats == null) return 0;
    if (isActivity) {
      final a = stats.activity;
      switch (key) {
        case 'Last72Hours':
          return a?.last72Hours ?? 0;
        case 'Last7Days':
          return a?.last7Days ?? 0;
        case 'Last2Weeks':
          return a?.last2Weeks ?? 0;
        case 'Last3Weeks':
          return a?.last3Weeks ?? 0;
        case 'Last4Weeks':
          return a?.last4Weeks ?? 0;
        case 'Lifetime':
          return a?.lifetime ?? 0;
      }
    } else {
      final r = stats.recipients;
      switch (key) {
        case 'Last72Hours':
          return r?.last72Hours ?? 0;
        case 'Last7Days':
          return r?.last7Days ?? 0;
        case 'Last2Weeks':
          return r?.last2Weeks ?? 0;
        case 'Last3Weeks':
          return r?.last3Weeks ?? 0;
        case 'Last4Weeks':
          return r?.last4Weeks ?? 0;
        case 'Lifetime':
          return r?.lifetime ?? 0;
      }
    }
    return 0;
  }

  Color _headerColor(String key) => primaryColor;

  @override
  Widget build(BuildContext context) {
    final handle = widget.userHandle != null ? ' (${widget.userHandle})' : '';

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "${widget.userName}'s Activity",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            // ── Title ──────────────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "${widget.userName}$handle\nShared Links Activity Tracking",
                style: AppTextStyle.normalBold18.copyWith(
                  color: primaryColor,
                  height: 1.3,
                ),
              ),
            ),
            height08,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                'View shared links activity report shared with you.\n'
                'View recipient activity and interaction details.',
                style: AppTextStyle.normalRegular13.copyWith(
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
            height12,
            // ── Section label ──────────────────────────────────────
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderGreyColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activity Tracking Summary (all links)',
                      style: AppTextStyle.normalBold14
                          .copyWith(color: primaryBlack),
                    ),
                    SizedBox(height: 4.sp),
                    Text(
                      'These cards show total recipients and total activity '
                      'across all shared links for each time range.',
                      style: AppTextStyle.normalRegular12
                          .copyWith(color: subTitleColor, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
            height12,
            // ── Grid (scrollable + pull-to-refresh) ───────────────
            Expanded(
              child: Obx(() {
                // ── Loading ──────────────────────────────────────
                if (controller.sharedUserStatsLoading.value) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.sp, vertical: 8.sp),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.sp,
                    mainAxisSpacing: 12.sp,
                    childAspectRatio: 1.12,
                    children: List.generate(6, (_) => _shimmerTile()),
                  );
                }

                final stats = controller.sharedUserStats.value;

                // ── Empty/error state with pull-to-refresh ────────
                if (stats == null) {
                  return RefreshIndicator(
                    color: primaryColor,
                    onRefresh: () =>
                        controller.getSharedLinksForUser(widget.userId),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: 300.sp,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.bar_chart_outlined,
                                  size: 56.sp, color: borderGreyColor),
                              height12,
                              Text(
                                'No activity data available.\nPull down to refresh.',
                                textAlign: TextAlign.center,
                                style: AppTextStyle.normalRegular14
                                    .copyWith(color: subTitleColor),
                              ),
                              height16,
                              GestureDetector(
                                onTap: () => controller
                                    .getSharedLinksForUser(widget.userId),
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.sp, vertical: 10.sp),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    'Retry',
                                    style: AppTextStyle.normalSemiBold13
                                        .copyWith(color: Colors.white),
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

                // ── Stats grid with pull-to-refresh ───────────────
                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () =>
                      controller.getSharedLinksForUser(widget.userId),
                  child: GridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
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
                        headerColor: _headerColor(entry.key),
                        onTap: () {
                          Get.to(
                            () => SharedFlyersScreen(
                              title: entry.value,
                              filterKey: entry.key,
                              viewUserId: widget.userId,
                              viewUserName: widget.userName,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ── Shimmer tile ────────────────────────────────────────────────────────
  Widget _shimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.sp),
          border: Border.all(color: borderGreyColor),
        ),
        child: Column(
          children: [
            Container(
              height: 38.sp,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12.sp)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                    2,
                    (_) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 10.sp, width: 60.sp, color: Colors.grey),
                        Container(
                            height: 14.sp, width: 20.sp, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Stat tile ────────────────────────────────────────────────────────────
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
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: headerColor.withOpacity(0.3), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: headerColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 8.sp),
              decoration: BoxDecoration(
                color: headerColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8.sp)),
              ),
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyle.normalBold14
                      .copyWith(color: Colors.white, fontSize: 13.sp),
                ),
              ),
            ),
            // Body
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _row('RECIPIENTS', recipients.toString(), headerColor),
                    _row('ACTIVITY', activity.toString(), headerColor),
                  ],
                ),
              ),
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
          style: AppTextStyle.normalRegular10.copyWith(
            color: subTitleColor,
            fontWeight: FontWeight.w500,
            fontSize: 9.sp,
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
