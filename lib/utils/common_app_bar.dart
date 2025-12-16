import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/main_dashboard_screen.dart';
import 'package:more_mitro_app/pages/account/my_account_info_screen.dart';
import 'package:more_mitro_app/utils/colors.dart';

import '../pages/setting/menu_screen.dart';
import 'app_asset.dart';
import 'app_text_style.dart';
import 'common_method.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? actionWidget;
  final Widget? leading;
  bool visibleBackButton;

  CommonAppBar({
    Key? key,
    this.actionWidget,
    this.leading,
    this.title,
    this.visibleBackButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      elevation: 0,
      shape: Border(
        bottom: BorderSide(
          color: greyColor,
          width: 1,
        ),
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          visibleBackButton
              ? IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    color: Colors.transparent,
                    child: SvgPicture.asset(
                      AppAsset.arrowBack,
                      width: 32.sp,
                      height: 32.sp,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                )
              : IconButton(
                  onPressed: () {
                    Get.to(() => MenuScreen());
                  },
                  icon: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.sp),
                    child: SvgPicture.asset(
                      AppAsset.menu,
                      width: 32.sp,
                      height: 32.sp,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
          Spacer(),
          title != null
              ? Expanded(
                  child: Text(
                    title!,
                    style: AppTextStyle.normalBold18,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              : Center(
                  child: Image.asset(
                    AppAsset.logo,
                    width: 148.sp,
                    height: 30.sp,
                    fit: BoxFit.scaleDown,
                  ),
                ),
          Spacer(),
          // Image.asset(
          //   AppAsset.avatar,
          //   width: 40.sp,
          //   height: 40.sp,
          //   fit: BoxFit.scaleDown,
          // ),

          IconButton(
            onPressed: () {
              // Get.to(() => MyAccountInfoScreen());
            },
            icon: actionWidget ??
                Container(
                  width: 32.sp,
                  height: 32.sp,
                  margin: EdgeInsets.symmetric(
                    horizontal: 16.sp,
                    vertical: 10.sp,
                  ),
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Obx(
                      () => Text(
                        CommonMethod.getProfileText(
                            homeController.dashboardModel.value?.name ??
                                "Unknown"),
                        style: AppTextStyle.normalSemiBold14
                            .copyWith(color: primaryWhite),
                      ),
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 8.sp);
}
