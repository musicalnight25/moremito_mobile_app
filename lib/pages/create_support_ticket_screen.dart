import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/ticket_controller.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../utils/custom_dropdown_widget.dart';

class CreateSupportTicketScreen extends StatefulWidget {
  @override
  State<CreateSupportTicketScreen> createState() =>
      _CreateSupportTicketScreenState();
}

class _CreateSupportTicketScreenState extends State<CreateSupportTicketScreen> {
  final TicketController tc = Get.put(TicketController());

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final RxInt selectedModuleId = 0.obs;
  final RxInt selectedPriorityId = 0.obs;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tc.getTicketModules();
      tc.getTicketPriorities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: "Create Support Ticket",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ======================= SUBJECT =======================
              TextFormFieldWidget(
                controller: subjectController,
                labelText: 'Ticket Subject:',
                hintText: "Enter subject",
              ),

              customHeight(16),

              /// ======================= MODULE DROPDOWN =======================
              Obx(() {
                if (tc.moduleLoading.value) {
                  return SizedBox();
                }

                return CustomDropdown(
                  labelText: "Ticket Related To:",
                  hintText: "Select",
                  value: selectedModuleId.value == 0
                      ? null
                      : selectedModuleId.value,
                  items: tc.moduleList
                      .map((m) => {"id": m.id, "value": m.value})
                      .toList(),
                  customItems: tc.moduleList
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(
                            m.value ?? "",
                            style: AppTextStyle.normalRegular14,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => selectedModuleId.value = val,
                );
              }),

              customHeight(16),

              /// ======================= PRIORITY DROPDOWN =======================
              Obx(() {
                if (tc.priorityLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: primaryColor));
                }

                return CustomDropdown(
                  labelText: "Ticket Priority:",
                  hintText: "Select",
                  value: selectedPriorityId.value == 0
                      ? null
                      : selectedPriorityId.value,
                  items: tc.priorityList
                      .map((p) => {"id": p.id, "value": p.value})
                      .toList(),
                  customItems: tc.priorityList
                      .map(
                        (p) => DropdownMenuItem(
                          value: p.id,
                          child: Text(
                            p.value ?? "",
                            style: AppTextStyle.normalRegular14,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (val) => selectedPriorityId.value = val,
                );
              }),

              customHeight(16),

              /// ======================= DESCRIPTION =======================
              TextFormFieldWidget(
                controller: descriptionController,
                labelText: "Ticket Description:",
                hintText:
                    "Enter ticket description (order no., username, etc.)",
                maxLines: 5,
              ),

              customHeight(24),

              /// ======================= BUTTONS =======================
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                      child: tc.createLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : PrimaryTextButton(
                              title: "Create",
                              onPressed: _createTicket,
                            ),
                    ),
                    customWidth(12),
                    Expanded(
                      child: PrimaryTextButton(
                        title: "Cancel",
                        buttonColor: lightBlackColor,
                        onPressed: () => Get.back(),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  //                       CREATE TICKET
  // ============================================================
  Future<void> _createTicket() async {
    if (subjectController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        selectedModuleId.value == 0 ||
        selectedPriorityId.value == 0) {
      CommonMethod.getXSnackBar("Warning", "Please fill all fields", redColor);
      return;
    }

    await tc.createTicket(
      title: subjectController.text.trim(),
      description: descriptionController.text.trim(),
      moduleId: selectedModuleId.value,
      priorityId: selectedPriorityId.value,
    );
  }
}
