// Example implementations of Language Selector widgets
// These examples show how to use the new reusable language selector
// in different parts of your application

// ============================================================================
// EXAMPLE 1: Using in App Bar as Quick Access Button
// ============================================================================
//
// In your main screen or app bar:
//
// AppBar(
//   title: Text("My App"),
//   actions: [
//     Padding(
//       padding: EdgeInsets.symmetric(horizontal: 8.w),
//       child: const LanguageSelectorButton(),
//     ),
//   ],
// )

// ============================================================================
// EXAMPLE 2: Using Dropdown in a Card/Container
// ============================================================================
//
// Container(
//   padding: EdgeInsets.all(16.w),
//   decoration: BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(12.r),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.08),
//         blurRadius: 12,
//         offset: const Offset(0, 4),
//       ),
//     ],
//   ),
//   child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text("Select Language", style: AppTextStyle.normalBold16),
//       SizedBox(height: 12.h),
//       const LanguageSelectorDropdown(
//         isCompact: true,
//         backgroundColor: Colors.white,
//       ),
//     ],
//   ),
// )

// ============================================================================
// EXAMPLE 3: Using in Navigation Drawer
// ============================================================================
//
// Drawer(
//   child: ListView(
//     children: [
//       // ... other drawer items ...
//       ListTile(
//         title: Text("Language Settings"),
//         trailing: const LanguageSelectorButton(),
//       ),
//     ],
//   ),
// )

// ============================================================================
// EXAMPLE 4: Using in Settings/Preferences Screen
// ============================================================================
//
// Container(
//   padding: EdgeInsets.all(16.w),
//   child: Column(
//     children: [
//       Text("Preferences", style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
//       SizedBox(height: 16.h),
//       LanguageSelectorDropdown(
//         isCompact: true,
//         backgroundColor: Colors.grey.shade50,
//         textColor: Colors.black87,
//       ),
//     ],
//   ),
// )

// ============================================================================
// EXAMPLE 5: Custom Styling with Different Colors
// ============================================================================
//
// // Light theme
// LanguageSelectorDropdown(
//   isCompact: true,
//   backgroundColor: Colors.white,
//   textColor: Colors.black87,
// )
//
// // Dark theme
// LanguageSelectorDropdown(
//   isCompact: true,
//   backgroundColor: Colors.grey.shade800,
//   textColor: Colors.white,
// )
//
// // Branded colors
// LanguageSelectorDropdown(
//   isCompact: true,
//   backgroundColor: Color(0xFF0066FF),
//   textColor: Colors.white,
// )

// ============================================================================
// EXAMPLE 6: Floating Action Button with Language Selection
// ============================================================================
//
// FloatingActionButton.extended(
//   onPressed: () {
//     // Show language selector in a dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text("Select Language".tr),
//         content: const LanguageSelectorDropdown(isCompact: true),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text("Close".tr),
//           ),
//         ],
//       ),
//     );
//   },
//   label: Text("Language".tr),
//   icon: const Icon(Icons.language),
// )

// ============================================================================
// IMPORTS REQUIRED IN YOUR SCREEN:
// ============================================================================
//
// import 'package:more_mitro_app/utils/language_selector_widget.dart';
// import 'package:more_mitro_app/utils/app_text_style.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';

// ============================================================================
// KEY FEATURES:
// ============================================================================
//
// ✓ Dropdown Style: Clean, professional dropdown menu
// ✓ Popup Button Style: Quick-access popup menu button
// ✓ Customizable Colors: Background and text colors
// ✓ Professional Shadows: Elevated UI with material shadows
// ✓ Responsive: Uses flutter_screenutil for all sizing
// ✓ Icons: Uses PhosphorIcons for consistent design language
// ✓ Auto-Save: Automatically saves preference and updates app
// ✓ Feedback: Shows success/error snackbars
// ✓ Global Update: Uses Get.updateLocale() to update entire app
// ✓ Compact Mode: toggle compact/expanded styles
//
// ============================================================================
