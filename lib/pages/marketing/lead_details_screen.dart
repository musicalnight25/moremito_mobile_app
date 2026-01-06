import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

// Ensure these paths are correct for your project
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';
import '../../controller/my_lead_controller.dart';
import '../../model/lead_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_method.dart';
import '../../utils/static_decoration.dart';
import '../../utils/primary_text_button.dart';

class LeadDetailsScreen extends StatefulWidget {
  final LeadModel lead;

  const LeadDetailsScreen({super.key, required this.lead});

  @override
  State<LeadDetailsScreen> createState() => _LeadDetailsScreenState();
}

class _LeadDetailsScreenState extends State<LeadDetailsScreen> {
  final MyLeadController controller = Get.find<MyLeadController>();

  late final Rx<LeadModel> rxLead;
  late final TextEditingController notesController;

  final RxBool isSaving = false.obs;
  final RxBool isMarking = false.obs;

  @override
  void initState() {
    super.initState();
    rxLead = widget.lead.obs;
    notesController = TextEditingController(text: widget.lead.adminNotes ?? "");
  }

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: "Lead Details",
        visibleBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(18.sp),
        child: Obx(
          () {
            final lead = rxLead.value;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _section("Basic Information"),
                _row("Name", lead.name),
                _row("Phone", lead.phone),
                _row("Email", lead.email),
                height20,

                _section("Submission"),
                _row(
                  "Submitted",
                  CommonMethod.formatFullDateFromDateTime(lead.createdDate),
                ),
                _row("Call Me", lead.contactMe == true ? "Yes" : "No"),

                // --- ADDED: Message from Lead Highlight Box ---
                if ((lead.notes ?? "").isNotEmpty) ...[
                  height16,
                  _highlightBox("Message from Lead", lead.notes!),
                ],
                // ----------------------------------------------

                height20,
                _section("Contact Status"),
                _row("Contacted", lead.isContacted == true ? "Yes" : "No"),
                _row(
                  "Contacted Date",
                  lead.contactedDate != null
                      ? CommonMethod.formatFullDateFromDateTime(
                          lead.contactedDate,
                        )
                      : "-",
                ),
                height20,

                _section("My Notes about this lead"),
                _notesField(),
                height14,
                _saveNoteButton(),
                height30,
                _actionButtons(),
              ],
            );
          },
        ),
      ),
    );
  }

  // ───────────────── UI HELPERS ─────────────────

  Widget _section(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: Text(
        title,
        style: AppTextStyle.normalBold16.copyWith(color: primaryColor),
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Aligns text to top if multiline
        children: [
          SizedBox(
            width: 130.sp,
            child: Text("$label:", style: AppTextStyle.normalBold14),
          ),
          Expanded(
            child: Text(value ?? "-", style: AppTextStyle.normalRegular14),
          ),
        ],
      ),
    );
  }

  /// ✅ New Highlight Box Widget
  Widget _highlightBox(String label, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: bgPrimaryShadowColor, // Using your app's light blue/shadow color
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: primaryColor.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.message_rounded, size: 14.sp, color: primaryColor),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTextStyle.normalSemiBold12.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            content,
            style: AppTextStyle.normalRegular14.copyWith(
              color: lightBlackColor,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _notesField() {
    return TextFormFieldWidget(
      controller: notesController,
      maxLines: 6,
      hintText: "Enter internal notes",
    );
  }

  Widget _saveNoteButton() {
    return Center(
      child: TextPrimaryButton(
        title: isSaving.value ? "Saving..." : "Save Note",
        onPressed: isSaving.value
            ? null
            : () async {
                isSaving.value = true;

                final success = await controller.saveInternalNotes(
                  leadId: rxLead.value.id!,
                  notes: notesController.text.trim(),
                );

                isSaving.value = false;

                if (success) {
                  CommonMethod.getXSnackBar(
                    "Success",
                    "Notes saved successfully",
                    greenColor,
                  );

                  rxLead.value = rxLead.value.copyWith(
                    adminNotes: notesController.text.trim(),
                  );
                }
              },
      ),
    );
  }

  Widget _actionButtons() {
    final bool isDisabled = rxLead.value.isContacted == true || isMarking.value;

    return Row(
      children: [
        Expanded(
          child: PrimaryTextButton(
            title: rxLead.value.isContacted == true
                ? "Already Contacted"
                : isMarking.value
                    ? "Marking..."
                    : "Mark as Contacted",
            buttonColor: isDisabled ? disableButtonColor : primaryColor,
            // Use app disable color
            textColor: isDisabled ? Colors.white : Colors.white,
            onPressed: isDisabled
                ? null
                : () async {
                    isMarking.value = true;

                    final date =
                        await controller.markAsContacted(rxLead.value.id!);

                    isMarking.value = false;

                    if (date != null) {
                      rxLead.value = rxLead.value.copyWith(
                        isContacted: true,
                        contactedDate: date,
                      );
                    }
                  },
          ),
        ),
        width10,
        Expanded(
          child: PrimaryTextButton(
            title: controller.isArchivedTab.value ? "Unarchive" : "Archive",
            // Assuming redColor for Archive action is appropriate, or keep primary
            buttonColor: Colors.white,
            textColor: redColor,
            // Using red for destructive/archive action
            onPressed: () {
              controller.toggleArchive(
                rxLead.value.id!,
                !controller.isArchivedTab.value,
              );
              Get.back();
            },
          ),
        ),
      ],
    );
  }
}
