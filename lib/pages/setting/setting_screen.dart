import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

// Your App Imports
import 'package:more_mitro_app/controller/login_controller.dart';
import 'package:more_mitro_app/pages/setting/widget/app_version_text.dart';
import 'package:more_mitro_app/service/network_repository.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/preferences_util.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../profile/change_password_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final loginController = Get.put(LoginController());
  final networkRepository = NetworkRepository();

  String _toAppLanguageCode(String code) {
    return code.toLowerCase().startsWith('zh') ? 'zh' : 'en';
  }

  Locale _toLocale(String code) {
    final appCode = _toAppLanguageCode(code);
    return appCode == 'zh'
        ? const Locale('zh', 'CN')
        : const Locale('en', 'US');
  }

  bool _isLanguageSelected(Locale currentLocale, String optionCode) {
    return currentLocale.languageCode == _toAppLanguageCode(optionCode);
  }

  Future<void> _changeLanguage({
    required BuildContext context,
    required String languageCode,
  }) async {
    try {
      await networkRepository.saveLanguage(
        context,
        {'Language': languageCode},
      );

      final appCode = _toAppLanguageCode(languageCode);
      await PreferencesUtil.saveLanguagePreference(appCode);

      if (!context.mounted) return;
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 200), () {
        Get.updateLocale(_toLocale(languageCode));
      });
    } catch (e) {
      debugPrint("Error saving language: $e");
      if (!context.mounted) return;
      Navigator.pop(context);
    }
  }

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

                    // --- SECTION 2: LANGUAGE & PREFERENCES ---
                    _CompactSettingsGroup(
                      title: "Settings".tr,
                      children: [
                        _SleekSettingsTile(
                          icon: PhosphorIcons.globe(PhosphorIconsStyle.regular),
                          title: "Language".tr,
                          subtitle: Get.locale?.languageCode == 'zh'
                              ? '中文 (Simplified)'
                              : 'English',
                          onTap: () => _showLanguageBottomSheet(context),
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h), // Reduced spacing between groups

                    // --- SECTION 3: ACTIONS ---
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

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final currentLocale = Get.locale ?? const Locale('en', 'US');

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: FutureBuilder<List<Map<String, String>>>(
              future: networkRepository.getLanguageList(null),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildLanguageSheetShimmer();
                }

                final options = snapshot.data ?? const [];
                if (options.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Text(
                      "No language options available".tr,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.black54,
                      ),
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Language'.tr,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ...options.asMap().entries.map((entry) {
                      final index = entry.key;
                      final option = entry.value;
                      final code = option['code'] ?? '';
                      final name = option['name'] ?? code;
                      return Column(
                        children: [
                          _buildLanguageOption(
                            context: context,
                            language: name,
                            code: code,
                            isSelected:
                                _isLanguageSelected(currentLocale, code),
                            onTap: () => _changeLanguage(
                              context: context,
                              languageCode: code,
                            ),
                          ),
                          if (index != options.length - 1)
                            SizedBox(height: 16.h),
                        ],
                      );
                    }),
                    SizedBox(height: 20.h),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String language,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Radio Button
            Container(
              height: 24.w,
              width: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? Colors.blue.shade400 : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? Colors.blue.shade400 : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            // Language Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 24.sp,
                color: Colors.blue.shade400,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSheetShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 140.w,
            height: 20.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          SizedBox(height: 24.h),
          ...List.generate(
            2,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: index == 1 ? 0 : 16.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.w,
                      height: 24.w,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120.w,
                            height: 14.h,
                            color: Colors.white,
                          ),
                          SizedBox(height: 6.h),
                          Container(
                            width: 72.w,
                            height: 10.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
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
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool showDivider;
  final bool isDestructive;
  final bool showTrailing;

  const _SleekSettingsTile({
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        if (subtitle != null)
                          Padding(
                            padding: EdgeInsets.only(top: 4.h),
                            child: Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: hintGreyColor,
                              ),
                            ),
                          ),
                      ],
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
