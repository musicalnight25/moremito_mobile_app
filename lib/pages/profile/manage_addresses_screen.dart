import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';

// Ensure these paths match your project structure
import '../../controller/my_addresses_controller.dart';
import '../../model/my_address_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/primary_text_button.dart';
import 'add_edit_address_screen.dart';

class ManageAddressesScreen extends GetView<MyAddressesController> {
  const ManageAddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lazy initialization ensures the controller is available
    Get.lazyPut(() => MyAddressesController());

    return Scaffold(
      // Soft professional off-white
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Manage Addresses",
        visibleBackButton: true,
      ),
      // Sticky bottom button for better UX/Reachability
      bottomNavigationBar: _buildStickyFooter(),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (controller.addresses.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator.adaptive(
            onRefresh: () async => await controller
                .fetchAddresses(), // Assuming this method exists
            child: ListView.separated(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
              itemCount:
                  controller.addresses.length + 1, // +1 for the Note section
              separatorBuilder: (context, index) => SizedBox(height: 16.h),
              itemBuilder: (context, index) {
                if (index == 0) return _buildInfoNote();

                final address = controller.addresses[index - 1];
                return _buildAddressCard(address);
              },
            ),
          );
        }),
      ),
    );
  }

  /// Modern Warning Note using a subtle surface color
  Widget _buildInfoNote() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.orange.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_rounded, color: Colors.orange.shade800, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              "Note: Changing your address here does not update existing recurring orders. Please update those manually in the Orders tab.",
              style: AppTextStyle.normalRegular13.copyWith(
                color: Colors.orange.shade900,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Clean, Elevated Address Card
  Widget _buildAddressCard(MyAddressModel address) {
    final bool isDefault = address.isDefaultAddress ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isDefault ? Colors.blue.shade200 : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${address.firstName} ${address.lastName}",
                              style: AppTextStyle.normalBold16,
                            ),
                            if (isDefault) _buildDefaultBadge(),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "${address.address1}\n${address.city}, ${address.stateName} ${address.zipPostalCode}",
                          style: AppTextStyle.normalRegular14.copyWith(
                            color: Colors.grey.shade600,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildContactInfo(
                            Icons.phone_outlined, address.phoneNumber ?? ""),
                        SizedBox(height: 4.h),
                        _buildContactInfo(
                            Icons.email_outlined, address.email ?? ""),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _buildActionButtons(address, isDefault),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.blue.shade600,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        "Default",
        style: TextStyle(
            color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey),
        SizedBox(width: 6.w),
        Text(text,
            style: AppTextStyle.normalRegular13
                .copyWith(color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildActionButtons(MyAddressModel address, bool isDefault) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
      child: Row(
        children: [
          TextPrimaryButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              Get.to(() => AddEditAddressScreen(address: address));
            },
            title: "Edit",
          ),
          const Spacer(),
          if (!isDefault)
            TextPrimaryButton(
              onPressed: () =>
                  controller.saveAddress(address..isDefaultAddress = true),
              title: "Set as Default",
            ),
        ],
      ),
    );
  }

  Widget _buildStickyFooter() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5)),
        ],
      ),
      child: PrimaryTextButton(
        title: "Add New Address",
        onPressed: () {
          HapticFeedback.mediumImpact();
          Get.to(() => AddEditAddressScreen());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded,
              size: 100.sp, color: Colors.grey.shade200),
          SizedBox(height: 20.h),
          Text("No addresses yet", style: AppTextStyle.normalBold18),
          SizedBox(height: 8.h),
          Text("Add your delivery address to get started",
              style: AppTextStyle.normalRegular14.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }
}
