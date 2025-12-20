import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';

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
        title: "TMRIS Leads",
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
                _archiveTabs(),
                height16,
                if (controller.isLoading.value)
                  ...List.generate(6, (_) => const NotificationShimmerCard()),
                if (!controller.isLoading.value && controller.leadList.isEmpty)
                  NoDataFound(),
                ...controller.leadList.map(_leadCard),
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

  // ───────────────── LEAD CARD ─────────────────

  Widget _leadCard(TmrisLeadModel lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.sp),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: borderGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Text(
                "Name: ${lead.name ?? ""}",
                style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
              ),
              const Spacer(),
              Text(
                CommonMethod.formatDateFromDateTime(
                  lead.createdDate,
                ),
                style:
                    AppTextStyle.normalRegular12.copyWith(color: hintGreyColor),
              ),
            ],
          ),

          Divider(height: 22),

          /// INFO ROW 1
          Row(
            children: [
              _infoItem("Phone", lead.phone),
              Spacer(),
              _infoItem("Email", lead.email),
            ],
          ),
          height08,

          /// INFO ROW 2
          Row(
            children: [
              _infoItem("Call me", lead.contactMe == true ? "Yes" : "No"),
              Spacer(),
              _infoItem("Interest", lead.pageType),
            ],
          ),

          height12,

          /// NOTES
          if ((lead.notes ?? "").isNotEmpty)
            Container(
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
                lead.notes!,
                style: AppTextStyle.normalRegular14,
              ),
            ),

          height12,

          /// ACTION
          Align(
            alignment: Alignment.centerLeft,
            child: PrimaryTextButton(
              onPressed: () {
                Get.to(
                  () => TmrisLeadDetailsScreen(lead: lead),
                );
              },
              title: "View Details",
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyle.normalBold14),
        height04,
        Text(value ?? "-", style: AppTextStyle.normalRegular14),
      ],
    );
  }
}
