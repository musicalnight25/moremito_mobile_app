import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';

import '../../controller/my_addresses_controller.dart';
import '../../model/my_address_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/primary_text_button.dart';

class AddEditAddressScreen extends StatefulWidget {
  final MyAddressModel? address;

  const AddEditAddressScreen({super.key, this.address});

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final controller = Get.find<MyAddressesController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController firstNameCtrl,
      lastNameCtrl,
      emailCtrl,
      phoneCtrl,
      addressCtrl,
      cityCtrl,
      zipCtrl;

  RxBool isDefault = false.obs;

  @override
  void initState() {
    super.initState();

    firstNameCtrl = TextEditingController(text: widget.address?.firstName);
    lastNameCtrl = TextEditingController(text: widget.address?.lastName);
    emailCtrl = TextEditingController(text: widget.address?.email);
    phoneCtrl = TextEditingController(text: widget.address?.phoneNumber);
    addressCtrl = TextEditingController(text: widget.address?.address1);
    cityCtrl = TextEditingController(text: widget.address?.city);
    zipCtrl = TextEditingController(text: widget.address?.zipPostalCode);

    isDefault.value = widget.address?.isDefaultAddress ?? false;

    if (widget.address != null) {
      controller.selectedCountryId.value = widget.address!.countryId;
      controller.selectedStateId.value = widget.address!.stateId;

      if (widget.address!.countryId != null) {
        controller.fetchStates(widget.address!.countryId!);
      }
    }
  }

  @override
  void dispose() {
    firstNameCtrl.dispose();
    lastNameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    cityCtrl.dispose();
    zipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: widget.address == null ? "Add New Address" : "Edit Address",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
            // Added top padding for extendBodyBehindAppBar
            child: Column(
              children: [
                _buildFormSection(
                  title: "Contact Person".tr,
                  icon: Icons.person_outline_rounded,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Expanded ensures they share width and don't overflow
                        Expanded(child: _field("First Name", firstNameCtrl)),
                        SizedBox(width: 12.w),
                        Expanded(child: _field("Last Name", lastNameCtrl)),
                      ],
                    ),
                    _field("Email Address", emailCtrl,
                        keyboardType: TextInputType.emailAddress),
                    _field("Phone Number", phoneCtrl,
                        keyboardType: TextInputType.phone),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildFormSection(
                  title: "Address".tr,
                  icon: Icons.location_on_outlined,
                  children: [
                    _field("Street Address", addressCtrl, maxLines: 2),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _field("City", cityCtrl)),
                        SizedBox(width: 12.w),
                        Expanded(
                            child: _field("Zip Code", zipCtrl,
                                keyboardType: TextInputType.number)),
                      ],
                    ),

                    /// Country Dropdown - Added loading check to keep Obx active
                    Obx(() {
                      if (controller.isLoadingCountries.value) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive());
                      }
                      return _dropdown(
                        label: "Country".tr,
                        value: controller.selectedCountryId.value,
                        items: {
                          for (var c in controller.countries) c.id!: c.name!
                        },
                        onChanged: (v) {
                          controller.selectedCountryId.value = v;
                          controller.selectedStateId.value = null;
                          if (v != null) controller.fetchStates(v);
                        },
                      );
                    }),

                    /// State Dropdown - Added list length check to prevent Obx error
                    Obx(() {
                      // Using .length ensures Obx has an observable to track
                      if (controller.isLoadingStates.value) {
                        return const Center(
                            child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        ));
                      }
                      return _dropdown(
                        label: "State".tr,
                        value: controller.selectedStateId.value,
                        items: {
                          for (var s in controller.states) s.id!: s.name!
                        },
                        onChanged: (v) => controller.selectedStateId.value = v,
                      );
                    }),
                  ],
                ),
                SizedBox(height: 16.h),
                _buildDefaultToggle(),
                SizedBox(height: 32.h),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(
      {required String title,
      required IconData icon,
      required List<Widget> children}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.sp, color: primaryColor),
              SizedBox(width: 8.w),
              Text(title,
                  style: AppTextStyle.normalBold14
                      .copyWith(color: Colors.black87)),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child:
                Divider(height: 1, thickness: 0.5, color: Colors.grey.shade200),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDefaultToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Obx(() => SwitchListTile(
            value: isDefault.value,
            activeColor: Colors.white,
            activeTrackColor: primaryColor,
            inactiveThumbColor: Colors.grey.shade400,
            inactiveTrackColor: Colors.grey.shade300,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            title: Text("Set as primary address".tr,
                style: AppTextStyle.normalSemiBold14
                    .copyWith(color: Colors.black87)),
            onChanged: (v) {
              HapticFeedback.lightImpact();
              isDefault.value = v;
            },
          )),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          child: PrimaryTextButton(
            title: controller.isLoading.value
                ? "Saving..."
                : (widget.address == null ? "Add Address" : "Update Address"),
            onPressed: controller.isLoading.value
                ? null
                : () async {
                    if (_formKey.currentState!.validate()) {
                      if (controller.selectedCountryId.value == null ||
                          controller.selectedStateId.value == null) {
                        CommonMethod.getXSnackBar("Required".tr,
                            "Please select Country and State".tr, redColor);
                        return;
                      }
                      HapticFeedback.mediumImpact();
                      await controller.saveAddress(MyAddressModel(
                        id: widget.address?.id,
                        firstName: firstNameCtrl.text.trim(),
                        lastName: lastNameCtrl.text.trim(),
                        email: emailCtrl.text.trim(),
                        phoneNumber: phoneCtrl.text.trim(),
                        address1: addressCtrl.text.trim(),
                        city: cityCtrl.text.trim(),
                        zipPostalCode: zipCtrl.text.trim(),
                        countryId: controller.selectedCountryId.value,
                        stateId: controller.selectedStateId.value,
                        isDefaultAddress: isDefault.value,
                      ));
                      Get.back();
                    }
                  },
          ),
        ));
  }

  InputDecoration _getInputDecoration(String hint) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade50,
      hintText: hint,
      hintStyle: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400),
      contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: primaryColor, width: 1.2)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.2)),
    );
  }

  Widget _field(String label, TextEditingController ctrl,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyle.normalSemiBold13
                  .copyWith(color: Colors.black54)),
          SizedBox(height: 6.h),
          TextFormField(
            controller: ctrl,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: AppTextStyle.normalRegular14,
            decoration: _getInputDecoration("Enter $label"),
            validator: (value) =>
                (value == null || value.isEmpty) ? "$label is required" : null,
          ),
        ],
      ),
    );
  }

  Widget _dropdown(
      {required String label,
      required int? value,
      required Map<int, String> items,
      required Function(int?) onChanged}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: AppTextStyle.normalSemiBold13
                  .copyWith(color: Colors.black54)),
          SizedBox(height: 6.h),
          DropdownButtonFormField<int>(
            value: value,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.black54, size: 22.sp),
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.black),
            hint: Text(
                "Select {label}".trParams({
                  "label": label,
                }),
                style: AppTextStyle.normalRegular14
                    .copyWith(color: Colors.black54)),
            items: items.entries
                .map((e) =>
                    DropdownMenuItem<int>(value: e.key, child: Text(e.value)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide:
                      BorderSide(color: Colors.grey.shade300, width: 1)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide:
                      const BorderSide(color: primaryColor, width: 1.5)),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.red)),
            ),
            validator: (val) => val == null
                ? "Select {label}".trParams({
                    "label": label,
                  })
                : null,
          ),
        ],
      ),
    );
  }
}
