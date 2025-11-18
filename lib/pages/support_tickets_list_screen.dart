import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/ticket_controller.dart';
import 'package:more_mitro_app/pages/ticket_detail_screen.dart';
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

  // ===================== SUPPORT TICKET CARD =====================
  Widget _ticketCard(TicketModel t) {
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
          Text(
            "#${t.ticketId}",
            style: AppTextStyle.normalBold16.copyWith(fontSize: 18.sp),
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

          /// BUTTON ROW
          Row(
            children: [
              _greenButton("Comments", () {
                Get.to(
                    () => TicketDetailScreen(ticketId: t.ticketId.toString()));
              }),
              customWidth(12),
              _greenButton("Re-open Ticket", () async {
                await _handleReopen(t.ticketId);
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== ROW ITEM =====================
  Widget _ticketRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  // ===================== GREEN BUTTON =====================
  Widget _greenButton(String title, VoidCallback onTap) {
    return Expanded(
      child: PrimaryTextButton(
        onPressed: onTap,
        title: title,
      ),
    );
  }

  // ===================== REOPEN TICKET =====================
  Future<void> _handleReopen(int? ticketId) async {
    if (ticketId == null) return;

    // API supports reopening via addTicketComment with specific status
    final ok = await tc.addComment(
      ticketId: ticketId,
      comment: "Reopening ticket",
    );
  }
}
