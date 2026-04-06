import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../service/network_repository.dart';
import '../utils/preferences_util.dart';

/// Language selector button that opens a bottom sheet
class LanguageSelector extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;
  final bool showLabel;

  const LanguageSelector({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.showLabel = true,
  });

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final NetworkRepository _networkRepository = NetworkRepository();

  void _changeLanguage(String languageCode) async {
    try {
      final languageName = languageCode == 'zh' ? 'zh' : 'en';
      await _networkRepository.saveLanguage(
        null,
        {'Language': languageName},
      );
      await PreferencesUtil.saveLanguagePreference(languageName);

      if (languageCode == 'zh') {
        Get.updateLocale(const Locale('zh', 'CN'));
        Get.snackbar("Success".tr, "Language changed to Chinese".tr);
      } else {
        Get.updateLocale(const Locale('en', 'US'));
        Get.snackbar("Success".tr, "Language changed to English".tr);
      }

      if (mounted) {
        Navigator.pop(context);
        setState(() {});
      }
    } catch (e) {
      debugPrint("Error saving language: $e");
      Get.snackbar("Error".tr, "Failed to change language".tr);
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final isEnglish = Get.locale?.languageCode == 'en';
    final Color accentColor = const Color(0xFF2563EB);
    final Color borderColor = const Color(0xFFE5E7EB);
    final Color mutedTextColor = const Color(0xFF6B7280);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1D5DB),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Change Language'.tr,
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF111827),
                  ),
                ),
                SizedBox(height: 14.h),
                _buildLanguageOption(
                  context: context,
                  language: 'English',
                  code: 'en_US',
                  isSelected: isEnglish,
                  onTap: () => _changeLanguage('en'),
                  accentColor: accentColor,
                  borderColor: borderColor,
                  mutedTextColor: mutedTextColor,
                ),
                SizedBox(height: 8.h),
                _buildLanguageOption(
                  context: context,
                  language: '中文 (简体)',
                  code: 'zh_CN',
                  isSelected: !isEnglish,
                  onTap: () => _changeLanguage('zh'),
                  accentColor: accentColor,
                  borderColor: borderColor,
                  mutedTextColor: mutedTextColor,
                ),
                SizedBox(height: 4.h),
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
    required Color accentColor,
    required Color borderColor,
    required Color mutedTextColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? accentColor : borderColor,
            width: 1.4,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withValues(alpha: 0.12),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const [],
        ),
        child: Row(
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.16)
                    : const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                PhosphorIcons.translate(PhosphorIconsStyle.regular),
                size: 15.sp,
                color: isSelected ? accentColor : const Color(0xFF6B7280),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                      color: mutedTextColor,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18.w,
              height: 18.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? accentColor : Colors.white,
                border: Border.all(
                  color: isSelected ? accentColor : const Color(0xFFD1D5DB),
                  width: 1.4,
                ),
              ),
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 11.sp,
                      color: Colors.white,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale?.languageCode == 'en';
    final currentLanguage = isEnglish ? 'English' : '中文 (简体)';
    final Color surfaceColor =
        widget.backgroundColor ?? const Color(0xFFF8FAFC);
    final Color textColor = widget.textColor ?? const Color(0xFF0F172A);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showLanguageBottomSheet(context),
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: const Color(0xFFE5E7EB),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withValues(alpha: 0.05),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  PhosphorIcons.globe(PhosphorIconsStyle.regular),
                  size: 15.sp,
                  color: const Color(0xFF2563EB),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  currentLanguage,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ),
              Icon(
                PhosphorIcons.caretRight(PhosphorIconsStyle.bold),
                size: 13.sp,
                color: const Color(0xFF9CA3AF),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Alternative simple dropdown style (for backward compatibility)
class LanguageSelectorDropdown extends StatefulWidget {
  final bool isCompact;
  final Color? backgroundColor;
  final Color? textColor;

  const LanguageSelectorDropdown({
    super.key,
    this.isCompact = true,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<LanguageSelectorDropdown> createState() =>
      _LanguageSelectorDropdownState();
}

class _LanguageSelectorDropdownState extends State<LanguageSelectorDropdown> {
  final NetworkRepository _networkRepository = NetworkRepository();
  late String _selectedLanguage;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = Get.locale?.languageCode == 'zh' ? 'zh' : 'en';
  }

  void _changeLanguage(String languageCode) async {
    try {
      final languageName = languageCode == 'zh' ? 'zh' : 'en';
      await _networkRepository.saveLanguage(
        null,
        {'Language': languageName},
      );
      await PreferencesUtil.saveLanguagePreference(languageName);

      if (languageCode == 'zh') {
        Get.updateLocale(const Locale('zh', 'CN'));
        Get.snackbar("Success".tr, "Language changed to Chinese".tr);
      } else {
        Get.updateLocale(const Locale('en', 'US'));
        Get.snackbar("Success".tr, "Language changed to English".tr);
      }

      setState(() {
        _selectedLanguage = languageCode;
      });
    } catch (e) {
      debugPrint("Error saving language: $e");
      Get.snackbar("Error".tr, "Failed to change language".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
      child: DropdownButton<String>(
        value: _selectedLanguage,
        isExpanded: true,
        elevation: 0,
        underline: const SizedBox.shrink(),
        icon: Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Icon(
            PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
            size: 18.sp,
            color: Colors.grey.shade600,
          ),
        ),
        items: [
          DropdownMenuItem(
            value: 'en',
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.globe(PhosphorIconsStyle.regular),
                  size: 20.sp,
                  color: Colors.blue.shade600,
                ),
                SizedBox(width: 12.w),
                Text(
                  'English',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          DropdownMenuItem(
            value: 'zh',
            child: Row(
              children: [
                Icon(
                  PhosphorIcons.globe(PhosphorIconsStyle.regular),
                  size: 20.sp,
                  color: Colors.orange.shade600,
                ),
                SizedBox(width: 12.w),
                Text(
                  '中文 (简体)',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: widget.textColor ?? Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
        onChanged: (String? newValue) {
          if (newValue != null) {
            _changeLanguage(newValue);
          }
        },
      ),
    );
  }
}

/// Standalone button widget for language selection with popup menu
class LanguageSelectorButton extends StatefulWidget {
  final Color? backgroundColor;
  final Color? textColor;

  const LanguageSelectorButton({
    super.key,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
  final NetworkRepository _networkRepository = NetworkRepository();

  void _changeLanguage(String languageCode) async {
    try {
      final languageName = languageCode == 'zh' ? 'zh' : 'en';
      await _networkRepository.saveLanguage(
        null,
        {'Language': languageName},
      );
      await PreferencesUtil.saveLanguagePreference(languageName);

      if (languageCode == 'zh') {
        Get.updateLocale(const Locale('zh', 'CN'));
        Get.snackbar("Success".tr, "Language changed to Chinese".tr);
      } else {
        Get.updateLocale(const Locale('en', 'US'));
        Get.snackbar("Success".tr, "Language changed to English".tr);
      }

      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Error saving language: $e");
      Get.snackbar("Error".tr, "Failed to change language".tr);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEnglish = Get.locale?.languageCode == 'en';
    final currentLanguage = isEnglish ? 'English' : '中文 (简体)';

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 18,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        onSelected: _changeLanguage,
        itemBuilder: (BuildContext context) => [
          PopupMenuItem(
            value: 'en',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIcons.globe(PhosphorIconsStyle.regular),
                  size: 18.sp,
                  color: Colors.blue.shade600,
                ),
                SizedBox(width: 12.w),
                Text(
                  'English',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'zh',
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  PhosphorIcons.globe(PhosphorIconsStyle.regular),
                  size: 18.sp,
                  color: Colors.orange.shade600,
                ),
                SizedBox(width: 12.w),
                Text(
                  '中文 (简体)',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                PhosphorIcons.globe(PhosphorIconsStyle.regular),
                size: 18.sp,
                color: Colors.blue.shade600,
              ),
              SizedBox(width: 8.w),
              Text(
                currentLanguage,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor ?? Colors.black87,
                ),
              ),
              SizedBox(width: 4.w),
              Icon(
                PhosphorIcons.caretDown(PhosphorIconsStyle.regular),
                size: 14.sp,
                color: Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
