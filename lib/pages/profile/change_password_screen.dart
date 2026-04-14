import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Your App Imports
import 'package:more_mitro_app/controller/change_password_controller.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart'; // Assuming PasswordWidget is here
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePasswordController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Change Password".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        // REMOVED: The outer Obx() was causing the crash
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create new password".tr,
                style: AppTextStyle.normalBold16.copyWith(
                  fontSize: 18.sp,
                  color: lightBlackColor,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Your new password must be different from previously used passwords."
                    .tr,
                style: AppTextStyle.normalRegular14.copyWith(
                  color: textGreyColor,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 30.h),

              // --- Form Fields ---
              _passwordField(
                label: "Current Password".tr,
                controller: controller.currentPasswordCtrl,
              ),
              _passwordField(
                label: "New Password".tr,
                controller: controller.newPasswordCtrl,
              ),
              _passwordField(
                label: "Confirm Password".tr,
                controller: controller.confirmPasswordCtrl,
              ),

              SizedBox(height: 40.h),

              // --- Action Button ---
              SizedBox(
                width: double.infinity,
                // KEEP: This Obx is correct because it listens to isLoading
                child: Obx(
                  () => PrimaryTextButton(
                    isLoading: controller.isLoading.value,
                    onPressed: controller.isLoading.value
                        ? null // Disable button while loading
                        : controller.changePassword,
                    title: "Update Password".tr,
                  ),
                ),
              ),
            ],
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
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Using your PasswordWidget (assuming it handles obscure text internally)
          PasswordWidget(
            controller: controller,
            labelText: label,
            hintText: "Please Enter {label}".trParams({
              "label": label,
            }),
            // Add hint text or styles if your widget supports it for better UX
          ),
        ],
      ),
    );
  }
}
