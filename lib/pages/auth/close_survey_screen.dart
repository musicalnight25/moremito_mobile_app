// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:more_mitro_app/utils/app_text_style.dart';
// import 'package:more_mitro_app/utils/base_background_widget.dart';
// import 'package:more_mitro_app/utils/colors.dart';
// import 'package:more_mitro_app/utils/input_text_field_widget.dart';
// import 'package:more_mitro_app/utils/primary_text_button.dart';
// import 'package:more_mitro_app/utils/static_decoration.dart';
//
// import '../../controller/login_controller.dart';
// import '../../utils/common_app_bar.dart';
// import '../main_dashboard_screen.dart';
//
// class CloseSurveyScreen extends StatelessWidget {
//   CloseSurveyScreen({Key? key}) : super(key: key);
//
//   var controller = Get.put(LoginController());
//   TextEditingController reviewTextController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       appBar: CommonAppBar(),
//       bottomNavigationBar: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.sp),
//             child: Obx(
//               () => PrimaryTextButton(
//                   buttonColor: controller.selectedAnswersList.isNotEmpty
//                       ? null
//                       : disableButtonColor,
//                   title: "Close",
//                   onPressed: () async {
//                     await controller.saveSurvey(context);
//                   }),
//             ),
//           ),
//           customHeight(56)
//         ],
//       ),
//       body: BaseBackgroundWidget(
//           child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           height20,
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.sp),
//             child: Text(
//               "Thank you!",
//               style: AppTextStyle.normalExtraBold,
//             ),
//           ),
//           height05,
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 16.sp),
//             child: Text(
//               'Thanks for taking the time to tell us your thoughts, it means a lot to us.\nIf you have anymore to share, please add it below.',
//               style:
//                   AppTextStyle.normalRegular16.copyWith(color: lightBlackColor),
//               textAlign: TextAlign.start,
//             ),
//           ),
//           height20,
//           Expanded(
//             child: ListView(
//                 padding: EdgeInsets.symmetric(horizontal: 16.sp),
//                 children: [
//                   TextFormFieldWidget(
//                     controller: reviewTextController,
//                     hintText: "Penny for your thoughts?",
//                     maxLines: 8,
//                   )
//                 ]),
//           ),
//           height20,
//         ],
//       )),
//     );
//   }
// }
