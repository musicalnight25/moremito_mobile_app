import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LanguageSettingsTile extends StatelessWidget {
  const LanguageSettingsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = Get.locale ?? const Locale('en', 'US');
    final isEnglish = currentLocale.languageCode == 'en';

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        leading: Icon(
          PhosphorIcons.globe(PhosphorIconsStyle.regular),
          size: 24.sp,
          color: Colors.blue.shade700,
        ),
        title: Text(
          'Language'.tr,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          isEnglish ? 'English' : '中文',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          PhosphorIcons.caretRight(PhosphorIconsStyle.regular),
          size: 20.sp,
          color: Colors.grey.shade400,
        ),
        onTap: () => _showLanguageBottomSheet(context),
      ),
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
        final isEnglish = currentLocale.languageCode == 'en';

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  'Change Language'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24.h),

                // English Option
                _buildLanguageOption(
                  context: context,
                  language: 'English',
                  code: 'en_US',
                  isSelected: isEnglish,
                  onTap: () {
                    Get.updateLocale(const Locale('en', 'US'));
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: 16.h),

                // Chinese Option
                _buildLanguageOption(
                  context: context,
                  language: '中文 (简体)',
                  code: 'zh_CN',
                  isSelected: !isEnglish,
                  onTap: () {
                    Get.updateLocale(const Locale('zh', 'CN'));
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: 20.h),
              ],
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
}
