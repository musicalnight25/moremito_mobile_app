import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';

import '../../controller/tmris_lead_controller.dart';
import '../../model/tmris_lead_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/no_data_found.dart';
import '../../utils/static_decoration.dart';
import '../notification/widget/notification_shimmer_card.dart';
import 'tmris_lead_details_screen.dart';

class TmrisLeadsScreen extends StatefulWidget {
  const TmrisLeadsScreen({super.key});

  @override
  State<TmrisLeadsScreen> createState() => _TmrisLeadsScreenState();
}

class _TmrisLeadsScreenState extends State<TmrisLeadsScreen> {
  final controller = Get.put(TmrisLeadController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initialLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "TMRIS Leads".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: controller.refreshLeads,
            color: primaryColor,
            child: ListView(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 18.sp),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                height20,

                /// ───── ARCHIVE TABS ─────
                _archiveTabs(),
                height16,

                /// ───── LOADING ─────
                if (controller.isLoading.value)
                  ...List.generate(6, (_) => const NotificationShimmerCard()),

                /// ───── EMPTY ─────
                if (!controller.isLoading.value && controller.leadList.isEmpty)
                  const NoDataFound(),

                /// ───── LIST ─────
                ...controller.leadList.map(_leadCard),

                /// ───── PAGINATION ─────
                if (controller.isPaginationLoading.value)
                  ...List.generate(2, (_) => const NotificationShimmerCard()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── ARCHIVE TABS ─────────────────

  Widget _archiveTabs() {
    return Obx(
      () => Row(
        children: [
          _tab("Active Leads", false),
          width10,
          _tab("Archived Leads", true),
        ],
      ),
    );
  }

  Widget _tab(String text, bool archived) {
    final selected = controller.isArchivedTab.value == archived;

    return GestureDetector(
      onTap: () => controller.changeArchiveTab(archived),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 18.sp, vertical: 8.sp),
        decoration: BoxDecoration(
          color: selected ? primaryColor : primaryColor.withOpacity(.12),
          borderRadius: BorderRadius.circular(30.sp),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? Colors.white : primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ───────────────── LEAD CARD (PRO / VERTICAL) ─────────────────

  Widget _leadCard(TmrisLeadModel lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ───── HEADER ─────
          Text(
            lead.name ?? "—",
            style: AppTextStyle.normalSemiBold18.copyWith(
              color: primaryColor,
            ),
          ),
          height04,
          if (lead.createdDate != null)
            Text(
              CommonMethod.formatDateFromDateTime(lead.createdDate),
              style:
                  AppTextStyle.normalRegular12.copyWith(color: hintGreyColor),
            ),

          height14,

          /// ───── INFO ─────
          _verticalInfo("Phone Number", lead.phone),
          height10,
          _verticalInfo("Email Address", lead.email),
          height10,
          _verticalInfo("Call Me", lead.contactMe == true ? "Yes" : "No"),
          height10,
          _verticalInfo("Interest", lead.pageType),

          /// ───── NOTES ─────
          if ((lead.notes ?? "").isNotEmpty) ...[
            height16,
            _notesSection(lead.notes),
          ],

          height18,

          /// ───── ACTION ─────
          TextPrimaryButton(
            onPressed: () {
              Get.to(() => TmrisLeadDetailsScreen(lead: lead));
            },
            title: "View Details".tr,
          ),
        ],
      ),
    );
  }

  // ───────────────── NOTES SECTION ─────────────────

  Widget _notesSection(String? notes) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: bgPrimaryShadowColor,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: borderGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              width10,
              Text(
                "Notes".tr,
                style:
                    AppTextStyle.normalSemiBold14.copyWith(color: primaryBlack),
              ),
            ],
          ),
          height10,
          Text(
            notes ?? "",
            style: AppTextStyle.normalRegular14.copyWith(
              color: primaryBlack,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── VERTICAL INFO ─────────────────

  Widget _verticalInfo(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.normalRegular12.copyWith(color: hintGreyColor),
        ),
        height04,
        Text(
          (value == null || value.isEmpty) ? "—" : value,
          style: AppTextStyle.normalRegular14.copyWith(color: primaryBlack),
        ),
      ],
    );
  }
}