import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';
import '../../utils/app_asset.dart';
import 'survey_screen.dart';

class StartSurveyScreen extends StatefulWidget {
  StartSurveyScreen({Key? key}) : super(key: key);

  @override
  State<StartSurveyScreen> createState() => _StartSurveyScreenState();
}

class _StartSurveyScreenState extends State<StartSurveyScreen> {
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
                  Get.to(() => SurveyScreen(
                        isFromOnboarding: true,
                      ));
                }),
          ),
          customHeight(86),
        ],
      )),
    );
  }
}
