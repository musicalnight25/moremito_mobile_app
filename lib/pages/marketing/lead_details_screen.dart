import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';

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

    /// ✅ Initialize ONCE
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
                  CommonMethod.formatFullDateFromDateTime(
                    lead.createdDate,
                  ),
                ),
                _row("Call Me", lead.contactMe == true ? "Yes" : "No"),
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

  Widget _notesField() {
    return TextFormFieldWidget(
      controller: notesController,
      maxLines: 6,
      hintText: "Enter internal notes",
    );
  }

  Widget _saveNoteButton() {
    return PrimaryTextButton(
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

                /// ✅ realtime update
                rxLead.value = rxLead.value.copyWith(
                  adminNotes: notesController.text.trim(),
                );
              }
            },
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
            buttonColor: isDisabled ? Colors.grey.shade400 : primaryColor,
            textColor: isDisabled ? Colors.grey.shade800 : Colors.white,
            onPressed: isDisabled
                ? null
                : () async {
                    isMarking.value = true;

                    final date =
                        await controller.markAsContacted(rxLead.value.id!);

                    isMarking.value = false;

                    if (date != null) {
                      /// ✅ realtime update
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
