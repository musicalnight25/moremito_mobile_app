import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Your App Imports
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/pages/setting/widget/app_version_text.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import '../profile/change_password_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            CommonAppBar(
              title: "Settings".tr,
              visibleBackButton: false,
            ),
            Expanded(
              child: SingleChildScrollView(
                // Tighter padding for a compact feel
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 12.h),

                    // --- SECTION 1: ACCOUNT ---
                    _CompactSettingsGroup(
                      title: "Account".tr,
                      children: [
                        _SleekSettingsTile(
                          icon: Icons.lock_outline_rounded,
                          title: "Change Password".tr,
                          // Removed subtitle for a cleaner look, or keep it short
                          onTap: () =>
                              Get.to(() => const ChangePasswordScreen()),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h), // Reduced spacing between groups

                    // --- SECTION 2: ACTIONS ---
                    _CompactSettingsGroup(
                      title: "Actions".tr,
                      children: [
                        _SleekSettingsTile(
                          icon: Icons.logout_rounded,
                          title: "Logout".tr,
                          isDestructive: true,
                          // Special flag for red styling
                          showTrailing: false,
                          showDivider: false,
                          onTap: _handleLogout,
                        ),
                      ],
                    ),

                    AppVersionText(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout() {
    CommonMethod.showCustomBottomSheet(
      title: "Confirm Logout".tr,
      message: 'Are you sure you want to logout?',
      confirmButtonTitle: "Logout",
      showCancelButton: true,
      onConfirm: () {
        Get.back();
        loginController.logout(context);
        CommonMethod.logOutUser();
      },
    );
  }
}

// ---------------------------------------------------------------------------
// SLEEKER REUSABLE COMPONENTS
// ---------------------------------------------------------------------------

class _CompactSettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _CompactSettingsGroup({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiny Header inside the group logic
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp, // Smaller font
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: subTitleColor,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryWhite,
            borderRadius: BorderRadius.circular(12.r), // Tighter radius
            border: Border.all(color: borderGreyColor.withOpacity(0.4)),
            boxShadow: [
              BoxShadow(
                // Very subtle shadow for "flat" but lifted look
                color: bgPrimaryShadowColor.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SleekSettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isDestructive;
  final bool showTrailing;

  const _SleekSettingsTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.showDivider = true,
    this.isDestructive = false,
    this.showTrailing = true,
  });

  @override
  Widget build(BuildContext context) {
    // Define colors based on destructive state
    final Color itemColor = isDestructive ? redColor : primaryColor;
    final Color itemBgColor = isDestructive ? softRedColor : paleYellowColor;
    final Color textColor = isDestructive ? redColor : lightBlackColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        highlightColor: itemBgColor.withOpacity(0.4),
        splashColor: itemBgColor.withOpacity(0.5),
        child: Column(
          children: [
            Padding(
              // Reduced internal padding for "small scale" feel
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Row(
                children: [
                  // --- Icon Box (Smaller) ---
                  Container(
                    width: 34.w, // Reduced from 42
                    height: 34.w,
                    decoration: BoxDecoration(
                      color: itemBgColor,
                      borderRadius:
                          BorderRadius.circular(8.r), // Tighter radius
                    ),
                    child: Icon(
                      icon,
                      size: 18.sp, // Reduced from 22
                      color: itemColor,
                    ),
                  ),

                  SizedBox(width: 14.w), // Reduced gap

                  // --- Text Content ---
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp, // Reduced from 16 for cleaner look
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),

                  // --- Trailing Arrow (Minimal) ---
                  if (showTrailing)
                    Icon(
                      Icons.arrow_forward_ios_rounded, // Sleeker arrow
                      size: 14.sp,
                      color: hintGreyColor.withOpacity(0.6),
                    ),
                ],
              ),
            ),

            // --- Divider ---
            if (showDivider)
              Divider(
                height: 1,
                indent: 60.w,
                // Aligns with text
                endIndent: 0,
                color: borderGreyColor.withOpacity(0.3),
                thickness: 0.8,
              ),
          ],
        ),
      ),
    );
  }
}
