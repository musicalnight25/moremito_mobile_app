import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/ticket_controller.dart';
import 'package:more_mitro_app/pages/support/ticket_comment_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../../utils/primary_text_button.dart';
import '../../model/ticket_list_model.dart';

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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: "Support Tickets".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (tc.listLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          if (tc.ticketList.isEmpty) {
            return NoDataFound(title: "Support Tickets".tr);
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              children: tc.ticketList
                  .map((ticket) => TicketItemCard(
                        ticket: ticket,
                        controller: tc,
                      ))
                  .toList(),
            ),
          );
        }),
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////
///                  TICKET CARD (100% THEME CONSISTENT)               ///
//////////////////////////////////////////////////////////////////////////

class TicketItemCard extends StatelessWidget {
  final TicketModel ticket;
  final TicketController controller;

  const TicketItemCard({
    super.key,
    required this.ticket,
    required this.controller,
  });

  // ---------------- STATUS BADGE STYLE ----------------
  Widget _statusBadge(String status) {
    Color bg;
    Color text;

    switch (status.toLowerCase()) {
      case "closed":
        bg = const Color(0xff28C76F); // green
        text = Colors.white;
        break;
      case "open":
        bg = const Color(0xffF4B740); // yellow/orange
        text = Colors.black87;
        break;
      default:
        bg = Colors.grey.shade400;
        text = Colors.white;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.sp),
      ),
      child: Text(
        status.toUpperCase(),
        style: AppTextStyle.normalSemiBold12.copyWith(color: text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isClosed = (ticket.statusValue ?? "").toLowerCase() == "closed";
    int unreadCount = ticket.unreadUser ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------------- TOP ROW (ID + DATE + BADGE) ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${ticket.ticketId}".tr,
                      style: AppTextStyle.normalSemiBold18,
                    ),
                    SizedBox(height: 4.sp),
                    Text(
                      CommonMethod.formatDateTime(ticket.createdDate),
                      style: AppTextStyle.normalRegular12
                          .copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              if (ticket.statusValue != null) _statusBadge(ticket.statusValue!),
            ],
          ),

          height14,

          // ---------------- TICKET RELATED TO ----------------
          Row(
            children: [
              Expanded(
                child: Text(
                  "Ticket Related To:".tr,
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
              ),
              Text(
                ticket.typeValue ?? "-",
                style: AppTextStyle.normalSemiBold14,
              ),
            ],
          ),

          height10,

          // ---------------- PRIORITY ----------------
          Row(
            children: [
              Expanded(
                child: Text(
                  "Priority".tr,
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
              ),
              Text(
                ticket.priorityValue ?? "-",
                style:
                    AppTextStyle.normalSemiBold14.copyWith(color: Colors.red),
              ),
            ],
          ),

          height10,

          // ---------------- SUBJECT ----------------
          Text(
            "Subject".tr,
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 4.sp),
          Text(
            ticket.ticketTitle ?? "-",
            style: AppTextStyle.normalSemiBold14,
          ),

          height16,
          Divider(color: Colors.black12, thickness: 0.5),
          height08,

          // ---------------- FOOTER ACTIONS ----------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -------- COMMENTS BUTTON --------
              InkWell(
                onTap: () {
                  ticket.unreadUser = 0;
                  controller.update();
                  Get.to(() =>
                      TicketCommentScreen(ticketId: ticket.ticketId ?? 0));
                },
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline,
                        size: 18.sp, color: primaryColor),
                    SizedBox(width: 6.sp),
                    Text(
                      unreadCount > 0 ? "Comments ($unreadCount)" : "Comments",
                      style: AppTextStyle.normalSemiBold14
                          .copyWith(color: primaryColor),
                    ),
                  ],
                ),
              ),

              // -------- RE-OPEN TICKET BUTTON --------
              if (isClosed)
                InkWell(
                  onTap: () async {
                    await controller.addComment(
                      ticketId: ticket.ticketId!,
                      comment: "Re-opening ticket",
                    );
                    controller.getTicketList();
                  },
                  child: Text(
                    "Re-open Ticket".tr,
                    style: AppTextStyle.normalSemiBold14.copyWith(
                      color: primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
            ],
          )
        ],
      ),
    );
  }
}

//////////////////////////////////////////////////////////////////////////
///                        INFO ROW (Label + Value)                    ///
//////////////////////////////////////////////////////////////////////////

class TicketInfoRow extends StatelessWidget {
  final String label;
  final String? value;

  const TicketInfoRow({
    super.key,
    required this.label,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyle.normalRegular14.copyWith(color: subTitleColor),
        ),
        const Spacer(),
        Text(
          value ?? "-",
          style: AppTextStyle.normalSemiBold14.copyWith(
            color: primaryBlack,
          ),
        ),
      ],
    );
  }
}

//////////////////////////////////////////////////////////////////////////
///        COMMENT BUTTON (Uses ONLY THEME COLORS & YOUR BUTTON)       ///
//////////////////////////////////////////////////////////////////////////

class CommentButton extends StatelessWidget {
  final int unread;
  final VoidCallback onTap;

  const CommentButton({
    super.key,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool hasUnread = unread > 0;

    return PrimaryTextButton(
      title: hasUnread ? "Comments ($unread)" : "Comments",
      buttonColor: hasUnread ? greenColor : primaryColor,
      onPressed: onTap,
    );
  }
}