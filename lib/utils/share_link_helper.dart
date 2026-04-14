import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/categories_controller.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/share_bottom_sheet.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

class ShareLinkHelper {
  static final CategoriesController _categoriesController =
      Get.find<CategoriesController>();
  static final HomeController _homeController = Get.find<HomeController>();

  /// Show share link dialog with recipient input
  static void showShareLinkDialog({
    required BuildContext context,
    required String contentId,
    required String contentTitle,
    String? messageTemplate,
  }) {
    final nameTextController = TextEditingController();
    final messageTextController = TextEditingController();
    final generatedLink = RxString('');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.sp),
                topRight: Radius.circular(16.sp),
              ),
            ),
            padding: EdgeInsets.all(16.sp),
            child: Obx(
              () => Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contentTitle,
                        style: AppTextStyle.normalBold14
                            .copyWith(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  /// ================= STEP 1 =================
                  if (generatedLink.isEmpty) ...[
                    Text(
                      "Step 1: Enter Recipient Name".tr,
                      style: AppTextStyle.normalBold14
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 12.h),
                    TextFormFieldWidget(
                      controller: nameTextController,
                      labelText: "Recipient Name".tr,
                      hintText: "Enter recipient name".tr,
                      prefixIcon:
                          const Icon(Icons.person, color: lightBlackColor),
                    ),
                    SizedBox(height: 15.h),
                    PrimaryTextButton(
                      title: "Generate a Link".tr,
                      onPressed: () async {
                        if (nameTextController.text.trim().isEmpty) {
                          CommonMethod.getXSnackBar(
                            "Error".tr,
                            "Please enter recipient name".tr,
                            redColor,
                          );
                          return;
                        }

                        final linkData =
                            await _categoriesController.generateLink(
                          context: context,
                          fileId: contentId,
                          SharedTo: nameTextController.text.trim(),
                        );

                        if (linkData == null || linkData['shareUrl'] == null) {
                          CommonMethod.getXSnackBar(
                            "Error".tr,
                            "Failed to generate link".tr,
                            redColor,
                          );
                          return;
                        }

                        final shareUrl = linkData['shareUrl'] as String;
                        final savedShareId = linkData['savedShareId'];

                        generatedLink.value = shareUrl;

                        // Store savedShareId for later use when sharing
                        Get.put<dynamic>(
                          savedShareId,
                          tag: 'savedShareId_$contentId',
                        );

                        final dashboard = _homeController.dashboardModel.value;
                        final senderName =
                            (dashboard?.name ?? "").trim().isNotEmpty
                                ? (dashboard?.name ?? "").trim()
                                : (dashboard?.userName ?? "Someone");

                        final recipientName = nameTextController.text.trim();
                        messageTextController.text = messageTemplate
                                ?.replaceAll('{recipient}', recipientName)
                                .replaceAll('{link}', shareUrl) ??
                            "Hey {name}, {sender} has invited you to the MoreMito health and wellness call. Visit the link to see more. {url}"
                                .trParams({
                              "name": recipientName,
                              "sender": senderName,
                              "url": shareUrl,
                            });
                      },
                    ),
                  ],

                  /// ================= STEP 2 =================
                  if (generatedLink.isNotEmpty) ...[
                    // Generated link box
                    ShadowContainerWidget(
                      blurRadius: 0,
                      borderWidth: 1,
                      borderColor: primaryColor,
                      color: primaryColor.withValues(alpha: 0.10),
                      padding: 12.sp,
                      widget: Row(
                        children: [
                          Expanded(
                            child: SelectableText(
                              generatedLink.value,
                              style: AppTextStyle.normalBold12
                                  .copyWith(color: primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Message section
                    Text(
                      "Step 2: Write Message".tr,
                      style: AppTextStyle.normalBold14
                          .copyWith(color: Colors.black),
                    ),
                    SizedBox(height: 12.h),
                    TextFormFieldWidget(
                      controller: messageTextController,
                      maxLines: 4,
                      labelText: "Message".tr,
                      hintText: "Write a message for the recipient".tr,
                    ),
                    SizedBox(height: 15.h),

                    // Share button
                    PrimaryTextButton(
                      title: "Share".tr,
                      onPressed: () {
                        Navigator.pop(context);

                        // Retrieve the saved share ID
                        final savedShareId = Get.find<dynamic>(
                          tag: 'savedShareId_$contentId',
                        );

                        _showShareBottomSheet(
                          context: context,
                          contentId: contentId,
                          sharedUrl: generatedLink.value,
                          message: messageTextController.text.trim(),
                          savedShareId: savedShareId,
                        );
                      },
                    ),

                    // Reset button
                    SizedBox(height: 12.h),
                    PrimaryTextButton(
                      title: "Generate Another Link".tr,
                      onPressed: () {
                        generatedLink.value = '';
                        nameTextController.clear();
                        messageTextController.clear();
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Show share platforms bottom sheet
  static void _showShareBottomSheet({
    required BuildContext context,
    required String contentId,
    required String sharedUrl,
    required String message,
    dynamic savedShareId,
  }) {
    final phoneController = TextEditingController();
    final emailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.sp),
              topRight: Radius.circular(16.sp),
            ),
          ),
          padding: EdgeInsets.all(16.sp),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Share Via".tr,
                      style: AppTextStyle.normalBold14
                          .copyWith(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Phone/Email inputs
                Text(
                  "Enter Contact Details".tr,
                  style: AppTextStyle.normalBold10.copyWith(color: Colors.grey),
                ),
                SizedBox(height: 12.h),
                TextFormFieldWidget(
                  controller: phoneController,
                  labelText: "Phone Number".tr,
                  hintText: "Phone number".tr,
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 12.h),
                TextFormFieldWidget(
                  controller: emailController,
                  labelText: "Email".tr,
                  hintText: "Email address".tr,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.h),

                // Share button
                PrimaryTextButton(
                  title: "Share Now".tr,
                  onPressed: () {
                    Navigator.pop(context);
                    // Show share platforms
                    ShareBottomSheet.show(
                      context: context,
                      phoneNumber: phoneController.text.trim(),
                      message: message,
                      email: emailController.text.trim(),
                      onShared: (platform) async {
                        await _categoriesController.mobileSaveFileShare(
                          context: context,
                          fileId: contentId,
                          sharedUrl: sharedUrl,
                          sharedBy: platform,
                          savedShareId: savedShareId,
                        );

                        CommonMethod.getXSnackBar(
                          "Success 🎉".tr,
                          "Thanks for sharing via {platform}".trParams({
                            "platform": platform,
                          }),
                          greenColor,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
