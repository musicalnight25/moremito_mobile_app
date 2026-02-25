import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/flyers_controller.dart';
import '../../model/flyer_tracking_stats_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import 'shared_flyers_screen.dart';
import 'shared_reports_users_screen.dart';

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
                "My Mito Info Shared Links Activity Tracking",
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
                "Track and monitor all your shared links activity.\nView recipient activity and interaction details.",
                style: AppTextStyle.normalRegular14.copyWith(
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
            ),
            height16,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: _buildViewActivityDropdown(),
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

  Widget _buildViewActivityDropdown() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<int>(
        customButton: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 11.sp),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border:
                Border.all(color: primaryColor.withOpacity(0.8), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, color: primaryColor, size: 20.sp),
              width10,
              Text(
                "View Shared Activity",
                style: AppTextStyle.normalBold14.copyWith(
                  color: primaryColor,
                  letterSpacing: 0.1,
                ),
              ),
              const Spacer(),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: primaryColor.withOpacity(0.7), size: 24.sp),
            ],
          ),
        ),
        items: [
          DropdownMenuItem<int>(
            value: 1,
            child: Row(
              children: [
                const Icon(Icons.people_outline, size: 18),
                width08,
                Expanded(
                  child: Text(
                    "See who my activity is shared with",
                    style: AppTextStyle.normalRegular14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem<int>(
            value: 2,
            child: Row(
              children: [
                const Icon(Icons.mark_as_unread_outlined, size: 18),
                width08,
                Expanded(
                  child: Text(
                    "See activities of others shared with me",
                    style: AppTextStyle.normalRegular14,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
        onChanged: (value) {
          if (value == 1) {
            Get.to(() => const SharedReportsUsersScreen());
          } else if (value == 2) {
            CommonMethod.getXSnackBar(
                "Info",
                "Activities of others shared with you will appear here.",
                primaryColor);
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 0.9.sw,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: Colors.white,
          ),
          offset: const Offset(0, -4),
          elevation: 8,
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [45.sp, 45.sp],
          padding: EdgeInsets.symmetric(horizontal: 16.sp),
        ),
      ),
    );
  }

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
                                  height: 10.sp,
                                  width: 60.sp,
                                  color: Colors.grey),
                              Container(
                                  height: 14.sp,
                                  width: 20.sp,
                                  color: Colors.grey),
                            ],
                          )),
                ),
              ),
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
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(10.sp),
          border: Border.all(color: headerColor.withOpacity(0.3), width: 1.1),
          boxShadow: [
            BoxShadow(
              color: headerColor.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
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
                    _row("RECIPIENTS", recipients.toString(), headerColor),
                    _row("ACTIVITY", activity.toString(), headerColor),
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
