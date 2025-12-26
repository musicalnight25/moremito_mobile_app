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

  // ------------------------------------------------------------
  // LABEL MAP
  // ------------------------------------------------------------
  final Map<String, String> _labelMap = {
    "last72hours": "Last 72 Hours",
    "last7days": "Last 7 Days",
    "days8to14": "Last 2 Weeks",
    "days15to21": "Last 3 Weeks",
    "days22to28": "Last 4 Weeks",
    "lifetime": "Lifetime",
  };

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------
  int _recipients(FlyerTrackingStats? stats, String key) {
    final r = stats?.recipients;
    switch (key) {
      case "last72hours":
        return r?.last72Hours ?? 0;
      case "last7days":
        return r?.last7Days ?? 0;
      case "days8to14":
        return r?.days8To14 ?? 0;
      case "days15to21":
        return r?.days15To21 ?? 0;
      case "days22to28":
        return r?.days22To28 ?? 0;
      case "lifetime":
        return r?.lifetime ?? 0;
      default:
        return 0;
    }
  }

  int _activity(FlyerTrackingStats? stats, String key) {
    final a = stats?.activity;
    switch (key) {
      case "last72hours":
        return a?.last72Hours ?? 0;
      case "last7days":
        return a?.last7Days ?? 0;
      case "days8to14":
        return a?.days8To14 ?? 0;
      case "days15to21":
        return a?.days15To21 ?? 0;
      case "days22to28":
        return a?.days22To28 ?? 0;
      case "lifetime":
        return a?.lifetime ?? 0;
      default:
        return 0;
    }
  }

  // ------------------------------------------------------------
  // SHIMMER TILE
  // ------------------------------------------------------------
  Widget _shimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 120.sp,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(12.sp),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // STAT TILE
  // ------------------------------------------------------------
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
            // HEADER
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
                      style: AppTextStyle.normalSemiBold14
                          .copyWith(fontSize: 14.sp),
                    ),
                  ),
                  Icon(Icons.chevron_right, size: 18.sp),
                ],
              ),
            ),

            // BODY
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                child: Column(
                  children: [
                    _row("Recipients", recipients.toString()),
                    SizedBox(height: 8.sp),
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
        Text(label,
            style:
                AppTextStyle.normalRegular14.copyWith(color: Colors.black54)),
        Text(value, style: AppTextStyle.normalSemiBold16),
      ],
    );
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "My Shared Links & Tracking",
                style: AppTextStyle.normalBold20.copyWith(
                  color: primaryBlack,
                  height: 1.4,
                ),
              ),
            ),
            height04,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "View all the links you’ve shared and track how people interact with them. See recipient counts and activity details in one place.",
                style: AppTextStyle.normalRegular14.copyWith(
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                // LOADING STATE
                if (controller.statsLoading.value &&
                    controller.stats.value == null) {
                  return GridView.count(
                    padding: EdgeInsets.all(16.sp),
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.sp,
                    mainAxisSpacing: 12.sp,
                    children: List.generate(6, (_) => _shimmerTile()),
                  );
                }

                final stats = controller.stats.value;

                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async {
                    await controller.getFlyerTrackingStats();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.all(16.sp),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12.sp,
                      mainAxisSpacing: 12.sp,
                      children: _labelMap.keys.map((key) {
                        return _tile(
                          title: _labelMap[key]!,
                          recipients: _recipients(stats, key),
                          activity: _activity(stats, key),
                          onTap: () async {
                            controller.resetPagination();
                            await controller.getSharedFlyers(filterKey: key);
                            Get.to(() => SharedFlyersScreen(
                                  title: _labelMap[key]!,
                                  filterKey: key,
                                ));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
