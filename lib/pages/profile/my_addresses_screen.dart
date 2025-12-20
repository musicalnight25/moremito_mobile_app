import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';

import '../../controller/my_addresses_controller.dart';
import '../../model/my_address_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/static_decoration.dart';

class MyAddressesScreen extends StatelessWidget {
  const MyAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MyAddressesController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: "My Addresses",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.addressList.isEmpty
                  ? NoDataFound()
                  : ListView(
                      padding: EdgeInsets.all(18.sp),
                      children: [
                        if (controller.defaultAddress.value != null)
                          _defaultAddressCard(controller.defaultAddress.value!),
                        height20,
                        ...controller.addressList.map(
                          (e) => _addressCard(
                            address: e,
                            isDefault: e.isDefaultAddress == true,
                            onSetDefault: () => controller.setDefaultAddress(e),
                          ),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }

  // ───────────────── DEFAULT ADDRESS ─────────────────

  Widget _defaultAddressCard(MyAddressModel address) {
    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(.08),
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: primaryColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Default Address",
              style: AppTextStyle.normalBold16.copyWith(color: primaryColor)),
          height08,
          _addressText(address),
        ],
      ),
    );
  }

  // ───────────────── ADDRESS CARD ─────────────────

  Widget _addressCard({
    required MyAddressModel address,
    required bool isDefault,
    required VoidCallback onSetDefault,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.sp),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: borderGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _addressText(address),
          height10,
          if (!isDefault)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onSetDefault,
                child: Text(
                  "Set as Default",
                  style:
                      AppTextStyle.normalBold14.copyWith(color: primaryColor),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _addressText(MyAddressModel address) {
    return Text(
      "${address.address1}\n"
      "${address.city}, ${address.stateName}\n"
      "${address.countryName} - ${address.zipPostalCode}",
      style: AppTextStyle.normalRegular14,
    );
  }
}
