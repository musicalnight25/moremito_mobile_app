import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/ticket_controller.dart';
import 'package:more_mitro_app/pages/support/ticket_comment_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
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
      backgroundColor: primaryWhite,
      appBar: CommonAppBar(
        title: "Support Tickets",
        visibleBackButton: true,
      ),
      body: Obx(() {
        if (tc.listLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }

        if (tc.ticketList.isEmpty) {
          return const NoDataFound(title: "Support Tickets");
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

  @override
  Widget build(BuildContext context) {
    bool isClosed = (ticket.statusValue ?? '').toLowerCase() == "closed";
    int unread = ticket.unreadUser ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(.6),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER : Ticket ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Ticket ID",
                  style: AppTextStyle.normalSemiBold16
                      .copyWith(color: primaryBlack)),
              Text(
                "#${ticket.ticketId}",
                style:
                    AppTextStyle.normalSemiBold18.copyWith(color: primaryColor),
              ),
            ],
          ),

          height14,

          TicketInfoRow(label: "Subject", value: ticket.ticketTitle),
          height10,
          TicketInfoRow(label: "Priority", value: ticket.priorityValue),
          height10,
          TicketInfoRow(label: "Status", value: ticket.statusValue),
          height10,
          TicketInfoRow(label: "Related To", value: ticket.typeValue),
          height10,
          TicketInfoRow(
            label: "Created",
            value: CommonMethod.formatDateTime(ticket.createdDate),
          ),

          height20,

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: CommentButton(
                  unread: unread,
                  onTap: () {
                    ticket.unreadUser = 0;
                    controller.update();
                    Get.to(() =>
                        TicketCommentScreen(ticketId: ticket.ticketId ?? 0));
                  },
                ),
              ),
              if (isClosed) ...[
                width14,
                Expanded(
                  child: PrimaryTextButton(
                    title: "Re-open",
                    buttonColor: blueColor,
                    onPressed: () async {
                      await controller.addComment(
                        ticketId: ticket.ticketId!,
                        comment: "Re-opening ticket",
                      );
                      controller.getTicketList();
                    },
                  ),
                ),
              ],
            ],
          ),
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
