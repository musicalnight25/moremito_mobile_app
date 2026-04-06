/// Language Selector Widget Usage Guide
/// 
/// This guide explains how to use the new reusable language selector widgets
/// created in lib/utils/language_selector_widget.dart
/// 
/// ============================================================================
/// 
/// OPTION 1: DROPDOWN LANGUAGE SELECTOR
/// Use this for a clean, professional dropdown-style language selector
/// 
/// Example:
/// ```dart
/// import 'package:more_mitro_app/utils/language_selector_widget.dart';
/// 
/// // In your build method
/// LanguageSelectorDropdown(
///   isCompact: true,
///   backgroundColor: Colors.white,
///   textColor: Colors.black87,
/// )
/// ```
/// 
/// Parameters:
/// - isCompact (bool): Whether to use compact mode (default: true)
/// - backgroundColor (Color?): Background color of the dropdown (default: Colors.white)
/// - textColor (Color?): Text color (default: Colors.black87)
/// 
/// ============================================================================
/// 
/// OPTION 2: POPUP MENU BUTTON LANGUAGE SELECTOR
/// Use this for a quick-access button with popup menu
/// 
/// Example:
/// ```dart
/// import 'package:more_mitro_app/utils/language_selector_widget.dart';
/// 
/// // In your build method (e.g., in appBar.actions)
/// LanguageSelectorButton(
///   backgroundColor: Colors.white,
///   textColor: Colors.black87,
/// )
/// ```
/// 
/// Perfect for:
/// - App bar actions
/// - Settings bar
/// - Quick access menus
/// 
/// ============================================================================
/// 
/// FEATURES:
/// ✓ Professional UI with shadows
/// ✓ Dropdown style (compact)
/// ✓ Popup menu style (quick access)
/// ✓ Automatic API sync with PreferencesUtil
/// ✓ Get.updateLocale() updates the entire app
/// ✓ Success/Error snackbars
/// ✓ Icons for visual identification
/// ✓ Both English and Chinese (Simplified) support
/// ✓ Reusable across the entire app
/// ✓ Responsive with flutter_screenutil
/// 
/// ============================================================================
/// 
/// LOCATIONS WHERE LANGUAGE SELECTOR IS USED:
/// 
/// 1. Profile Screen - lib/pages/profile/my_profile_screen.dart
///    - Uses: LanguageSelectorDropdown in a section container
///    - Location: Top of the profile screen
/// 
/// 2. You can add to:
///    - Settings Screen (lib/pages/setting/setting_screen.dart)
///    - App Bar as quick access button
///    - Login Screen (before login)
///    - Splash Screen
///    - Navigation drawer
/// 
/// ============================================================================
/// 
/// TECHNICAL DETAILS:
/// 
/// - Saves preference to device using PreferencesUtil.saveLanguagePreference()
/// - Syncs with API using NetworkRepository.saveLanguage()
/// - Updates app locale in real-time with Get.updateLocale()
/// - Shows user feedback with Get.snackbar()
/// - Uses PhosphorIcons for consistent iconography
/// - Professional shadow effects for modern UI
/// - Responsive sizing with flutter_screenutil
/// 
/// ============================================================================
/// 
/// TRANSLATION STRINGS USED:
/// - "Language" / "语言"
/// - "Language changed to English" / "语言已更改为英文"
/// - "Language changed to Chinese" / "语言已更改为中文"
/// - "Failed to change language" / "更改语言失败"
/// - "Success" / "成功"
/// - "Error" / "错误"
/// 
/// All strings are already added to lib/utils/app_translations.dart
/// 
/// ============================================================================
