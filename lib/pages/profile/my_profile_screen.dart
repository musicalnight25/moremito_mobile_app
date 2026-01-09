import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';

import '../../controller/my_profile_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyProfileController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "My Profile",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            final profile = controller.profile.value;
            if (profile == null) {
              return const Center(child: Text("No profile data found"));
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(18.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title("Account Information"),
                  _info("Username", profile.userName),
                  _info("SMS Code", profile.smsCode),
                  height20,
                  _title("Personal Information"),
                  _info("First Name", profile.firstName),
                  _info("Last Name", profile.lastName),
                  _info("Email", profile.email),
                  _info("Phone", profile.phone),
                  _info("WhatsApp Phone", profile.whatsappPhone),
                  height20,
                  _title("Membership"),
                  _info("Membership Type", profile.membershipType),
                  _info("Join Date", profile.joinDate),
                  height20,
                  // _title("Government ID"),
                  // _info(
                  //   "Has Government ID",
                  //   profile.hasGovernmentId == true ? "Yes" : "No",
                  // ),
                  // if (profile.hasGovernmentId == true)
                  //   _info("Government ID", profile.governmentId),
                  height20,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Text(
        text,
        style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _info(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.normalSemiBold14,
          ),
          height04,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: 14.sp,
              vertical: 12.sp,
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10.sp),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Text(
              value?.isNotEmpty == true ? value! : "-",
              style: AppTextStyle.normalRegular14,
            ),
          ),
        ],
      ),
    );
  }
}
