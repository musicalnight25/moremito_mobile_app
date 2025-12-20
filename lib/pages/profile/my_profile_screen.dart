import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
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
      appBar: CommonAppBar(
        title: "My Profile",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.all(18.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _title("Personal Information"),
                      _field("First Name", controller.firstNameCtrl),
                      _field("Last Name", controller.lastNameCtrl),
                      _field("Email", controller.emailCtrl),
                      _field("Phone", controller.phoneCtrl),
                      _field("WhatsApp Phone", controller.whatsappCtrl),
                      if (controller.profile.value?.hasGovernmentId == true)
                        _field(
                          "Government ID",
                          controller.governmentIdCtrl,
                        ),
                      height30,
                      PrimaryTextButton(
                          onPressed: controller.updateProfile,
                          title: "Save Changes"),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Text(
        text,
        style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormFieldWidget(
            controller: ctrl,
            labelText: label,
          )

          // Text(label, style: AppTextStyle.normalBold14),
          // height06,
          // TextField(
          //   controller: ctrl,
          //   decoration: InputDecoration(
          //     border: OutlineInputBorder(
          //       borderRadius: BorderRadius.circular(10.sp),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
