import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart'; // Add this
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';

// Controllers
import '../../controller/my_profile_controller.dart';
import '../../controller/my_addresses_controller.dart';
import '../../controller/welcome_tag_controller.dart';

// Utils & Screens
import '../../model/my_address_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/static_decoration.dart';
import 'manage_addresses_screen.dart';
import 'welcome_tag_screen.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.put(MyProfileController());
    final addressController = Get.put(MyAddressesController());
    final welcomeTagController = Get.put(WelcomeTagController());

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "My Profile",
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- SECTION 1: ACCOUNT & PERSONAL INFO ---
              Obx(() {
                if (profileController.isLoading.value) {
                  return _buildProfileShimmer();
                }
                final profile = profileController.profile.value;
                if (profile == null) return const SizedBox.shrink();

                return _buildSectionContainer(
                  title: "Account Information",
                  child: Column(
                    children: [
                      _readOnlyField("Username", profile.userName),
                      _readOnlyField("SMS Code", profile.smsCode),
                      _editableField(
                          "First Name", profileController.firstNameCtrl),
                      _editableField(
                          "Last Name", profileController.lastNameCtrl),
                      _editableField("Email", profileController.emailCtrl,
                          keyboardType: TextInputType.emailAddress),
                      _editableField("Phone", profileController.phoneCtrl,
                          keyboardType: TextInputType.phone),
                      _editableField(
                          "WhatsApp Phone", profileController.whatsappCtrl,
                          keyboardType: TextInputType.phone),
                      height10,
                      _readOnlyField("Membership Type", profile.membershipType),
                      _readOnlyField("Join Date", profile.joinDate),
                      height16,
                      PrimaryTextButton(
                        onPressed: () => profileController.updateProfile(),
                        title: "Update Profile",
                      ),
                    ],
                  ),
                );
              }),

              height20,

              /// --- SECTION 2: MANAGE ADDRESSES ---
              _buildSectionContainer(
                title: "Manage your addresses",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note: Changing your address here does not change your address on already created recurring orders.",
                      style: AppTextStyle.normalRegular12
                          .copyWith(color: Colors.red.shade700),
                    ),
                    height16,
                    Obx(() {
                      if (addressController.isLoading.value) {
                        return _buildDataRowShimmer(5); // Shimmer for 5 rows
                      }

                      final defaultAddress =
                          addressController.addresses.firstWhere(
                        (element) => element.isDefaultAddress == true,
                        orElse: () => addressController.addresses.isNotEmpty
                            ? addressController.addresses.first
                            : MyAddressModel(),
                      );

                      if (addressController.addresses.isEmpty) {
                        return const Text("No addresses found.");
                      }

                      return Column(
                        children: [
                          _dataRow(
                              "Address",
                              "${defaultAddress.address1}\n${defaultAddress.city}, ${defaultAddress.stateName} ${defaultAddress.zipPostalCode}" ??
                                  "-"),
                          _dataRow("City", defaultAddress.city ?? "-"),
                          _dataRow(
                              "Country", defaultAddress.countryName ?? "-"),
                          _dataRow("State", defaultAddress.stateName ?? "-"),
                          _dataRow("Zip", defaultAddress.zipPostalCode ?? "-"),
                        ],
                      );
                    }),
                    height16,
                    TextPrimaryButton(
                      onPressed: () =>
                          Get.to(() => const ManageAddressesScreen()),
                      title: "Edit address",
                    ),
                  ],
                ),
              ),

              height20,

              /// --- SECTION 3: WEBSITE HEADER DISPLAY ---
              _buildSectionContainer(
                title: "Your Website Header Display",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (welcomeTagController.isLoading.value) {
                        return _buildDataRowShimmer(3); // Shimmer for 3 rows
                      }
                      final tag = welcomeTagController.welcomeTag.value;
                      return Column(
                        children: [
                          _dataRow("Name", tag?.welcomeName ?? "-"),
                          _dataRow("Email", tag?.welcomeEmail ?? "-"),
                          _dataRow("Phone", tag?.welcomePhone ?? "-"),
                        ],
                      );
                    }),
                    height16,
                    TextPrimaryButton(
                      onPressed: () => Get.to(() => const WelcomeTagScreen()),
                      title: "Edit",
                    ),
                  ],
                ),
              ),
              customHeight(40),
            ],
          ),
        ),
      ),
    );
  }

  // ------------------ SHIMMER HELPERS ------------------

  Widget _buildProfileShimmer() {
    return _buildSectionContainer(
      title: "Loading...",
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: List.generate(
              7,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 100.w, height: 14.h, color: Colors.white),
                      SizedBox(height: 8.h),
                      Container(
                          width: double.infinity,
                          height: 45.h,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.sp))),
                      SizedBox(height: 12.h),
                    ],
                  )),
        ),
      ),
    );
  }

  Widget _buildDataRowShimmer(int count) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: List.generate(
            count,
            (index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Container(width: 80.w, height: 14.h, color: Colors.white),
                      SizedBox(width: 10.w),
                      Container(
                          width: 150.w, height: 14.h, color: Colors.white),
                    ],
                  ),
                )),
      ),
    );
  }

  // ------------------ UI HELPERS ------------------

  Widget _buildSectionContainer(
      {required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyle.normalBold16.copyWith(color: primaryColor)),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _dataRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 80.w,
              child: Text(label, style: AppTextStyle.normalSemiBold14)),
          Expanded(child: Text(value, style: AppTextStyle.normalRegular14)),
        ],
      ),
    );
  }

  Widget _readOnlyField(String label, String? value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.normalSemiBold14),
          height04,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.sp),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.sp),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(value?.isNotEmpty == true ? value! : "-",
                style: AppTextStyle.normalRegular14),
          ),
        ],
      ),
    );
  }

  Widget _editableField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyle.normalSemiBold14),
          height04,
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 14.sp, vertical: 12.sp),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.sp),
                  borderSide: BorderSide(color: Colors.grey.shade300)),
            ),
            style: AppTextStyle.normalRegular14,
          ),
        ],
      ),
    );
  }
}
