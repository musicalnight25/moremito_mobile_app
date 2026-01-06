import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/marketing/tmris_info_screen.dart';
import 'package:more_mitro_app/pages/marketing/widget/lead_card_shimmer.dart';

import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';

import '../../controller/my_lead_controller.dart';
import '../../model/lead_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/no_data_found.dart';
import '../../utils/static_decoration.dart';
import 'lead_details_screen.dart';

class MyLeadsScreen extends StatefulWidget {
  const MyLeadsScreen({super.key});

  @override
  State<MyLeadsScreen> createState() => _MyLeadsScreenState();
}

class _MyLeadsScreenState extends State<MyLeadsScreen> {
  final controller = Get.put(MyLeadController());

  @override
  void initState() {
    super.initState();
    refreshPage();
  }

  refreshPage() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.initialLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: controller.refreshLeads,
            color: primaryColor,
            child: ListView(
              controller: controller.scrollController,
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                height20,
                Text(
                  "My Leads",
                  style: AppTextStyle.normalExtraBold.copyWith(fontSize: 26.sp),
                ),
                height08,
                _infoText(),
                height16,
                _archiveTabs(),
                height20,
                if (controller.isLoading.value)
                  ...List.generate(6, (_) => const LeadCardShimmer()),
                if (!controller.isLoading.value && controller.leadList.isEmpty)
                  const NoDataFound(),
                ...controller.leadList.map(_leadCard),
                if (controller.isPaginationLoading.value)
                  ...List.generate(2, (_) => const LeadCardShimmer()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── INFO TEXT ─────────────────

  Widget _infoText() {
    return RichText(
      text: TextSpan(
        style: AppTextStyle.normalRegular14.copyWith(
          color: hintGreyColor,
          height: 1.4,
        ),
        children: [
          const TextSpan(
            text: "The following prospect data comes directly from the ",
          ),
          TextSpan(
            text: "Text Message Request Info System",
            style: AppTextStyle.normalSemiBold14.copyWith(
              color: primaryColor,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.to(() => TmrisInfoScreen());
              },
          ),
          const TextSpan(
            text:
                ". The system captures prospect data and stores the data here for future reference.",
          ),
        ],
      ),
    );
  }

  Widget _archiveTabs() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(4.sp),
        decoration: BoxDecoration(
          color: primaryColor.withOpacity(.06),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _tab("Active Leads", false),
            _tab("Archived", true),
          ],
        ),
      ),
    );
  }

  Widget _tab(String text, bool archived) {
    final selected = controller.isArchivedTab.value == archived;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeArchiveTab(archived),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(
            horizontal: 16.sp,
            vertical: 8.sp,
          ),
          margin: EdgeInsets.symmetric(horizontal: 2.sp),
          decoration: BoxDecoration(
            color: selected ? primaryWhite : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: selected ? primaryColor : hintGreyColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ───────────────── VERTICAL LEAD CARD ─────────────────

  Widget _leadCard(LeadModel lead) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: borderGreyColor.withOpacity(.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// NAME + STATUS
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  lead.name ?? "-",
                  style: AppTextStyle.normalSemiBold18
                      .copyWith(color: primaryColor),
                ),
              ),
              if (lead.isContacted == true) _contactedBadge(),
            ],
          ),

          height06,
          Text(
            CommonMethod.formatDateFromDateTime(lead.createdDate),
            style: AppTextStyle.normalRegular12.copyWith(color: hintGreyColor),
          ),

          Divider(height: 22.sp),

          _verticalItem("Phone", lead.phone),
          _verticalItem("Email", lead.email),
          _verticalItem("Call me", lead.contactMe == true ? "Yes" : "No"),
          _verticalItem("Interest", lead.pageType),

          if ((lead.notes ?? "").isNotEmpty) ...[
            height16,
            _highlightBox("Message from Lead", lead.notes!),
          ],

          if ((lead.adminNotes ?? "").isNotEmpty) ...[
            height12,
            _highlightBox("My Notes about this lead", lead.adminNotes!),
          ],

          height18,

          TextPrimaryButton(
            title: "View Details",
            onPressed: () {
              Get.to(() => LeadDetailsScreen(lead: lead))!.then((value) {
                refreshPage();
              });
            },
          ),
        ],
      ),
    );
  }

  // ───────────────── SMALL WIDGETS ─────────────────

  Widget _verticalItem(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyle.normalRegular12.copyWith(color: hintGreyColor),
          ),
          height04,
          Text(
            value ?? "-",
            style: AppTextStyle.normalRegular15,
          ),
        ],
      ),
    );
  }

  Widget _highlightBox(String title, String value) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.sp),
      decoration: BoxDecoration(
        color: bgPrimaryShadowColor,
        borderRadius: BorderRadius.circular(10),
        border: Border(
          left: BorderSide(color: primaryColor, width: 3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.normalSemiBold14.copyWith(color: primaryColor),
          ),
          height06,
          Text(
            value,
            style: AppTextStyle.normalRegular14.copyWith(height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _contactedBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.sp, vertical: 4.sp),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        "Contacted",
        style: TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
