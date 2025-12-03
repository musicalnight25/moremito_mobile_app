import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class SettingScreen extends StatefulWidget {
  SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var loginController = Get.put(LoginController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: CommonAppBar(title: "Setting"),
      backgroundColor: Colors.grey[200],
      extendBodyBehindAppBar: true,
      body: BaseBackgroundWidget(
        child: Center(
          child: PrimaryTextButton(
            title: "Logout",
            onPressed: () {
              CommonMethod.showCustomBottomSheet(
                title: "Confirm Logout",
                message: 'Are you sure you want to logout?',
                confirmButtonTitle: "Logout",
                showCancelButton: true,
                onConfirm: () {
                  Get.back();
                  loginController.logout(context);
                  CommonMethod.logOutUser();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
