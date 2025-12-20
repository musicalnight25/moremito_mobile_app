import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';

import '../../controller/my_lead_controller.dart';
import '../../model/lead_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/static_decoration.dart';

class LeadDetailsScreen extends StatelessWidget {
  final LeadModel lead;

  const LeadDetailsScreen({
    super.key,
    required this.lead,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MyLeadController>();

    return Scaffold(
      appBar: CommonAppBar(
        title: "Lead Details",
        visibleBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Basic Information"),
            _detailRow("Name", lead.name),
            _detailRow("Phone", lead.phone),
            _detailRow("Email", lead.email),
            _detailRow("Web Page Name", lead.pageType),

            height20,

            _sectionTitle("Submission"),
            _detailRow(
              "Submitted",
              CommonMethod.formatFullDateFromDateTime(
                lead.createdDate,
              ),
            ),
            _detailRow("Call Me", lead.contactMe == true ? "Yes" : "No"),

            height20,

            _sectionTitle("Notes"),
            _notesBox(lead.notes),

            height20,

            _sectionTitle("Contact Status"),
            _detailRow(
              "Contacted",
              lead.isContacted == true ? "Yes" : "No",
            ),
            _detailRow(
              "Contacted Date",
              CommonMethod.formatFullDateFromDateTime(
                lead.contactedDate,
              ),
            ),

            height30,

            /// ACTIONS
            Row(
              children: [
                Expanded(
                  child: PrimaryTextButton(
                    title: controller.isArchivedTab.value
                        ? "Unarchive"
                        : "Archive",
                    onPressed: () {
                      controller.toggleArchive(
                        lead.id!,
                        !controller.isArchivedTab.value,
                      );
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── UI HELPERS ─────────────────

  Widget _sectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Text(
        title,
        style: AppTextStyle.normalBold16.copyWith(
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _notesBox(String? notes) {
    if ((notes ?? "").isEmpty) {
      return Text("-", style: AppTextStyle.normalRegular14);
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: bgPrimaryShadowColor,
        borderRadius: BorderRadius.circular(8.sp),
        border: Border(
          left: BorderSide(color: primaryColor, width: 3),
        ),
      ),
      child: Text(
        notes!,
        style: AppTextStyle.normalRegular14,
      ),
    );
  }

  Widget _detailRow(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.sp,
            child: Text(
              "$label:",
              style: AppTextStyle.normalBold14,
            ),
          ),
          Expanded(
            child: Text(
              value ?? "-",
              style: AppTextStyle.normalRegular14,
            ),
          ),
        ],
      ),
    );
  }
}
