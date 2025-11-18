import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../controller/ticket_controller.dart';
import '../model/ticket_detail_model.dart';

class TicketDetailScreen extends StatelessWidget {
  var ticketId;
  final TicketController tc = Get.find<TicketController>();

  TicketDetailScreen({Key? key, required this.ticketId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    tc.getTicketDetails(ticketId); // 🔥 Load comments on open

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Ticket No. $ticketId",
        visibleBackButton: true,
      ),
      body: Obx(() {
        if (tc.detailLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = tc.ticketDetail.value;

        if (data == null ||
            data.ticketComments == null ||
            data.ticketComments!.isEmpty) {
          return const NoDataFound(title: "Ticket Messages");
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children: [
              ...data.ticketComments!.map((c) => _messageCard(c)).toList(),
              customHeight(10),
              _closeButton()
            ],
          ),
        );
      }),
    );
  }

  // ---------------------------------------------------------------------------
  // 🟩 Message Card (Admin/User)
  // ---------------------------------------------------------------------------
  Widget _messageCard(TicketComment comment) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _textRow("Name:",
              "${comment.firstName ?? ""} ${comment.lastName ?? ""} (${comment.username ?? ""})"),
          customHeight(10),
          _textRow(
              "Contact:", "${comment.email ?? ''} / ${comment.phone ?? ''}"),
          customHeight(10),
          _textRow("Comment:", comment.ticketComment ?? "-"),
          customHeight(10),
          // _attachments(comment),
          customHeight(12),
          Text(
            CommonMethod.formatDateTime(comment.createdDate),
            style: AppTextStyle.normalBold14.copyWith(
              color: Colors.black54,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🟦 Attachments
  // ---------------------------------------------------------------------------
  // Widget _attachments(TicketComment c) {
  //   if (c.fileDetails == null || c.fileDetails!.isEmpty) {
  //     return _textRow("Attachments:", "None");
  //   }
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text("Attachments:",
  //           style: AppTextStyle.normalBold14.copyWith(color: Colors.black)),
  //       customHeight(6),
  //       ...c.fileDetails!.map((f) => GestureDetector(
  //             onTap: () {
  //               // TODO: open file link
  //             },
  //             child: Text(
  //               f.fileName ?? "Attachment",
  //               style: AppTextStyle.normalRegular14.copyWith(
  //                 color: primaryColor,
  //                 decoration: TextDecoration.underline,
  //               ),
  //             ),
  //           ))
  //     ],
  //   );
  // }

  // ---------------------------------------------------------------------------
  // 🔹 Key-value Text Row
  // ---------------------------------------------------------------------------
  Widget _textRow(String title, String value) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$title ",
            style: AppTextStyle.normalBold14.copyWith(color: Colors.black),
          ),
          TextSpan(
            text: value,
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 🔘 Close Button
  // ---------------------------------------------------------------------------
  Widget _closeButton() {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 14.sp),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12.sp),
        ),
        alignment: Alignment.center,
        child: Text(
          "Close This Page",
          style: AppTextStyle.normalSemiBold16.copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
