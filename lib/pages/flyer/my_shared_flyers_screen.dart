// lib/screen/flyer/my_shared_flyers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/flyers_controller.dart';
import '../../model/flyer_models.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import '../../utils/common_method.dart';
import '../../utils/primary_text_button.dart';
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

  Widget _shimmerTile() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        height: 120.sp,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12.sp),
        ),
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
              color: Colors.black.withOpacity(.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.sp),
                  topRight: Radius.circular(12.sp),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: AppTextStyle.normalSemiBold14
                          .copyWith(color: Colors.black87, fontSize: 14.sp),
                    ),
                  ),
                  SizedBox(width: 8.sp),
                  InkWell(
                    onTap: () {
                      // small action: open filter's shared flyers
                      onTap();
                    },
                    child: Icon(
                      Icons.keyboard_arrow_right_sharp,
                      size: 18.sp,
                    ),
                  ),
                ],
              ),
            ),
            // body
            Expanded(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

  // map filter keys to friendly labels
  final Map<String, String> _labelMap = {
    "last72hours": "Last 72 Hours",
    "last7days": "Last 7 Days",
    "days8to14": "8-14 Days Ago",
    "days15to21": "15-21 Days Ago",
    "days22to28": "22-28 Days Ago",
    "lifetime": "Lifetime",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryWhite,
      appBar: CommonAppBar(title: "My Shared Flyers", visibleBackButton: true),
      body: Obx(() {
        if (controller.statsLoading.value && controller.stats.value == null) {
          // show shimmer grid
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Is there something in particular putting you off coming back more often? Select the main reason that keeps you away.",
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
                SizedBox(height: 16.sp),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.sp,
                  mainAxisSpacing: 12.sp,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: (1),
                  children: List.generate(6, (_) => _shimmerTile()),
                ),
              ],
            ),
          );
        }

        final FlyerTrackingStats stats = controller.stats.value ??
            FlyerTrackingStats(
              last72HoursRecipients: 0,
              last72HoursActivity: 0,
              last7DaysRecipients: 0,
              last7DaysActivity: 0,
              days8to14Recipients: 0,
              days8to14Activity: 0,
              days15to21Recipients: 0,
              days15to21Activity: 0,
              days22to28Recipients: 0,
              days22to28Activity: 0,
              lifetimeRecipients: 0,
              lifetimeActivity: 0,
            );

        // function that returns values by key
        Map<String, Map<String, int>> values = {
          "last72hours": {
            "recipients": stats.last72HoursRecipients,
            "activity": stats.last72HoursActivity,
          },
          "last7days": {
            "recipients": stats.last7DaysRecipients,
            "activity": stats.last7DaysActivity,
          },
          "days8to14": {
            "recipients": stats.days8to14Recipients,
            "activity": stats.days8to14Activity,
          },
          "days15to21": {
            "recipients": stats.days15to21Recipients,
            "activity": stats.days15to21Activity,
          },
          "days22to28": {
            "recipients": stats.days22to28Recipients,
            "activity": stats.days22to28Activity,
          },
          "lifetime": {
            "recipients": stats.lifetimeRecipients,
            "activity": stats.lifetimeActivity,
          },
        };

        return RefreshIndicator(
          color: primaryColor,
          backgroundColor: Colors.white,
          onRefresh: () async {
            controller.getFlyerTrackingStats();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Is there something in particular putting you off coming back more often? Select the main reason that keeps you away.",
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
                SizedBox(height: 16.sp),
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.sp,
                  mainAxisSpacing: 12.sp,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: (1),
                  children: [
                    _tile(
                      title: _labelMap["last72hours"]!,
                      recipients: values["last72hours"]!["recipients"]!,
                      activity: values["last72hours"]!["activity"]!,
                      onTap: () async {
                        // navigate to shared flyers list for this filter
                        controller.resetPagination();
                        await controller.getSharedFlyers(
                            filterKey: "last72hours");
                        Get.to(() => SharedFlyersScreen(
                              title: _labelMap["last72hours"]!,
                              filterKey: "last72hours",
                            ));
                      },
                    ),
                    _tile(
                      title: _labelMap["last7days"]!,
                      recipients: values["last7days"]!["recipients"]!,
                      activity: values["last7days"]!["activity"]!,
                      onTap: () async {
                        controller.resetPagination();
                        await controller.getSharedFlyers(
                            filterKey: "last7days");
                        Get.to(() => SharedFlyersScreen(
                              title: _labelMap["last7days"]!,
                              filterKey: "last7days",
                            ));
                      },
                    ),
                    _tile(
                      title: _labelMap["days8to14"]!,
                      recipients: values["days8to14"]!["recipients"]!,
                      activity: values["days8to14"]!["activity"]!,
                      onTap: () async {
                        controller.resetPagination();
                        await controller.getSharedFlyers(
                            filterKey: "days8to14");
                        Get.to(() => SharedFlyersScreen(
                              title: _labelMap["days8to14"]!,
                              filterKey: "days8to14",
                            ));
                      },
                    ),
                    _tile(
                      title: _labelMap["days15to21"]!,
                      recipients: values["days15to21"]!["recipients"]!,
                      activity: values["days15to21"]!["activity"]!,
                      onTap: () async {
                        controller.resetPagination();
                        await controller.getSharedFlyers(
                            filterKey: "days15to21");
                        Get.to(() => SharedFlyersScreen(
                              title: _labelMap["days15to21"]!,
                              filterKey: "days15to21",
                            ));
                      },
                    ),
                    _tile(
                      title: _labelMap["days22to28"]!,
                      recipients: values["days22to28"]!["recipients"]!,
                      activity: values["days22to28"]!["activity"]!,
                      onTap: () async {
                        controller.resetPagination();
                        await controller.getSharedFlyers(
                            filterKey: "days22to28");
                        Get.to(() => SharedFlyersScreen(
                              title: _labelMap["days22to28"]!,
                              filterKey: "days22to28",
                            ));
                      },
                    ),
                    _tile(
                      title: _labelMap["lifetime"]!,
                      recipients: values["lifetime"]!["recipients"]!,
                      activity: values["lifetime"]!["activity"]!,
                      onTap: () async {
                        controller.resetPagination();
                        await controller.getSharedFlyers(filterKey: "lifetime");
                        Get.to(() => SharedFlyersScreen(
                              title: _labelMap["lifetime"]!,
                              filterKey: "lifetime",
                            ));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
