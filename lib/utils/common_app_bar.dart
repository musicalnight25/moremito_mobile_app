import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../pages/main_dashboard_screen.dart';
import '../pages/profile/my_profile_screen.dart';
import '../pages/setting/menu_screen.dart';
import 'app_asset.dart';
import 'app_text_style.dart';
import 'colors.dart';
import 'common_method.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? actionWidget;
  final Widget? leading;
  final bool visibleBackButton;

  const CommonAppBar({
    Key? key,
    this.actionWidget,
    this.leading,
    this.title,
    this.visibleBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      shape: Border(
        bottom: BorderSide(
          color: greyColor,
          width: 1,
        ),
      ),

      // ───────── LEADING ─────────
      leading: leading ??
          IconButton(
            onPressed: () {
              visibleBackButton ? Get.back() : Get.to(() => MenuScreen());
            },
            icon: Icon(
              visibleBackButton ? Icons.arrow_back_ios_new : Icons.menu_rounded,
              size: 24.sp,
              color: primaryBlack,
            ),
          ),

      // ───────── TITLE ─────────
      title: title != null
          ? Text(
              title!,
              style: AppTextStyle.normalBold16,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          : Image.asset(
              AppAsset.logo,
              width: 148.sp,
              height: 30.sp,
              fit: BoxFit.scaleDown,
            ),

      centerTitle: true,

      // ───────── ACTION ─────────
      actions: [
        actionWidget ??
            Padding(
              padding: EdgeInsets.only(right: 12.sp),
              child: GestureDetector(
                onTap: () {
                  // Optional: Navigate to profile
                  Get.to(() => MyProfileScreen());
                },
                child: Container(
                  width: 32.sp,
                  height: 32.sp,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Obx(
                    () => Text(
                      CommonMethod.getProfileText(
                        homeController.dashboardModel.value?.name ?? "U",
                      ),
                      style: AppTextStyle.normalSemiBold14
                          .copyWith(color: primaryWhite),
                    ),
                  ),
                ),
              ),
            ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 6.sp);
}
