import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/model/dashboard_model.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../auth/start_survey_screen.dart';
import 'announcement_detail_screen.dart';
import 'call_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homeController = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homeController.getDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async => homeController.getDashboard(),
          child: Obx(() {
            DashboardModel? user = homeController.dashboardModel.value;

            if (user == null && !homeController.isLoading.value) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 400,
                  child: Center(child: NoDataFound(title: "Dashboard")),
                ),
              );
            }

            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _betaDisclaimer(),
                  height16,
                  _welcomeCard(user),
                  height20,
                  _callAnnouncementCard(user),
                  height20,
                  _announcementCard(user),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _welcomeCard(DashboardModel user) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(.50),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome",
            style: AppTextStyle.normalSemiBold20.copyWith(
              color: primaryBlack,
            ),
          ),
          height08,
          Text(
            "${user.name} (${user.userName})",
            style: AppTextStyle.normalSemiBold18.copyWith(
              color: primaryColor,
            ),
          ),
          height12,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 6.sp),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Text(
              user.currentRank ?? "-",
              style: AppTextStyle.normalSemiBold14.copyWith(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _callAnnouncementCard(DashboardModel user) {
    CallDetails? call = user.callDetails;
    if (call == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Call Announcement",
          style: AppTextStyle.normalSemiBold20.copyWith(color: primaryBlack),
        ),
        height12,
        GestureDetector(
          onTap: () {
            Get.to(() => CallDetailScreen(
                  id: 1,
                  templateName: call.emailTemplate ?? "",
                ));
          },
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: primaryWhite,
              borderRadius: BorderRadius.circular(16.sp),
              border: Border.all(color: borderGreyColor),
              boxShadow: [
                BoxShadow(
                  color: bgPrimaryShadowColor.withOpacity(.45),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ICON + TITLE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.campaign, size: 28.sp, color: redColor),
                    width12,
                    Expanded(
                      child: Text(
                        call.title ?? "-",
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                    ),
                  ],
                ),

                height10,

                Text(
                  "Subject: ${call.subject ?? '-'}",
                  style: AppTextStyle.normalRegular14.copyWith(
                    color: lightBlackColor,
                  ),
                ),

                height08,

                Text(
                  "Click to View",
                  style: AppTextStyle.normalSemiBold14.copyWith(
                    color: primaryColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _announcementCard(DashboardModel user) {
    List<AnnouncementDetails> list = user.announcementDetails ?? [];
    if (list.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Announcements",
          style: AppTextStyle.normalSemiBold20.copyWith(color: primaryBlack),
        ),
        height12,
        ...list.map((item) => _announcementItem(item)).toList(),
      ],
    );
  }

  Widget _announcementItem(AnnouncementDetails item) {
    return GestureDetector(
      onTap: () => Get.to(() => AnnouncementDetailScreen(id: item.id!)),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: borderGreyColor),
          boxShadow: [
            BoxShadow(
              color: bgPrimaryShadowColor.withOpacity(.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.notifications_active, size: 28.sp, color: orangeColor),
            width12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.announcementName ?? "",
                    style: AppTextStyle.normalSemiBold16.copyWith(
                      color: primaryBlack,
                    ),
                  ),
                  height06,
                  Text(
                    "Click to View",
                    style: AppTextStyle.normalSemiBold14.copyWith(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _betaDisclaimer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        // Solid professional shadow using your theme shadow color
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.sp),
        child: Stack(
          children: [
            // Background Decoration: Soft Gradient Blobs
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: paleYellowColor.withOpacity(0.5),
              ),
            ),

            // Layout with Accent Bar
            IntrinsicHeight(
              child: Row(
                children: [
                  // Solid Primary Accent Bar
                  Container(
                    width: 6.w,
                    decoration: const BoxDecoration(
                      color: primaryColor, // Your solid theme primary color
                    ),
                  ),

                  // Content Section
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        // Using your paleYellowColor as a soft glass effect
                        color: paleYellowColor.withOpacity(0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Badge Style Icon
                              Container(
                                padding: EdgeInsets.all(6.sp),
                                decoration: BoxDecoration(
                                    color: primaryWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.2)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.1),
                                        blurRadius: 4,
                                      )
                                    ]),
                                child: Icon(Icons.auto_awesome,
                                    color: primaryColor, size: 14.sp),
                              ),
                              width10,
                              Text(
                                "BETA VERSION",
                                style: AppTextStyle.normalBold12.copyWith(
                                  color: primaryColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const Spacer(),
                              // Optional Close or Tag
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "v1.0.0",
                                  style: AppTextStyle.normalBold10
                                      .copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                          height10,
                          Text(
                            "This app is currently in Beta, which means some features may be incomplete, under testing, or subject to change. You may experience occasional issues or variations. We appreciate your feedback as we work to improve the app.",
                            style: AppTextStyle.normalRegular13.copyWith(
                              color: lightBlackColor,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
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
