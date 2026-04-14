import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/ticket_controller.dart';
import 'package:more_mitro_app/model/ticket_detail_model.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class TicketCommentScreen extends StatefulWidget {
  final int ticketId;

  const TicketCommentScreen({super.key, required this.ticketId});

  @override
  State<TicketCommentScreen> createState() => _TicketCommentScreenState();
}

class _TicketCommentScreenState extends State<TicketCommentScreen> {
  final TicketController tc = Get.find<TicketController>();

  final TextEditingController commentController = TextEditingController();
  List<File> selectedFiles = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => tc.getTicketDetails(widget.ticketId),
    );
  }

  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );

    if (result != null) {
      selectedFiles = result.paths.map((p) => File(p!)).toList();
      setState(() {});
    }
  }

  Future<void> submitComment() async {
    if (commentController.text.isEmpty) {
      CommonMethod.getXSnackBar("Warning".tr, "Enter comment".tr, redColor);
      return;
    }

    List<String> filePaths = selectedFiles.map((e) => e.path).toList();

    await tc.addComment(
      ticketId: widget.ticketId,
      comment: commentController.text,
      files: filePaths,
    );

    commentController.clear();
    selectedFiles.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: primaryWhite,
      appBar: CommonAppBar(
        title: "Ticket #{ticketId}".trParams({
          "ticketId": "${widget.ticketId}",
        }),
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (tc.detailLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final data = tc.ticketDetail.value;

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.sp, 16.sp, 16.sp, 16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _addCommentCard(),
                customHeight(26),
                Text(
                  "Previous Comments".tr,
                  style: AppTextStyle.normalSemiBold18
                      .copyWith(color: primaryBlack),
                ),
                customHeight(14),
                if (data?.ticketComments == null ||
                    data!.ticketComments!.isEmpty)
                  _noCommentsWidget()
                else
                  ...data.ticketComments!.map((c) => _commentBubble(c)),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ----------------------------------------------------------
  // NO COMMENT UI
  // ----------------------------------------------------------
  Widget _noCommentsWidget() {
    return Column(
      children: [
        customHeight(40),
        Icon(Icons.chat_bubble_outline,
            size: 50, color: textGreyColor.withOpacity(0.6)),
        customHeight(10),
        Text(
          "No comments yet".tr,
          style: AppTextStyle.normalRegular16.copyWith(
            color: textGreyColor,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------------
  // ADD COMMENT CARD
  // ----------------------------------------------------------
  Widget _addCommentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Add Comment".tr,
            style: AppTextStyle.normalSemiBold18.copyWith(
              color: primaryBlack,
            ),
          ),
          customHeight(12),
          TextFormFieldWidget(
            controller: commentController,
            hintText: "Write your comment...".tr,
            maxLines: 4,
          ),
          customHeight(16),
          Obx(
            () => tc.commentLoading.value
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  )
                : PrimaryTextButton(
                    title: "Submit Comment".tr,
                    onPressed: submitComment,
                  ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  // COMMENT BUBBLE UI (professional look)
  // ----------------------------------------------------------
  Widget _commentBubble(TicketComment c) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(16.sp),
      margin: EdgeInsets.only(bottom: 4.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Name
          Text(
            "${c.firstName ?? ''} ${c.lastName ?? ''}",
            style: AppTextStyle.normalSemiBold16.copyWith(
              color: primaryColor,
            ),
          ),

          customHeight(6),

          /// Comment text
          Text(
            c.ticketComment ?? "-",
            style: AppTextStyle.normalRegular14.copyWith(
              height: 1.4,
              color: lightBlackColor,
            ),
          ),

          customHeight(12),

          /// Date
          Text(
            CommonMethod.formatDateTime(c.createdDate),
            style: AppTextStyle.normalRegular12.copyWith(
              color: textGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}
