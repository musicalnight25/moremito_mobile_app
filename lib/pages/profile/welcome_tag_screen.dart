import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';

import '../../controller/welcome_tag_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';

class WelcomeTagScreen extends StatelessWidget {
  const WelcomeTagScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WelcomeTagController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "Welcome Tag",
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
                      Text(
                        "Welcome Tag Information",
                        style: AppTextStyle.normalBold16
                            .copyWith(color: primaryColor),
                      ),
                      height16,
                      _field("Welcome Name", controller.nameCtrl),
                      _field("Welcome Email", controller.emailCtrl),
                      _field("Welcome Phone", controller.phoneCtrl),
                      height10,
                      Row(
                        children: [
                          Obx(
                            () => Switch(
                              value: controller.useDisplay.value,
                              activeColor: primaryColor,
                              onChanged: (val) =>
                                  controller.useDisplay.value = val,
                            ),
                          ),
                          width10,
                          Expanded(
                            child: Text(
                              "Use this information for display",
                              style: AppTextStyle.normalRegular14,
                            ),
                          ),
                        ],
                      ),
                      height30,
                      PrimaryTextButton(
                          onPressed: controller.updateWelcomeTag,
                          title: "Save Changes"),
                    ],
                  ),
                ),
        ),
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
          ),
        ],
      ),
    );
  }
}
