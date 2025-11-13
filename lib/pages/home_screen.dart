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

import 'announcement_detail_screen.dart';
import 'call_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async => await homeController.getDashboard(),
          child: Obx(() {
            DashboardModel? user = homeController.dashboardModel.value;

            if (user == null && homeController.isLoading.isFalse) {
              return const SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 400,
                  child: Center(child: NoDataFound(title: "Dashboard")),
                ),
              );
            }

            if (user == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _profileCard(user),
                  customHeight(20),
                  _callDetailsCard(user),
                  customHeight(20),
                  _announcementCard(user),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // ===================== PROFILE CARD =====================
  Widget _profileCard(DashboardModel user) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "Welcome",
        style: AppTextStyle.normalBold20.copyWith(
          fontSize: 22.sp,
          color: Colors.black,
        ),
      ),
      customHeight(6),

      Text(
        "${user.name} (${user.userName})",
        style: AppTextStyle.normalBold20.copyWith(color: Color(0xFF4CAF50)),
      ),

      customHeight(10),

      Container(
        padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 6.sp),
        decoration: BoxDecoration(
          color: Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Text(
          "${user.currentRank} ${user.highestRank}",
          style: AppTextStyle.normalSemiBold16.copyWith(
            color: Color(0xFF4CAF50),
          ),
        ),
      ),
    ],
  );

  // ===================== CALL DETAILS CARD =====================
  Widget _callDetailsCard(DashboardModel user) {
    CallDetails? call = user.callDetails;
    if (call == null) return SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Call Announcement",
          style: AppTextStyle.normalBold20.copyWith(
            fontSize: 22.sp,
            color: Colors.black,
          ),
        ),
        customHeight(12),

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
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.sp),
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.campaign, size: 30, color: Colors.redAccent),
                    customWidth(10),
                    Expanded(
                      child: Text(
                        call.title ?? "-",
                        style: AppTextStyle.normalBold16,
                      ),
                    ),
                  ],
                ),

                customHeight(10),

                Text(
                  "Subject: ${call.subject ?? '-'}",
                  style: AppTextStyle.normalRegular14.copyWith(color: Colors.black87),
                ),

                AbsorbPointer(
                  absorbing: true,
                  child: Text(
                    "Click to View",
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===================== ANNOUNCEMENT CARD =====================
  Widget _announcementCard(DashboardModel user) {
    List<AnnouncementDetails> list = user.announcementDetails ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Announcement",
          style: AppTextStyle.normalBold20.copyWith(
            fontSize: 22.sp,
            color: Colors.black,
          ),
        ),

        customHeight(12),

        ...list.map((AnnouncementDetails item) {
          return GestureDetector(
            onTap: () {
              Get.to(() => AnnouncementDetailScreen(id: item.id ?? 0));
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 16.sp),
              padding: EdgeInsets.all(16.sp),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.sp),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.campaign, size: 30, color: Colors.grey.shade600),
                  customWidth(10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.announcementName ?? "",
                          style: AppTextStyle.normalBold16,
                        ),
                        customHeight(6),
                        AbsorbPointer(
                          absorbing: true,
                          child: Text(
                            "Click to View",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14.sp,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
