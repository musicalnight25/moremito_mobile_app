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
import '../../utils/common_method.dart';
import 'shared_flyers_screen.dart';

class MySharedFlyersScreen extends StatefulWidget {
  const MySharedFlyersScreen({super.key});

  @override
  State<MySharedFlyersScreen> createState() => _MySharedFlyersScreenState();
}

class _MySharedFlyersScreenState extends State<MySharedFlyersScreen> {
  final FlyersController controller = Get.put(FlyersController());

  @override
  void initState() {
    super.initState();
    controller.getFlyerTrackingStats();
  }

  // KEY MAP (DO NOT CHANGE KEYS)
  final Map<String, String> _labelMap = {
    "Last72Hours": "Last 72 Hours",
    "Last7Days": "Last 7 Days",
    "Last2Weeks": "Last 2 Weeks",
    "Last3Weeks": "Last 3 Weeks",
    "Last4Weeks": "Last 4 Weeks",
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
                "My Mito Info Shared Links Tracking",
                style: AppTextStyle.normalBold20,
              ),
            ),
            height04,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "Track and monitor all your shared links.",
                style: AppTextStyle.normalRegular14,
              ),
            ),
            Expanded(
              child: Obx(() {
                if (controller.statsLoading.value) {
                  return GridView.count(
                    padding: EdgeInsets.all(16.sp),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.sp,
                    mainAxisSpacing: 12.sp,
                    children: List.generate(6, (_) => _shimmerTile()),
                  );
                }

                final stats = controller.stats.value;

                return GridView.count(
                  padding: EdgeInsets.all(16.sp),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.sp,
                  mainAxisSpacing: 12.sp,
                  children: _labelMap.entries.map((entry) {
                    return _tile(
                      title: entry.value,
                      recipients: _getValue(stats, entry.key, false),
                      activity: _getValue(stats, entry.key, true),
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

  Widget _shimmerTile() {
    return Container(
      height: 120.sp,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
      ),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.sp),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(12.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                          height: 12, width: 120, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child:
                          Container(height: 12, width: 80, color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tile({
    required String title,
    required int recipients,
    required int activity,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120.sp,
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(12.sp),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12.sp),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyle.normalSemiBold14,
                    ),
                  ),
                  const Icon(Icons.chevron_right, size: 18),
                ],
              ),
            ),

            // Body
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                child: Column(
                  children: [
                    _row("Recipients", recipients.toString()),
                    const SizedBox(height: 8),
                    _row("Activity", activity.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.normalRegular14.copyWith(
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.normalSemiBold16,
        ),
      ],
    );
  }
}
