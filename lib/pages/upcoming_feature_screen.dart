import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../controller/login_controller.dart';
import '../utils/app_asset.dart';

class UpcomingFeatureScreen extends StatelessWidget {
  UpcomingFeatureScreen({Key? key}) : super(key: key);

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
              padding: EdgeInsets.symmetric(horizontal: 30.sp),
              child: Text(
                'Exciting features are on the way! Stay tuned for updates and new enhancements.',
                style: AppTextStyle.normalSemiBold18,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 36.sp),
              child: PrimaryTextButton(
                title: "Back to Home",
                onPressed: () {
                  Get.back();
                },
              ),
            ),
            customHeight(86),
          ],
        ),
      ),
    );
  }
}
