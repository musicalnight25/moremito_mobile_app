import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../../controller/login_controller.dart';
import '../../utils/app_asset.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  var controller = Get.put(LoginController());

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
                  labelText: "Username*",
                  hintText: "Enter username",
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.username],
                  focusedBorderColor: primaryColor,
                ),
                PasswordWidget(
                  controller: controller.passwordController,
                  hintText: "Enter password",
                  labelText: "Password*",
                  keyboardType: TextInputType.visiblePassword,
                  autofillHints: const [AutofillHints.password],
                  focusedBorderColor: primaryColor,
                ),
              ],
            ),
          ),
          customHeight(40),
          PrimaryTextButton(
            title: "Login",
            onPressed: () {
              if (controller.usernameController.text.trim().isEmpty) {
                CommonMethod.getXSnackBar(
                    "Error",
                    "Username is required. Please enter your username.",
                    redColor);
              } else if (controller.passwordController.text.trim().isEmpty) {
                CommonMethod.getXSnackBar(
                    "Error",
                    "Password is required. Please enter your password.",
                    redColor);
              } else {
                controller.loginWithPassword(context);
              }
            },
          ),
        ],
      )),
    );
  }
}
