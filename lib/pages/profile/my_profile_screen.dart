import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
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
import '../../service/network_repository.dart';
import '../../utils/preferences_util.dart';
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
      appBar: CommonAppBar(
        title: "My Profile".tr,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(18.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// --- SECTION 0: LANGUAGE CHANGE ---
              _buildLanguageChangeSection(context),
              height20,

              /// --- SECTION 1: ACCOUNT & PERSONAL INFO ---
              Obx(() {
                if (profileController.isLoading.value) {
                  return _buildProfileShimmer();
                }
                final profile = profileController.profile.value;
                if (profile == null) return const SizedBox.shrink();

                return _buildSectionContainer(
                  title: "Account Information".tr,
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
                        title: "Update Profile".tr,
                      ),
                    ],
                  ),
                );
              }),

              height20,

              /// --- SECTION 2: MANAGE ADDRESSES ---
              _buildSectionContainer(
                title: "Manage your addresses".tr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Note: Changing your address here does not change your address on already created recurring orders."
                          .tr,
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
                        return Text("No addresses found.".tr);
                      }

                      return Column(
                        children: [
                          _dataRow(
                              "Address", _buildAddressText(defaultAddress)),
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
                      title: "Edit address".tr,
                    ),
                  ],
                ),
              ),

              height20,

              /// --- SECTION 3: WEBSITE HEADER DISPLAY ---
              _buildSectionContainer(
                title: "Your Website Header Display".tr,
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
                      title: "Edit".tr,
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
      title: "Loading...".tr,
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
              color: Colors.black.withValues(alpha: 0.02),
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

  Widget _buildLanguageChangeSection(BuildContext context) {
    final currentLocale = Get.locale ?? const Locale('en', 'US');
    final isEnglish = currentLocale.languageCode == 'en';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 8.w, bottom: 6.h),
          child: Text(
            "Settings".tr.toUpperCase(),
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: subTitleColor,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryWhite,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: borderGreyColor.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: bgPrimaryShadowColor.withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showLanguageBottomSheet(context),
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Row(
                  children: [
                    Container(
                      width: 34.w,
                      height: 34.w,
                      decoration: BoxDecoration(
                        color: paleYellowColor,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(
                        PhosphorIcons.globe(PhosphorIconsStyle.regular),
                        size: 18.sp,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Language".tr,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: lightBlackColor,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            isEnglish ? 'English' : '中文 (简体)',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: hintGreyColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 14.sp,
                      color: hintGreyColor.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _changeLanguage({
    required BuildContext context,
    required String languageCode,
  }) async {
    final networkRepository = NetworkRepository();
    try {
      await networkRepository.saveLanguage(context, {'Language': languageCode});
      await PreferencesUtil.saveLanguagePreference(languageCode);
      Navigator.pop(context);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (languageCode == 'zh') {
          Get.updateLocale(const Locale('zh', 'CN'));
        } else {
          Get.updateLocale(const Locale('en', 'US'));
        }
      });
    } catch (e) {
      debugPrint("Error saving language: $e");
      Navigator.pop(context);
    }
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        final currentLocale = Get.locale ?? const Locale('en', 'US');
        final isEnglish = currentLocale.languageCode == 'en';

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Change Language'.tr,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 24.h),
                _buildLanguageOption(
                  context: context,
                  language: 'English',
                  code: 'en_US',
                  isSelected: isEnglish,
                  onTap: () =>
                      _changeLanguage(context: context, languageCode: 'en'),
                ),
                SizedBox(height: 16.h),
                _buildLanguageOption(
                  context: context,
                  language: '中文 (简体)',
                  code: 'zh_CN',
                  isSelected: !isEnglish,
                  onTap: () =>
                      _changeLanguage(context: context, languageCode: 'zh'),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption({
    required BuildContext context,
    required String language,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? Colors.blue.shade400 : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 24.w,
              width: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      isSelected ? Colors.blue.shade400 : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? Colors.blue.shade400 : Colors.transparent,
              ),
              child: isSelected
                  ? Center(
                      child: Icon(
                        Icons.check,
                        size: 14.sp,
                        color: Colors.white,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                size: 24.sp,
                color: Colors.blue.shade400,
              ),
          ],
        ),
      ),
    );
  }

  String _buildAddressText(MyAddressModel address) {
    final firstLine = (address.address1 ?? '').trim();
    final city = (address.city ?? '').trim();
    final state = (address.stateName ?? '').trim();
    final zip = (address.zipPostalCode ?? '').trim();

    final secondParts = [city, state, zip].where((part) => part.isNotEmpty);
    final secondLine = secondParts.join(', ').replaceAll(', ,', ',');

    final lines = [firstLine, secondLine].where((line) => line.isNotEmpty);
    return lines.isEmpty ? '-' : lines.join('\n');
  }
}
