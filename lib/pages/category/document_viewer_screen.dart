import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/home_controller.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/network_image_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';

import '../../controller/categories_controller.dart';
import '../../controller/contact_controller.dart';
import '../../model/category_file_model.dart';
import '../../utils/audio_player_widget.dart';
import '../../utils/document_viewer_widget.dart';
import '../../utils/full_screen_image_viewer.dart';
import '../../utils/static_decoration.dart';
import '../../utils/video_player_widget.dart';
import 'contact_screen.dart';

class DocumentViewerScreen extends StatefulWidget {
  final CategoryFileModel data;

  const DocumentViewerScreen({super.key, required this.data});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  final homeController = Get.put(HomeController());
  final controller = Get.put(CategoriesController());
  final contactController = Get.put(ContactController());
  final nameTextController = TextEditingController();
  final phoneTextController = TextEditingController();
  final messageTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  /// Pull-to-refresh functionality
  Future<void> _onRefresh() async {
    // Refresh document/file details from the API
    await controller.getSubCategoriesFiles(
      null,
      widget.data.id ?? "0",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: primaryColor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.sp),
            children: [
              height20,
              // Text(
              //   widget.data.fileName ?? "-",
              //   style: AppTextStyle.normalExtraBold,
              // ),
              // height20,
              buildFileViewWidget(widget.data),
              height20,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFileViewWidget(CategoryFileModel data) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.sp),
      child: ShadowContainerWidget(
        padding: 12.sp,
        radius: 12.sp,
        blurRadius: 0,
        borderWidth: 1,
        widget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.sp),
              child: GestureDetector(
                onTap: () {
                  if (GetUtils.isVideo(data.filePath!)) {
                    Get.to(() => VideoPlayerWidget(videoUrl: data.filePath!));
                  } else if (GetUtils.isImage(data.filePath!)) {
                    Get.to(
                        () => FullScreenImageViewer(imageUrl: data.filePath!));
                  } else if (GetUtils.isAudio(data.filePath!) ||
                      data.fileType == '.m4a') {
                    CommonMethod.getXSnackBar(
                        "Audio", "Playing audio file.", primaryBlack);
                  } else {
                    Get.to(() => DocumentViewerWidget(
                          filePath: data.filePath!,
                          fileName: data.fileName ?? "Document",
                        ));
                  }
                },
                child: SizedBox(
                  width: Get.width,
                  height: 140.sp,
                  child: data.filePath != null &&
                          GetUtils.isVideo(data.filePath!)
                      ? VideoPlayerWidget(videoUrl: data.filePath!)
                      : GetUtils.isImage(data.filePath!)
                          ? NetworkImageWidget(
                              imageUrl: data.filePath!, fit: BoxFit.cover)
                          : GetUtils.isAudio(data.filePath!) ||
                                  data.fileType == '.m4a'
                              ? AudioPlayerWidget(audioUrl: data.filePath!)
                              : DocumentViewerWidget(
                                  filePath: data.filePath!,
                                  fileName: data.fileName ?? "Document Name",
                                ),
                ),
              ),
            ),
            customHeight(8),
            Text(
              data.fileName ?? "Document Name",
              style: AppTextStyle.normalBold14,
              maxLines: 10,
              overflow: TextOverflow.ellipsis,
            ),
            height14,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text(
                //   "${(data.sizeInMb ?? 0).toStringAsFixed(2)} MB",
                //   style: AppTextStyle.normalRegular12
                //       .copyWith(color: hintGreyColor),
                // ),
                IconButton(
                  onPressed: () async {
                    CommonMethod.showCustomBottomSheet(
                      title: "Select an Option",
                      message: "Please choose how you would like to share.",
                      showCancelButton: true,
                      cancelButtonTextColor: redColor,
                      customWidget: SizedBox(
                        width: Get.width,
                        child: Column(
                          children: [
                            PrimaryTextButton(
                              title: "Choose from Contacts",
                              onPressed: () async {
                                Get.back();
                                Get.to(() => ContactScreen())!.then((value) {
                                  if (contactController
                                      .selectedContact.value.isNotEmpty) {
                                    nameTextController.text =
                                        contactController.selectedContact.value;
                                    phoneTextController.text = contactController
                                        .selectedContactNumber.value;
                                    showEnterDetailsManuallySheet(data);
                                  }
                                });
                              },
                            ),
                            height15,
                            PrimaryTextButton(
                              title: "Enter Name Manually",
                              onPressed: () {
                                Get.back();
                                nameTextController.clear();
                                phoneTextController.clear();
                                showEnterDetailsManuallySheet(widget.data);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: Row(
                    children: [
                      SvgPicture.asset(
                        AppAsset.share,
                        height: 18.sp,
                        width: 18.sp,
                        fit: BoxFit.scaleDown,
                      ),
                      width06,
                      Text("Share")
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void showEnterDetailsManuallySheet(CategoryFileModel data) {
    final RxString generatedLink = ''.obs;

    CommonMethod.showCustomBottomSheet(
      title: 'Generate Link To Share',
      message: null,
      showCancelButton: true,
      cancelButtonTitle: "Close",
      cancelButtonTextColor: redColor,
      customWidget: SizedBox(
        width: Get.width,
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ================= STEP 1 =================
              if (generatedLink.value.isEmpty) ...[
                _instruction("1",
                    "Enter the name to track the responses from this person with."),
                _instruction("2",
                    "Click on \"Generate a Link\" button to create a link that you are going to send to this person."),
                height15,
                TextFormFieldWidget(
                  controller: nameTextController,
                  labelText: 'Enter recipient name',
                  hintText: 'e.g. John Doe',
                  prefixIcon: const Icon(Icons.person, color: lightBlackColor),
                ),
                height15,
                PrimaryTextButton(
                  title: "Generate a Link",
                  onPressed: () async {
                    if (nameTextController.text.trim().isEmpty) {
                      CommonMethod.getXSnackBar(
                          "Error", "Please enter recipient name", redColor);
                      return;
                    }

                    final link = await controller.generateLink(
                      context: context,
                      fileId: data.id.toString(),
                      SharedTo: nameTextController.text.trim(),
                    );

                    if (link == null || link.isEmpty) {
                      CommonMethod.getXSnackBar(
                          "Error", "Failed to generate link", redColor);
                      return;
                    }

                    generatedLink.value = link;

                    messageTextController.text =
                        "Hey ${nameTextController.text}, ${homeController.dashboardModel.value?.userName} has shared some information with you. "
                        "Visit the link to view it. $link";
                  },
                ),
              ],

              /// ================= STEP 2 =================
              if (generatedLink.value.isNotEmpty) ...[
                /// Generated link box (blue)
                ShadowContainerWidget(
                  blurRadius: 0,
                  borderWidth: 1,
                  borderColor: primaryColor,
                  color: primaryColor.withOpacity(.10),
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

                /// Web-style bullets
                _bullet(
                    "A personalized message has been created for the recipient."),
                _bullet("You can review and edit the message if needed."),
                _bullet("Click Share to send the message to the recipient."),

                height15,

                TextFormFieldWidget(
                  controller: messageTextController,
                  maxLines: 4,
                  labelText: "Message",
                  hintText: "Write a message for the recipient",
                ),

                height15,

                PrimaryTextButton(
                  title: "Share",
                  onPressed: () {
                    Get.back();

                    controller.shareFileUsingBottomSheet(
                      context: context,
                      data: data,
                      phoneNumber: phoneTextController.text.trim(),
                      message: messageTextController.text.trim(),
                      sharedUrl: generatedLink.value,
                    );
                  },
                ),
              ],
            ],
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
              color: primaryColor.withOpacity(0.15),
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
          const Text("•  "),
          Expanded(
            child: Text(text,
                style: AppTextStyle.normalRegular13
                    .copyWith(color: lightBlackColor)),
          ),
        ],
      ),
    );
  }

  Widget buildInstructionStep({
    required String step,
    required String text,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Step Number
          Container(
            width: 22.sp,
            height: 22.sp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Text(
              step,
              style: AppTextStyle.normalBold12.copyWith(color: primaryColor),
            ),
          ),

          SizedBox(width: 10.sp),

          /// Step Text
          Expanded(
            child: Text(
              text,
              style:
                  AppTextStyle.normalRegular13.copyWith(color: lightBlackColor),
            ),
          ),
        ],
      ),
    );
  }
}
