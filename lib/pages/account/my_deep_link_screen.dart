// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:more_mitro_app/utils/app_text_style.dart';
// import 'package:more_mitro_app/utils/base_background_widget.dart';
// import 'package:more_mitro_app/utils/colors.dart';
// import 'package:more_mitro_app/utils/common_app_bar.dart';
// import 'package:more_mitro_app/utils/static_decoration.dart';
//
// class MyDeepLinkScreen extends StatelessWidget {
//   final String link; // pass deep link from API
//
//   MyDeepLinkScreen({Key? key, required this.link}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: CommonAppBar(
//         title: "My Deep link",
//         visibleBackButton: true,
//       ),
//       body: BaseBackgroundWidget(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.all(16.sp),
//           child: Container(
//             padding: EdgeInsets.all(16.sp),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.sp),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black12,
//                   blurRadius: 4,
//                   offset: Offset(0, 2),
//                 )
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// Title
//                 Text(
//                   "Join as Referring Customer",
//                   style: AppTextStyle.normalBold16,
//                 ),
//
//                 customHeight(12),
//
//                 /// Deep Link text
//                 GestureDetector(
//                   onTap: () {
//                     Clipboard.setData(ClipboardData(text: link));
//                     Get.snackbar("Copied", "Link copied to clipboard",
//                         snackPosition: SnackPosition.BOTTOM);
//                   },
//                   child: Text(
//                     link,
//                     style: TextStyle(
//                       color: Colors.green,
//                       fontSize: 15.sp,
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//
//                 customHeight(16),
//
//                 /// Copy Button
//                 SizedBox(
//                   width: double.infinity,
//                   height: 48.sp,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Clipboard.setData(ClipboardData(text: link));
//                       Get.snackbar(
//                         "Copied",
//                         "Link copied to clipboard",
//                         snackPosition: SnackPosition.BOTTOM,
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.sp),
//                       ),
//                     ),
//                     child: Text(
//                       "Copy Link",
//                       style: AppTextStyle.normalBold16.copyWith(
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 customHeight(16),
//
//                 /// Description
//                 Text(
//                   "You can copy and paste this link into an email, social "
//                       "media post, or text message. When someone clicks on "
//                       "this link they will visit your page. When they join, "
//                       "you will see them in your group.",
//                   style: AppTextStyle.normalRegular14.copyWith(
//                     color: Colors.black87,
//                     height: 1.4,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
