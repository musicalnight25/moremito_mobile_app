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
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Obx(
          () => controller.notificationList.isEmpty &&
                  controller.isLoading.value == false
              ? NoDataFound(
                  title: "Notification",
                )
              : ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.sp),
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
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children:
                                  controller.notificationList.map((element) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.notificationDetails.value = null;
                                    controller.notificationDetails.refresh();
                                    Get.to(() => NotificationDetailsScreen(
                                          notificationId: element.id.toString(),
                                        ));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 12.sp),
                                    child: ShadowContainerWidget(
                                        padding: 0,
                                        radius: 8.sp,
                                        blurRadius: 0,
                                        borderWidth: 1.sp,
                                        widget: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.sp,
                                              vertical: 12.sp),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              if (element.icon != null)
                                                Icon(
                                                  element.icon,
                                                  color: primaryColor,
                                                  size: 32,
                                                ),
                                              // Image.asset(
                                              //   element.image!,
                                              //   height: 32.sp,
                                              //   width: 32.sp,
                                              // ),
                                              customWidth(12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if (element.createdOn !=
                                                            null)
                                                          Text(
                                                            CommonMethod
                                                                .formatTimeIsoDateString(element
                                                                    .createdOn!
                                                                    .toIso8601String()),
                                                            style: AppTextStyle
                                                                .normalRegular12
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    color: Colors
                                                                        .grey),
                                                            maxLines: 1,
                                                          )
                                                      ],
                                                    ),
                                                    customHeight(6),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            element.title ?? "",
                                                            style: AppTextStyle
                                                                .normalBold16
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    customHeight(4),
                                                    Text(
                                                      element.body ?? "",
                                                      style: AppTextStyle
                                                          .normalRegular14
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black54),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        )),
                                  ),
                                );
                              }).toList(),
                            ),
                    ),
                  ],
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
