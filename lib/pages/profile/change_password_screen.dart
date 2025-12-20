import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';

import '../../controller/change_password_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Change Password",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () => SingleChildScrollView(
            padding: EdgeInsets.all(18.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Update Your Password",
                  style:
                      AppTextStyle.normalBold16.copyWith(color: primaryColor),
                ),
                height16,
                _passwordField(
                  label: "Current Password",
                  controller: controller.currentPasswordCtrl,
                ),
                _passwordField(
                  label: "New Password",
                  controller: controller.newPasswordCtrl,
                ),
                _passwordField(
                  label: "Confirm Password",
                  controller: controller.confirmPasswordCtrl,
                ),
                height30,
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => PrimaryTextButton(
                        isLoading: controller.isLoading.value,
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.changePassword,
                        title: "Change Password"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PasswordWidget(
            controller: controller,
            labelText: label,
          )
        ],
      ),
    );
  }
}
