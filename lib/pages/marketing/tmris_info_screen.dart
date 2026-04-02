import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

import '../../controller/tmris_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import '../../utils/no_data_found.dart';

class TmrisInfoScreen extends StatelessWidget {
  const TmrisInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TmrisController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(
          () => ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              height20,

              /// ───── TITLE ─────
              Text(
                "Allow Others to Request MoreMito Info from Me".tr,
                style: AppTextStyle.normalExtraBold.copyWith(fontSize: 24.sp),
              ),

              height16,

              /// ───── LOADING ─────
              if (controller.isLoading.value) _loadingCard(),

              /// ───── EMPTY ─────
              if (!controller.isLoading.value && controller.contentList.isEmpty)
                const NoDataFound(),

              if (!controller.isLoading.value)
                ShadowContainerWidget(
                  widget: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ───── CONTENT ─────
                      ...controller.contentList.map(_infoText),
                    ],
                  ),
                ),

              height30,
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── CONTENT TEXT ─────────────────

  Widget _infoText(String text) {
    final isPhoneLine = text.contains("+1");

    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Text(
        text,
        style: isPhoneLine
            ? AppTextStyle.normalSemiBold16.copyWith(color: primaryColor)
            : AppTextStyle.normalRegular14
                .copyWith(color: primaryBlack, height: 1.6),
      ),
    );
  }

  // ───────────────── LOADING ─────────────────

  Widget _loadingCard() {
    return Container(
      height: 140.sp,
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: borderGreyColor.withOpacity(.3),
        borderRadius: BorderRadius.circular(14.sp),
      ),
    );
  }
}
