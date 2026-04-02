import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../../controller/login_controller.dart';
import '../../service/pop_up_service.dart';
import '../../utils/app_asset.dart';
import '../setting/widget/app_version_text.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.put(LoginController());

  @override
  void initState() {
    PopupService.runAppChecks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: BaseBackgroundWidget(
          child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.sp),
        children: [
          customHeight(208),
          Image.asset(
            AppAsset.logo,
            width: 148.sp,
            height: 31.sp,
            fit: BoxFit.scaleDown,
          ),
          customHeight(40),
          AutofillGroup(
            child: Column(
              children: [
                TextFormFieldWidget(
                  controller: controller.usernameController,
                  labelText: "Username*".tr,
                  hintText: "Enter username".tr,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.username],
                  focusedBorderColor: primaryColor,
                ),
                PasswordWidget(
                  controller: controller.passwordController,
                  hintText: "Enter password".tr,
                  labelText: "Password*".tr,
                  // keyboardType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  focusedBorderColor: primaryColor,
                ),
              ],
            ),
          ),
          customHeight(16),

          /// -------- REMEMBER ME --------
          Obx(() {
            return Row(
              children: [
                Checkbox(
                  value: controller.rememberMe.value,
                  activeColor: primaryColor,
                  onChanged: (value) {
                    controller.rememberMe.value = value ?? false;
                  },
                ),
                Text(
                  "Remember me".tr,
                  style: AppTextStyle.normalRegular14,
                ),
              ],
            );
          }),

          customHeight(32),
          PrimaryTextButton(
            title: "Login".tr,
            onPressed: () {
              if (controller.usernameController.text.trim().isEmpty) {
                CommonMethod.getXSnackBar("Error".tr, "Username is required. Please enter your username.".tr,
                    redColor);
              } else if (controller.passwordController.text.trim().isEmpty) {
                CommonMethod.getXSnackBar("Error".tr, "Password is required. Please enter your password.".tr,
                    redColor);
              } else {
                controller.loginWithPassword(context);
              }
            },
          ),
          AppVersionText(),
        ],
      )),
    );
  }
}
