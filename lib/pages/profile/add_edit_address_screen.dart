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
import '../../utils/static_decoration.dart';

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

  int? countryId;
  int? stateId;
  bool isDefault = false;

  final Map<int, String> countryMap = {
    237: "United States of America",
    104: "India",
    1: "Afghanistan"
  };
  final Map<int, String> stateMap = {
    1678: "California",
    1720: "South Carolina",
    1697: "Maryland",
    842: "Himachal Pradesh",
    1673: "Alabama"
  };

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
    isDefault = widget.address?.isDefaultAddress ?? false;

    countryId = countryMap.containsKey(widget.address?.countryId)
        ? widget.address?.countryId
        : null;
    stateId = stateMap.containsKey(widget.address?.stateId)
        ? widget.address?.stateId
        : null;
  }

  @override
  void dispose() {
    for (var c in [
      firstNameCtrl,
      lastNameCtrl,
      emailCtrl,
      phoneCtrl,
      addressCtrl,
      cityCtrl,
      zipCtrl
    ]) {
      c.dispose();
    }
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
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 32.h),
            child: Column(
              children: [
                _buildFormSection(
                  title: "Contact Person",
                  icon: Icons.person_outline_rounded,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                  title: "Delivery Address",
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
                    _dropdown(
                        label: "Country",
                        value: countryId,
                        items: countryMap,
                        onChanged: (v) => setState(() => countryId = v)),
                    _dropdown(
                        label: "State",
                        value: stateId,
                        items: stateMap,
                        onChanged: (v) => setState(() => stateId = v)),
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
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: SwitchListTile.adaptive(
        value: isDefault,
        activeTrackColor: primaryColor,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        title: Text("Set as primary address",
            style: AppTextStyle.normalSemiBold14),
        subtitle: Text("Used for future recurring orders",
            style: AppTextStyle.normalRegular12.copyWith(color: Colors.grey)),
        onChanged: (v) {
          HapticFeedback.lightImpact();
          setState(() => isDefault = v);
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: PrimaryTextButton(
        title: widget.address == null ? "Add Address" : "Update Address",
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            if (countryId == null || stateId == null) {
              CommonMethod.getXSnackBar(
                  "Required", "Please select Country and State", redColor);
              return;
            }
            HapticFeedback.mediumImpact();
            Get.back();
            await controller.saveAddress(MyAddressModel(
              id: widget.address?.id,
              firstName: firstNameCtrl.text.trim(),
              lastName: lastNameCtrl.text.trim(),
              email: emailCtrl.text.trim(),
              phoneNumber: phoneCtrl.text.trim(),
              address1: addressCtrl.text.trim(),
              city: cityCtrl.text.trim(),
              zipPostalCode: zipCtrl.text.trim(),
              countryId: countryId,
              stateId: stateId,
              isDefaultAddress: isDefault,
            ));
          }
        },
      ),
    );
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
            isExpanded: true,
            value: value,
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.grey.shade400, size: 20.sp),
            hint: Text("Select $label",
                style: TextStyle(fontSize: 13.sp, color: Colors.grey.shade400)),
            items: items.entries
                .map((e) => DropdownMenuItem<int>(
                    value: e.key,
                    child: Text(e.value, style: AppTextStyle.normalRegular14)))
                .toList(),
            onChanged: onChanged,
            validator: (val) => val == null ? "Select $label" : null,
            decoration:
                _getInputDecoration("Select $label").copyWith(hintText: null),
          ),
        ],
      ),
    );
  }
}
