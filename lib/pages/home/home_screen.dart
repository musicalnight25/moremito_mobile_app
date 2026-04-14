import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/categories_controller.dart';
import 'package:more_mitro_app/controller/contact_controller.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/model/dashboard_model.dart';
import 'package:more_mitro_app/pages/category/contact_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../../share_bottom_sheet.dart';
import 'announcement_detail_screen.dart';
import 'call_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // HomeController is already put by HomeScreen itself or parent; find it here.
  final homeController = Get.put(HomeController());
  final categoriesController = Get.put(CategoriesController());
  final contactController = Get.put(ContactController());
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final messageTextController = TextEditingController();
  String? selectedEmail;

  @override
  void initState() {
    super.initState();
    // HomeController.onInit() already schedules getDashboard() via
    // addPostFrameCallback the first time. Only re-fetch if data is already
    // loaded (i.e., controller was reused from a previous visit).
    if (homeController.dashboardModel.value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        homeController.getDashboard();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(),
      body: SafeArea(
        child: RefreshIndicator(
          color: primaryColor,
          onRefresh: () async => homeController.getDashboard(),
          child: Obx(() {
            DashboardModel? user = homeController.dashboardModel.value;

            if (user == null && !homeController.isLoading.value) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: 400,
                  child: Center(child: NoDataFound(title: "Dashboard".tr)),
                ),
              );
            }

            if (user == null) {
              return const Center(
                child: CircularProgressIndicator(color: primaryColor),
              );
            }

            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(16.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _betaDisclaimer(),
                  height16,
                  _welcomeCard(user),
                  height20,
                  _callAnnouncementCard(user),
                  height20,
                  _announcementCard(user),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _welcomeCard(DashboardModel user) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        border: Border.all(color: borderGreyColor),
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(.50),
            blurRadius: 14,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Welcome".tr,
            style: AppTextStyle.normalSemiBold20.copyWith(
              color: primaryBlack,
            ),
          ),
          height08,
          Text(
            "{name} ({username})".trParams({
              "name": user.name ?? "",
              "username": user.userName ?? "",
            }),
            style: AppTextStyle.normalSemiBold18.copyWith(
              color: primaryColor,
            ),
          ),
          height12,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.sp, vertical: 6.sp),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(.12),
              borderRadius: BorderRadius.circular(30.sp),
            ),
            child: Text(
              user.currentRank ?? "-",
              style: AppTextStyle.normalSemiBold14.copyWith(
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _callAnnouncementCard(DashboardModel user) {
    CallDetails? call = user.callDetails;
    if (call == null) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Call Announcement".tr,
          style: AppTextStyle.normalSemiBold20.copyWith(color: primaryBlack),
        ),
        height12,
        GestureDetector(
          onTap: () {
            Get.to(() => CallDetailScreen(
                  id: 1,
                  templateName: call.emailTemplate ?? "",
                ));
          },
          child: Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: primaryWhite,
              borderRadius: BorderRadius.circular(16.sp),
              border: Border.all(color: borderGreyColor),
              boxShadow: [
                BoxShadow(
                  color: bgPrimaryShadowColor.withOpacity(.45),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ICON + TITLE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.campaign, size: 28.sp, color: redColor),
                    width12,
                    Expanded(
                      child: Text(
                        call.title ?? "-",
                        style: AppTextStyle.normalSemiBold16
                            .copyWith(color: primaryBlack),
                      ),
                    ),
                  ],
                ),

                height10,

                Text(
                  "Subject: ${call.subject ?? '-'}",
                  style: AppTextStyle.normalRegular14.copyWith(
                    color: lightBlackColor,
                  ),
                ),

                height08,

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Click to View".tr,
                      style: AppTextStyle.normalSemiBold14.copyWith(
                        color: primaryColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => _showShareOptionSheet(
                        contentId: 'call_announcement_${call.emailTemplate}',
                        contentTitle: call.title ?? "Call Announcement",
                      ),
                      icon: Icon(Icons.share, size: 18.sp, color: primaryColor),
                      label: Text(
                        "Share".tr,
                        style: AppTextStyle.normalSemiBold14.copyWith(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: primaryColor,
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.sp,
                          vertical: 6.sp,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _announcementCard(DashboardModel user) {
    List<AnnouncementDetails> list = user.announcementDetails ?? [];
    if (list.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Announcements".tr,
          style: AppTextStyle.normalSemiBold20.copyWith(color: primaryBlack),
        ),
        height12,
        ...list.map((item) => _announcementItem(item)).toList(),
      ],
    );
  }

  Widget _announcementItem(AnnouncementDetails item) {
    return GestureDetector(
      onTap: () => Get.to(() => AnnouncementDetailScreen(id: item.id!)),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.sp),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: borderGreyColor),
          boxShadow: [
            BoxShadow(
              color: bgPrimaryShadowColor.withOpacity(.45),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.notifications_active, size: 28.sp, color: orangeColor),
            width12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.announcementName ?? "",
                    style: AppTextStyle.normalSemiBold16.copyWith(
                      color: primaryBlack,
                    ),
                  ),
                  height06,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Click to View".tr,
                        style: AppTextStyle.normalSemiBold14.copyWith(
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showShareOptionSheet(
                          contentId: 'announcement_${item.id}',
                          contentTitle: item.announcementName ?? "Announcement",
                        ),
                        icon:
                            Icon(Icons.share, size: 16.sp, color: primaryColor),
                        label: Text(
                          "Share".tr,
                          style: AppTextStyle.normalSemiBold14.copyWith(
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: primaryColor,
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.sp,
                            vertical: 6.sp,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _betaDisclaimer() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(16.sp),
        // Solid professional shadow using your theme shadow color
        boxShadow: [
          BoxShadow(
            color: bgPrimaryShadowColor.withOpacity(0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.sp),
        child: Stack(
          children: [
            // Background Decoration: Soft Gradient Blobs
            Positioned(
              right: -20,
              top: -20,
              child: CircleAvatar(
                radius: 50.r,
                backgroundColor: paleYellowColor.withOpacity(0.5),
              ),
            ),

            // Layout with Accent Bar
            IntrinsicHeight(
              child: Row(
                children: [
                  // Solid Primary Accent Bar
                  Container(
                    width: 6.w,
                    decoration: const BoxDecoration(
                      color: primaryColor, // Your solid theme primary color
                    ),
                  ),

                  // Content Section
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        // Using your paleYellowColor as a soft glass effect
                        color: paleYellowColor.withOpacity(0.3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Badge Style Icon
                              Container(
                                padding: EdgeInsets.all(6.sp),
                                decoration: BoxDecoration(
                                    color: primaryWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: primaryColor.withOpacity(0.2)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.1),
                                        blurRadius: 4,
                                      )
                                    ]),
                                child: Icon(Icons.auto_awesome,
                                    color: primaryColor, size: 14.sp),
                              ),
                              width10,
                              Text(
                                "BETA VERSION".tr,
                                style: AppTextStyle.normalBold12.copyWith(
                                  color: primaryColor,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const Spacer(),
                              // Optional Close or Tag
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  "v1.0.0".tr,
                                  style: AppTextStyle.normalBold10
                                      .copyWith(color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                          height10,
                          Text(
                            "This app is currently in Beta, which means some features may be incomplete, under testing, or subject to change. You may experience occasional issues or variations. We appreciate your feedback as we work to improve the app."
                                .tr,
                            style: AppTextStyle.normalRegular13.copyWith(
                              color: lightBlackColor,
                              height: 1.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _safeCloseCurrentOverlay() {
    FocusManager.instance.primaryFocus?.unfocus();
    final navigator = Navigator.of(context);
    if (navigator.canPop()) {
      navigator.pop();
    } else if (Get.key.currentState?.canPop() ?? false) {
      Get.key.currentState?.pop();
    }
  }

  void _showShareOptionSheet({
    required String contentId,
    required String contentTitle,
  }) {
    CommonMethod.showCustomBottomSheet(
      title: "Select an Option".tr,
      message: "Please choose how you would like to share.".tr,
      showCancelButton: true,
      cancelButtonTextColor: redColor,
      customWidget: SizedBox(
        width: Get.width,
        child: Column(
          children: [
            PrimaryTextButton(
              title: "Choose from Contacts".tr,
              onPressed: () async {
                _safeCloseCurrentOverlay();
                Get.to(() => ContactScreen())!.then((value) {
                  if (contactController.selectedContact.value.isNotEmpty) {
                    nameTextController.text =
                        contactController.selectedContact.value;
                    phoneTextController.text =
                        contactController.selectedContactNumber.value;
                    selectedEmail =
                        contactController.selectedContactEmail.value;
                    _showShareSheet(
                      contentId: contentId,
                      contentTitle: contentTitle,
                    );
                  }
                });
              },
            ),
            height15,
            PrimaryTextButton(
              title: "Enter Name Manually".tr,
              onPressed: () {
                _safeCloseCurrentOverlay();
                nameTextController.clear();
                phoneTextController.clear();
                selectedEmail = null;
                _showShareSheet(
                  contentId: contentId,
                  contentTitle: contentTitle,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showShareSheet({
    required String contentId,
    required String contentTitle,
  }) {
    final RxString generatedLink = ''.obs;
    final RxString resolvedShareFileId = contentId.obs;
    messageTextController.clear();

    CommonMethod.showCustomBottomSheet(
      title: "Generate Link To Share".tr,
      message: null,
      showCancelButton: true,
      cancelButtonTitle: "Close".tr,
      cancelButtonTextColor: redColor,
      customWidget: SizedBox(
        width: Get.width,
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= STEP 1 =================
                if (generatedLink.isEmpty) ...[
                  _instruction(
                      "1",
                      "Enter the name to track the responses from this person with."
                          .tr),
                  _instruction(
                      "2",
                      "Click on \"Generate a Link\" button to create a link that you are going to send to this person."
                          .tr),
                  height15,
                  TextFormFieldWidget(
                    controller: nameTextController,
                    labelText: "Enter recipient name".tr,
                    hintText: "e.g. John Doe".tr,
                    prefixIcon:
                        const Icon(Icons.person, color: lightBlackColor),
                  ),
                  height15,
                  PrimaryTextButton(
                    title: "Generate a Link".tr,
                    onPressed: () async {
                      if (nameTextController.text.trim().isEmpty) {
                        CommonMethod.getXSnackBar("Error".tr,
                            "Please enter recipient name".tr, redColor);
                        return;
                      }

                      if (contentId.startsWith('call_announcement_')) {
                        final callFileId = await categoriesController
                            .getCallAnnouncementShareFileId(context: null);
                        if (callFileId == null) {
                          CommonMethod.getXSnackBar(
                            "Error".tr,
                            "Failed to generate link".tr,
                            redColor,
                          );
                          return;
                        }
                        resolvedShareFileId.value = callFileId.toString();
                      } else {
                        resolvedShareFileId.value = contentId;
                      }

                      final linkData = await categoriesController.generateLink(
                        context: context,
                        fileId: resolvedShareFileId.value,
                        SharedTo: nameTextController.text.trim(),
                      );

                      if (linkData == null || linkData['shareUrl'] == null) {
                        CommonMethod.getXSnackBar(
                            "Error".tr, "Failed to generate link".tr, redColor);
                        return;
                      }

                      final shareUrl = linkData['shareUrl'] as String;
                      final savedShareId = linkData['savedShareId'];

                      generatedLink.value = shareUrl;

                      Get.put<dynamic>(savedShareId,
                          tag: 'savedShareId_${resolvedShareFileId.value}');

                      final dashboard = homeController.dashboardModel.value;
                      final senderName =
                          (dashboard?.name ?? "").trim().isNotEmpty
                              ? (dashboard?.name ?? "").trim()
                              : (dashboard?.userName ?? "Someone");

                      final recipientName = nameTextController.text.trim();
                      messageTextController.text =
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
                  height15,
                  _bullet(
                      "A personalized message has been created for the recipient."
                          .tr),
                  _bullet("You can review and edit the message if needed.".tr),
                  _bullet(
                      "Click Share to send the message to the recipient.".tr),
                  height15,
                  TextFormFieldWidget(
                    controller: messageTextController,
                    maxLines: 4,
                    labelText: "Message".tr,
                    hintText: "Write a message for the recipient".tr,
                  ),
                  height15,
                  PrimaryTextButton(
                    title: "Share".tr,
                    onPressed: () async {
                      _safeCloseCurrentOverlay();

                      final savedShareId = Get.find<dynamic>(
                          tag: 'savedShareId_${resolvedShareFileId.value}');

                      ShareBottomSheet.show(
                        context: context,
                        phoneNumber: phoneTextController.text.trim(),
                        message: messageTextController.text.trim(),
                        email: selectedEmail,
                        onShared: (platform) async {
                          await categoriesController.mobileSaveFileShare(
                            context: context,
                            fileId: resolvedShareFileId.value,
                            sharedUrl: generatedLink.value,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _instruction(String step, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 22.sp,
            height: 22.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Text(step,
                style: AppTextStyle.normalBold12.copyWith(color: primaryColor)),
          ),
          SizedBox(width: 10.sp),
          Expanded(
            child: Text(text,
                style: AppTextStyle.normalRegular13
                    .copyWith(color: lightBlackColor)),
          ),
        ],
      ),
    );
  }

  Widget _bullet(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("•  ".tr),
          Expanded(
            child: Text(text,
                style: AppTextStyle.normalRegular13
                    .copyWith(color: lightBlackColor)),
          ),
        ],
      ),
    );
  }
}
