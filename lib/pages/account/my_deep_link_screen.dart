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
import 'package:share_plus/share_plus.dart';

class MyDeepLinksScreen extends StatelessWidget {
  const MyDeepLinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DeepLinkController dc = Get.put(DeepLinkController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: primaryWhite,
      appBar: const CommonAppBar(
        title: "My Deep Links",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          /// ===================== LOADING =====================
          if (dc.loading.value) {
            return ListView.separated(
              padding: EdgeInsets.all(16.sp),
              itemCount: 8,
              separatorBuilder: (_, __) => SizedBox(height: 16.sp),
              itemBuilder: (_, __) => const DeepLinkShimmerTile(),
            );
          }

          /// ===================== NO DATA =====================
          if (dc.deepLinks.isEmpty) {
            return RefreshIndicator(
              onRefresh: dc.fetchDeepLinks,
              color: primaryColor,
              child: ListView(
                padding: EdgeInsets.all(16.sp),
                children: const [
                  SizedBox(height: 150),
                  NoDataFound(title: "No Deep Links Generated"),
                ],
              ),
            );
          }

          /// ===================== DATA LIST =====================
          return RefreshIndicator(
            onRefresh: dc.fetchDeepLinks,
            color: primaryColor,
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16.sp, 20.sp, 16.sp, 40.sp),
              itemCount: dc.deepLinks.length,
              separatorBuilder: (_, __) => SizedBox(height: 16.sp),
              itemBuilder: (_, i) {
                final item = dc.deepLinks[i];
                return _buildProLinkCard(item);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildProLinkCard(dynamic item) {
    final String title = item.title ?? "Untitled Link";
    final String url = item.url ?? "";

    return Container(
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderGreyColor.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Header Section (Title + Share) ---
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.sp),
                        decoration: BoxDecoration(
                          color: bgPrimaryShadowColor.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child:
                            Icon(Icons.link, size: 18.sp, color: primaryColor),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.normalSemiBold16.copyWith(
                            color: primaryBlack,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Optional Share Button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      if (url.isNotEmpty) {
                        Share.share("Check this out: $url");
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(6.sp),
                      child: Icon(Icons.share_outlined,
                          size: 20.sp, color: hintGreyColor),
                    ),
                  ),
                )
              ],
            ),
          ),

          // --- Divider ---
          Divider(height: 1, color: borderGreyColor.withOpacity(0.4)),

          // --- URL Capsule Section ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              // Very subtle grey bg for bottom half
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16.r),
                bottomRight: Radius.circular(16.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LINK URL",
                  style: TextStyle(
                    color: textGreyColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                  ),
                ),
                SizedBox(height: 8.h),

                // The "Input Field" looking container
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(color: borderGreyColor),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          url.isNotEmpty ? url : "No URL available",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color:
                                url.isNotEmpty ? primaryColor : hintGreyColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),

                      // The Vertical Divider
                      Container(width: 1, height: 20.h, color: borderGreyColor),

                      // The Copy Action
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _copy(url),
                          borderRadius: BorderRadius.circular(6),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            child: Row(
                              children: [
                                Icon(Icons.copy_rounded,
                                    size: 16.sp, color: primaryColor),
                                SizedBox(width: 6.w),
                                Text(
                                  "COPY",
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _copy(String link) {
    if (link.isEmpty) return;
    Clipboard.setData(ClipboardData(text: link));
    CommonMethod.getXSnackBar(
      "Success",
      "Link copied to clipboard",
      primaryColor,
    );
    // Optional: Add haptic feedback for "Pro" feel
    HapticFeedback.lightImpact();
  }
}
