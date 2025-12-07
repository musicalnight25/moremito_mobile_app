import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
import '../main_dashboard_screen.dart';

class DocumentViewerScreen extends StatefulWidget {
  final CategoryFileModel data;

  const DocumentViewerScreen({super.key, required this.data});

  @override
  State<DocumentViewerScreen> createState() => _DocumentViewerScreenState();
}

class _DocumentViewerScreenState extends State<DocumentViewerScreen> {
  final controller = Get.put(CategoriesController());
  final contactController = Get.put(ContactController());
  final TextEditingController nameTextController = TextEditingController();
  final TextEditingController messageTextController = TextEditingController();

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${(data.sizeInMb ?? 0).toStringAsFixed(2)} MB",
                  style: AppTextStyle.normalRegular12
                      .copyWith(color: hintGreyColor),
                ),
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
                              buttonColor: primaryBlack,
                              title: "Choose from Contacts",
                              onPressed: () {
                                Get.back();
                                Get.to(() => ContactScreen())!.then((value) {
                                  if (contactController
                                      .selectedContact.value.isNotEmpty) {
                                    nameTextController.text =
                                        contactController.selectedContact.value;
                                    showEnterDetailsManuallySheet(data);
                                  }
                                });
                              },
                            ),
                            height15,
                            PrimaryTextButton(
                              buttonColor: primaryBlack,
                              title: "Enter Details Manually",
                              onPressed: () {
                                Get.back();
                                showEnterDetailsManuallySheet(widget.data);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  icon: SvgPicture.asset(
                    AppAsset.share,
                    height: 18.sp,
                    width: 18.sp,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  showEnterDetailsManuallySheet(CategoryFileModel data) {
    RxString generatedLinkText = ''.obs;
    CommonMethod.showCustomBottomSheet(
      title: 'Secure File Sharing',
      showCancelButton: false,
      message:
          'Enter recipient details to monitor link activity and ensure secure sharing.',
      customWidget: SizedBox(
        width: Get.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldWidget(
              controller: nameTextController,
              labelText: 'Recipient details',
              hintText: 'Please enter a name, email, or phone number...',
              prefixIcon: Icon(Icons.person, color: lightBlackColor),
            ),
            height15,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => generatedLinkText.value.isEmpty
                      ? Expanded(
                          child: PrimaryTextButton(
                            buttonColor: primaryBlack,
                            title: "Generate Secure Link",
                            onPressed: () async {
                              if (nameTextController.text.isEmpty) {
                                return CommonMethod.getXSnackBar(
                                  "Error",
                                  "Please enter name, email, or phone number...",
                                  redColor,
                                );
                              }
                              generatedLinkText.value =
                                  await controller.generateLink(
                                          context: context,
                                          fileId: data.id.toString(),
                                          SharedTo: nameTextController.text) ??
                                      "";
                              final String message =
                                  "Dear ${nameTextController.text},\n\n${homeController.dashboardModel.value?.userName ?? "A colleague"} has shared a file with you.\n\n📂 File Access Link:\n${generatedLinkText.value}\n\nBest regards,\n${homeController.dashboardModel.value?.name ?? "Support Team"}";

                              messageTextController.text = message;
                            },
                          ),
                        )
                      : Expanded(
                          child: ShadowContainerWidget(
                            blurRadius: 0,
                            borderWidth: 1,
                            borderColor: primaryColor,
                            color: primaryColor.withOpacity(.2),
                            widget: Text(
                              generatedLinkText.value,
                              style: AppTextStyle.normalBold12,
                            ),
                          ),
                        ),
                ),
              ],
            ),
            Obx(
              () => generatedLinkText.value.isEmpty
                  ? const SizedBox(height: 10)
                  : Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.sp),
                          child: Column(
                            children: [
                              TextFormFieldWidget(
                                controller: messageTextController,
                                hintText:
                                    'Include an optional message for the recipient.',
                                labelText: "Add a Personalized Message",
                                maxLines: 5,
                              ),
                              height15,
                              PrimaryTextButton(
                                title: "Share File",
                                buttonColor: primaryBlack,
                                onPressed: () {
                                  if (messageTextController.text.isEmpty) {
                                    CommonMethod.getXSnackBar(
                                        "Error",
                                        "Please enter personalized message.",
                                        redColor);
                                    return;
                                  }
                                  if (nameTextController.text.isEmpty) {
                                    CommonMethod.getXSnackBar(
                                        "Error",
                                        "Please enter recipient details.",
                                        redColor);
                                    return;
                                  }
                                  Get.back();
                                  controller.shareFile(
                                      data,
                                      messageTextController.text,
                                      generatedLinkText.value);
                                },
                              )
                            ],
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
}
