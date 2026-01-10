import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/deep_link_controller.dart';
import 'package:more_mitro_app/pages/account/widget/deeplink_shimmer_tile.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class MyDeepLinksScreen extends StatelessWidget {
  const MyDeepLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeepLinkController dc = Get.put(DeepLinkController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "My Deep Links",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          /// ===================== SHIMMER WHILE LOADING =====================
          if (dc.loading.value) {
            return ListView.builder(
              padding: EdgeInsets.fromLTRB(16.sp, 100.sp, 16.sp, 16.sp),
              itemCount: 10,
              itemBuilder: (_, __) => const DeepLinkShimmerTile(),
            );
          }

          /// ===================== NO DATA =====================
          if (dc.deepLinks.isEmpty) {
            return RefreshIndicator(
              onRefresh: dc.fetchDeepLinks,
              color: primaryColor,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.sp, 100.sp, 16.sp, 16.sp),
                children: const [
                  SizedBox(height: 200),
                  NoDataFound(title: "Deep Links"),
                ],
              ),
            );
          }

          /// ===================== REAL DATA =====================
          return RefreshIndicator(
            onRefresh: dc.fetchDeepLinks,
            color: primaryColor,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(16.sp, 60.sp, 16.sp, 16.sp),
              itemCount: dc.deepLinks.length,
              itemBuilder: (_, i) {
                final item = dc.deepLinks[i];

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.sp),
                  margin: EdgeInsets.only(bottom: 16.sp),
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(14.sp),
                    border: Border.all(color: borderGreyColor),
                    boxShadow: [
                      BoxShadow(
                        color: bgPrimaryShadowColor.withOpacity(0.30),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title ?? "",
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                      customHeight(10),
                      GestureDetector(
                        onTap: () => _copy(item.url ?? ""),
                        child: Text(
                          item.url ?? "-",
                          style: AppTextStyle.normalRegular14.copyWith(
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      customHeight(14),
                      TextPrimaryButton(
                        title: "Copy Link",
                        onPressed: () => _copy(item.url ?? ""),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }

  void _copy(String link) {
    Clipboard.setData(ClipboardData(text: link));
    CommonMethod.getXSnackBar(
      "Copied",
      "Link copied to clipboard",
      primaryColor,
    );
  }
}
