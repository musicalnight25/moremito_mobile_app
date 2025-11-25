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

  // ---------------------------- PICK FILES ----------------------------
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

  // ---------------------------- SUBMIT COMMENT ----------------------------
  Future<void> submitComment() async {
    if (commentController.text.isEmpty) {
      CommonMethod.getXSnackBar("Warning", "Enter comment", redColor);
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
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: "Ticket No. ${widget.ticketId}",
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
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAddCommentCard(),
                customHeight(20),
                Text("Previous Comments", style: AppTextStyle.normalSemiBold16),
                customHeight(12),
                if (data == null ||
                    data.ticketComments == null ||
                    data.ticketComments!.isEmpty)
                  const Center(child: Text("No comments found")),
                ...?data?.ticketComments?.map((c) => _buildCommentCard(c)),
                customHeight(20),
                PrimaryTextButton(
                  title: "Close This Page",
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------------------- ADD COMMENT BOX ----------------------------
  Widget _buildAddCommentCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add New Comment", style: AppTextStyle.normalSemiBold16),
          customHeight(12),
          TextFormFieldWidget(
            controller: commentController,
            hintText: "Write your comment...",
            maxLines: 4,
            labelText: "Comment:",
          ),
          // customHeight(12),
          // Row(
          //   children: [
          //     PrimaryTextButton(
          //       title: "Choose Files",
          //       onPressed: pickFiles,
          //       height: 40.sp,
          //       width: 150.sp,
          //     ),
          //     customWidth(10),
          //     Text(
          //       selectedFiles.isEmpty
          //           ? "No file selected"
          //           : "${selectedFiles.length} files selected",
          //       style: AppTextStyle.normalRegular14,
          //     )
          //   ],
          // ),
          customHeight(16),
          Obx(
            () => tc.commentLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  )
                : PrimaryTextButton(
                    title: "Add Comment",
                    onPressed: submitComment,
                  ),
          ),
        ],
      ),
    );
  }

  // ---------------------------- COMMENT CARD ----------------------------
  Widget _buildCommentCard(TicketComment c) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      margin: EdgeInsets.only(bottom: 16.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Name:",
              "${c.firstName ?? ''} ${c.lastName ?? ''} (${c.username ?? ''})"),
          customHeight(8),
          _row("Contact:", "${c.email ?? ''} / ${c.phone ?? ''}"),
          customHeight(8),
          _row("Comment:", c.ticketComment ?? "-"),
          customHeight(10),
          // if (c.fileDetails != null && c.fileDetails!.isNotEmpty)
          //   Column(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Text("Attachments:",
          //           style: AppTextStyle.normalBold14
          //               .copyWith(color: Colors.black)),
          //       customHeight(6),
          //       ...c.fileDetails!.map(
          //         (f) => GestureDetector(
          //           onTap: () => CommonMethod.openUrl(f.filePath ?? ""),
          //           child: Padding(
          //             padding: EdgeInsets.only(bottom: 6.sp),
          //             child: Text(
          //               f.fileName ?? "File",
          //               style: AppTextStyle.normalRegular14.copyWith(
          //                 color: primaryColor,
          //                 decoration: TextDecoration.underline,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     ],
          //   )
          // else
          //   _row("Attachments:", "None"),
          // customHeight(12),
          Text(
            CommonMethod.formatDateTime(c.createdDate),
            style: AppTextStyle.normalRegular12.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // ---------------------------- KEY-VALUE ROW ----------------------------
  Widget _row(String title, String value) {
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
}
