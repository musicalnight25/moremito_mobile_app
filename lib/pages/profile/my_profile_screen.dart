import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';

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
      appBar: const CommonAppBar(
        title: "My Profile",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
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
                _readOnlyField("Username", profile.userName),
                _readOnlyField("SMS Code", profile.smsCode),

                height20,
                _title("Personal Information"),
                _editableField("First Name", controller.firstNameCtrl),
                _editableField("Last Name", controller.lastNameCtrl),
                _editableField(
                  "Email",
                  controller.emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                ),
                _editableField(
                  "Phone",
                  controller.phoneCtrl,
                  keyboardType: TextInputType.phone,
                ),
                _editableField(
                  "WhatsApp Phone",
                  controller.whatsappCtrl,
                  keyboardType: TextInputType.phone,
                ),

                height20,
                _title("Membership"),
                _readOnlyField("Membership Type", profile.membershipType),
                _readOnlyField("Join Date", profile.joinDate),

                height30,

                // UPDATE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => PrimaryTextButton(
                      isLoading: controller.isLoading.value,
                      onPressed: () {
                        controller.updateProfile();
                      },
                      title: "Update Profile",
                    ),
                  ),
                ),

                height20,
              ],
            ),
          );
        }),
      ),
    );
  }

  // ------------------ UI HELPERS ------------------

  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Text(
        text,
        style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _readOnlyField(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.normalSemiBold14),
          height04,
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp),
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

  Widget _editableField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.normalSemiBold14),
          height04,
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 14.sp,
                vertical: 12.sp,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.sp),
                borderSide: const BorderSide(color: primaryColor),
              ),
            ),
            style: AppTextStyle.normalRegular14,
          ),
        ],
      ),
    );
  }
}
