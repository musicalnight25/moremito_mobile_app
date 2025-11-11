import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';

import '../controller/notification_controller.dart';
import '../utils/static_decoration.dart';
import 'notification_details_screen.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  var controller = Get.put(NotificationController());

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getNotification();
    });
    super.initState();
  }

  Future<void> _onRefresh() async {
    await controller.getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: controller.notificationList.isEmpty &&
                    controller.isLoading.value == false
                ? ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      NoDataFound(title: "Notification"),
                    ],
                  )
                : ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      height20,
                      Text(
                        "Notifications",
                        style: AppTextStyle.normalExtraBold,
                      ),
                      customHeight(12),
                      Obx(
                        () => controller.notificationList.isEmpty
                            ? NoNotificationWidget()
                            : ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children:
                                    controller.notificationList.map((element) {
                                  var index = controller.notificationList
                                      .indexOf(element);
                                  bool isRead = (element.isRead == true ||
                                      element.isRead == 1);

                                  return GestureDetector(
                                    onTap: () {
                                      controller.notificationDetails.value =
                                          null;
                                      controller.notificationDetails.refresh();
                                      Get.to(() => NotificationDetailsScreen(
                                                notificationId:
                                                    element.id.toString(),
                                              ))!
                                          .then((value) {
                                        _onRefresh();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 10.sp),
                                      padding: EdgeInsets.all(12.sp),
                                      decoration: BoxDecoration(
                                        color: isRead
                                            ? Colors.white
                                            : primaryColor.withOpacity(
                                                0.15), // soft highlight for unread
                                        borderRadius:
                                            BorderRadius.circular(8.sp),
                                        border: Border.all(
                                          color: isRead
                                              ? Colors.grey.shade300
                                              : primaryColor.withOpacity(0.4),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Unread dot indicator
                                          if (!isRead)
                                            Container(
                                              height: 10.sp,
                                              width: 10.sp,
                                              margin: EdgeInsets.only(
                                                  top: 6.sp, right: 10.sp),
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                shape: BoxShape.circle,
                                              ),
                                            ),

                                          // Text section
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (element.createdOn != null)
                                                  Text(
                                                    CommonMethod
                                                        .formatTimeIsoDateString(
                                                            element.createdOn!
                                                                .toIso8601String()),
                                                    style: AppTextStyle
                                                        .normalRegular14
                                                        .copyWith(
                                                      color:
                                                          Colors.grey.shade600,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                customHeight(4),
                                                Text(
                                                  element.title ?? "",
                                                  style: AppTextStyle
                                                      .normalBold16
                                                      .copyWith(
                                                    fontWeight: isRead
                                                        ? FontWeight.w500
                                                        : FontWeight.w700,
                                                    color: Colors.black,
                                                    fontSize: 15.sp,
                                                  ),
                                                ),
                                                customHeight(4),
                                                Text(
                                                  element.body ?? "",
                                                  style: AppTextStyle
                                                      .normalRegular16
                                                      .copyWith(
                                                    color: Colors.black87,
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
                                }).toList(),
                              ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class NoNotificationWidget extends StatelessWidget {
  const NoNotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        customHeight(174),
        SvgPicture.asset(
          AppAsset.noNotification,
          height: 58.sp,
          width: 58.sp,
          fit: BoxFit.scaleDown,
        ),
        customHeight(39),
        Text(
          "No Notifications",
          style: AppTextStyle.normalBold16,
        ),
        customHeight(12),
        Text(
          "We’ll let you know when there will be something to update you.",
          style: AppTextStyle.normalRegular16
              .copyWith(fontWeight: FontWeight.w400, color: subTitleColor),
          textAlign: TextAlign.center,
        ),
        customHeight(20),
      ],
    );
  }
}
