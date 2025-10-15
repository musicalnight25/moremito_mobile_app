import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../controller/login_controller.dart';
import '../utils/app_asset.dart';
import 'survey_screen.dart';

class StartSurveyScreen extends StatelessWidget {
  StartSurveyScreen({Key? key}) : super(key: key);

  var controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: BaseBackgroundWidget(
          child: Column(
        children: [
          customHeight(20),
          Image.asset(
            AppAsset.logo,
            width: 148.sp,
            height: 31.sp,
            fit: BoxFit.scaleDown,
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: Text(
              'To continue, please take a moment to complete a brief survey. Your feedback helps us improve your experience!',
              style: AppTextStyle.normalSemiBold18,
              textAlign: TextAlign.center,
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.sp),
            child: PrimaryTextButton(
                title: "Start Survey",
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.getSurveyQuestions(null);
                  });
                  Get.to(() => SurveyScreen());
                }),
          ),
          customHeight(86),
        ],
      )),
    );
  }
}
