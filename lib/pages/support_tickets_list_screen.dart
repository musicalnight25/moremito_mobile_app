import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/ticket_controller.dart';
import 'package:more_mitro_app/pages/ticket_comment_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../model/ticket_list_model.dart';

class SupportTicketsListScreen extends StatefulWidget {
  @override
  State<SupportTicketsListScreen> createState() =>
      _SupportTicketsListScreenState();
}

class _SupportTicketsListScreenState extends State<SupportTicketsListScreen> {
  final TicketController tc = Get.put(TicketController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tc.getTicketList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CommonAppBar(
        title: "Support Tickets List",
        visibleBackButton: true,
      ),
      body: Obx(() {
        if (tc.listLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (tc.ticketList.isEmpty) {
          return const NoDataFound(title: "Support Tickets");
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            children:
                tc.ticketList.map((ticket) => _ticketCard(ticket)).toList(),
          ),
        );
      }),
    );
  }

  // ======================================================
  //                 INDIVIDUAL TICKET CARD
  // ======================================================
  Widget _ticketCard(TicketModel t) {
    final int unread = t.unreadUser ?? 0;
    final bool isClosed = (t.statusValue ?? "").toLowerCase() == "closed";

    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Ticket ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ticket ID",
                style: AppTextStyle.normalBold16,
              ),
              Text(
                "${t.ticketId}",
                style: AppTextStyle.normalBold16.copyWith(
                  color: primaryColor,
                  fontSize: 18.sp,
                ),
              ),
            ],
          ),

          customHeight(12),
          _ticketRow("Subject", t.ticketTitle ?? "-"),
          customHeight(12),
          _ticketRow("Priority", t.priorityValue ?? "-"),
          customHeight(12),
          _ticketRow("Status", t.statusValue ?? "-"),
          customHeight(12),
          _ticketRow("Ticket Related To", t.typeValue ?? "-"),
          customHeight(12),
          _ticketRow(
              "Created Date", CommonMethod.formatDateTime(t.createdDate)),
          customHeight(20),

          // ======================================================
          //                      ACTION BUTTONS
          // ======================================================
          Row(
            children: [
              Expanded(
                child: _commentsButton(
                  unreadCount: unread,
                  onTap: () {
                    // Mark unread = 0 on open (optional logic)
                    t.unreadUser = 0;
                    tc.update();

                    Get.to(
                        () => TicketCommentScreen(ticketId: t.ticketId ?? 0));
                  },
                ),
              ),
              customWidth(12),
              if (isClosed)
                Expanded(
                  child: PrimaryTextButton(
                    title: "Re-open Ticket",
                    buttonColor: blueColor,
                    onPressed: () => _handleReopen(t.ticketId),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ======================================================
  //                  COMMENT BUTTON WITH BADGE
  // ======================================================
  Widget _commentsButton({
    required int unreadCount,
    required VoidCallback onTap,
  }) {
    bool hasUnread = unreadCount > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13.sp),
        decoration: BoxDecoration(
          color: hasUnread ? greenColor : primaryColor,
          borderRadius: BorderRadius.circular(10.sp),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Comments",
              style: AppTextStyle.normalBold14.copyWith(color: Colors.white),
            ),
            if (hasUnread) ...[
              customWidth(8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: AppTextStyle.normalBold14.copyWith(
                    color: greenColor,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ======================================================
  //                  ROW FOR KEY - VALUE PAIR
  // ======================================================
  Widget _ticketRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.black87),
          ),
        ),
        Expanded(
          flex: 4,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyle.normalBold14.copyWith(color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // ======================================================
  //                     REOPEN TICKET LOGIC
  // ======================================================
  Future<void> _handleReopen(int? ticketId) async {
    if (ticketId == null) return;

    await tc.addComment(
      ticketId: ticketId,
      comment: "Reopening ticket",
    );

    tc.getTicketList(); // Refresh list
  }
}
