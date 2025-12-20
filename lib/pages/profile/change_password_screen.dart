import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

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
      appBar: CommonAppBar(
        title: "Change Password",
        visibleBackButton: true,
      ),
      body: Obx(
        () => SingleChildScrollView(
          padding: EdgeInsets.all(18.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Update Your Password",
                style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
              ),
              height16,
              _passwordField(
                label: "Current Password",
                controller: controller.currentPasswordCtrl,
                obscure: controller.obscureCurrent,
              ),
              _passwordField(
                label: "New Password",
                controller: controller.newPasswordCtrl,
                obscure: controller.obscureNew,
              ),
              _passwordField(
                label: "Confirm Password",
                controller: controller.confirmPasswordCtrl,
                obscure: controller.obscureConfirm,
              ),
              height30,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.changePassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 14.sp),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text("Change Password"),
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
    required RxBool obscure,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.normalBold14),
          height06,
          Obx(
            () => TextField(
              controller: controller,
              obscureText: obscure.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.sp),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => obscure.value = !obscure.value,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
