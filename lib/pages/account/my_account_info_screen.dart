// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:more_mitro_app/utils/app_text_style.dart';
// import 'package:more_mitro_app/utils/colors.dart';
// import 'package:more_mitro_app/utils/common_app_bar.dart';
// import 'package:more_mitro_app/utils/primary_text_button.dart';
// import 'package:more_mitro_app/utils/static_decoration.dart';
//
// class MyAccountInfoScreen extends StatelessWidget {
//   const MyAccountInfoScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryWhite,
//       appBar: CommonAppBar(
//         title: "My Account Information",
//         visibleBackButton: true,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16.sp),
//         child: Column(
//           children: [
//             _card(
//               title: "My Information",
//               children: [
//                 _infoRow("Username", "shubham"),
//                 _infoRow("Text Message Code", "SK13"),
//                 _infoRow("First Name", "Shubham"),
//                 _infoRow("Last Name", "Kumar1"),
//                 _infoRow("Email", "shubham_shandil@outlook.com"),
//                 _infoRow("Phone", "919812503572"),
//                 _infoRow("Membership Type", "Paid Representative"),
//                 _infoRow("Join Date", "2022/05/22"),
//                 _infoRow("WhatsApp Phone", "123456788"),
//                 height10,
//                 PrimaryTextButton(
//                   title: "Edit",
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             height16,
//             _card(
//               title: "Manage Your Addresses",
//               children: [
//                 Text(
//                   "Note: Changing your address here does not change your address on already created recurring orders. Go to Orders → Recurring Orders to do that.",
//                   style: AppTextStyle.normalRegular12.copyWith(
//                     color: redColor,
//                     fontSize: 12.sp,
//                   ),
//                 ),
//                 height14,
//                 _infoRow("Address", "14105 E 19th Ave"),
//                 _infoRow("City", "Spokane Valley"),
//                 _infoRow("Country", "USA"),
//                 _infoRow("State", "Washington"),
//                 _infoRow("Zip", "99037"),
//                 height10,
//                 PrimaryTextButton(
//                   title: "Edit Address",
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             height16,
//             _card(
//               title: "Your Website Header Display",
//               children: [
//                 _infoRow("Name", "Shubham Kumar alias1"),
//                 _infoRow("Email", "shubham_shandil_1@outlook.com"),
//                 _infoRow("Phone", "9812503573"),
//                 _infoRow("State", "Washington"),
//                 _infoRow("Zip", "99037"),
//                 height10,
//                 PrimaryTextButton(
//                   title: "Edit",
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//             height20,
//           ],
//         ),
//       ),
//     );
//   }
//
//   ////////////////////////////////////////////////////////////////////////////
//   ///                     CARD CONTAINER (Unified Design)
//   ////////////////////////////////////////////////////////////////////////////
//   Widget _card({
//     required String title,
//     required List<Widget> children,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(18.sp),
//       decoration: BoxDecoration(
//         color: primaryWhite,
//         borderRadius: BorderRadius.circular(16.sp),
//         border: Border.all(color: borderGreyColor),
//         boxShadow: [
//           BoxShadow(
//             color: bgPrimaryShadowColor.withOpacity(.5),
//             blurRadius: 14,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: AppTextStyle.normalSemiBold18.copyWith(
//               color: primaryBlack,
//             ),
//           ),
//           height14,
//           ...children,
//         ],
//       ),
//     );
//   }
//
//   ////////////////////////////////////////////////////////////////////////////
//   ///                          INFO ROW (Label + Value)
//   ////////////////////////////////////////////////////////////////////////////
//   Widget _infoRow(String label, String value) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 12.sp),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: AppTextStyle.normalRegular14.copyWith(
//               color: subTitleColor,
//             ),
//           ),
//           height04,
//           Text(
//             value,
//             style: AppTextStyle.normalSemiBold16.copyWith(
//               color: primaryBlack,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
