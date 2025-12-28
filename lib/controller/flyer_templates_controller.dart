import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../model/flyer_template_detail_model.dart';
import '../model/flyer_template_model.dart';
import '../model/preview_response_model.dart';
import '../pages/category/contact_screen.dart';
import '../service/network_repository.dart';
import '../utils/app_text_style.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';
import '../utils/input_text_field_widget.dart';
import '../utils/primary_text_button.dart';
import '../utils/shadow_container_widget.dart';
import '../utils/static_decoration.dart';
import 'contact_controller.dart';
import 'home_controller.dart';

class FlyerTemplatesController extends GetxController {
  final NetworkRepository _repo = NetworkRepository();
  RxBool isLoading = false.obs;
  RxList<FlyerTemplateModel> templates = <FlyerTemplateModel>[].obs;
  Rx<FlyerTemplateDetailModel?> flyerTemplateDetailModel =
      Rx<FlyerTemplateDetailModel?>(null);
  Rx<FlyerTemplateModel?> previewModel = Rx<FlyerTemplateModel?>(null);
  final contactController = Get.put(ContactController());
  final nameTextController = TextEditingController();
  final messageTextController = TextEditingController();
  final homeController = Get.put(HomeController());

  Future<void> fetchTemplates() async {
    try {
      isLoading.value = true;
      final response = await _repo.getFlyerTemplates();
      final parsed = flyerTemplateResponseFromJson(json.encode(response));
      templates.assignAll(parsed.data);
    } catch (e) {
      Get.log("❌ Error fetching templates: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTemplateDetail(int templateId) async {
    try {
      isLoading.value = true;
      final response = await _repo.getFlyerTemplateDetail(
        queryParameters: {'templateId': templateId},
      );
      final parsed = FlyerTemplateDetailResponseModel.fromJson(response);
      flyerTemplateDetailModel.value = parsed.data;
    } catch (e) {
      Get.log("❌ Error fetching template detail: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchFlyerPreview(int templateId) async {
    try {
      isLoading.value = true;
      final response = await _repo.getFlyerPreview(
        queryParameters: {'templateId': templateId},
      );
      final parsed = PreviewResponseModel.fromJson(response);
      previewModel.value = parsed.data;
    } catch (e) {
      Get.log("❌ Error fetching preview data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void clearAll() {
    templates.clear();
    previewModel.value = null;
    flyerTemplateDetailModel.value = null;
  }

  Future<String?> generateLink({
    required BuildContext context,
    required String fileId,
    required String SharedTo,
  }) async {
    try {
      var data = {
        "FileId": fileId,
        "SharedTo": SharedTo,
        "UserFlyerGuid": "b86e1133-3ccc-457a-9b6b-07ce674d555e"
      };
      var response = await _repo.generateLink(context, data);
      if (response != null && response['Data'] != null) {
        return response['Data'];
      }
    } catch (e) {
      print("Error in generateLink: $e");
    }
    return null;
  }

  shareTemplates(FlyerTemplateModel data) {
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
              onPressed: () {
                Get.back();
                Get.to(() => ContactScreen())!.then((value) {
                  if (contactController.selectedContact.value.isNotEmpty) {
                    nameTextController.text =
                        contactController.selectedContact.value;
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
                showEnterDetailsManuallySheet(data);
              },
            ),
          ],
        ),
      ),
    );
  }

  void showEnterDetailsManuallySheet(FlyerTemplateModel data) {
    final RxString generatedLink = ''.obs;

    CommonMethod.showCustomBottomSheet(
      title: 'Generate Link',
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
                    final link = await generateLink(
                      context: Get.context!,
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
                    shareFile(
                      data,
                      messageTextController.text.trim(),
                      generatedLink.value,
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

  Future<void> shareFile(
      FlyerTemplateModel data, String message, String sharedUrl) async {
    ShareResult result =
        await Share.share(message, subject: "File Shared with You");
    String platform = ""; // Default message

    // Mapping package names to platform names
    Map<String, String> platformMap = {
      "com.facebook.katana": "Facebook",
      "com.whatsapp": "WhatsApp",
      "com.twitter.android": "x",
      "com.instagram.android": "Instagram",
      "com.google.android.apps.messaging": "Messages",
      "com.google.android.gm": "Gmail",
      "com.microsoft.office.outlook": "Outlook",
      "com.linkedin.android": "LinkedIn",
      "com.tencent.mm": "WeChat",
      "jp.naver.line.android": "LINE",
      "com.google.android.talk": "Google Chat",
      "org.telegram.messenger": "Telegram",
      "com.snapchat.android": "Snapchat",
      "com.skype.raider": "Skype",
      "com.google.android.apps.docs": "Google Drive",
      "com.dropbox.android": "Dropbox",
      "com.google.android.apps.photos": "Google Photos",
      "com.samsung.android.messaging": "Samsung Messages",
      "com.google.android.gms": "Google Sharing",
      "com.android.bluetooth": "Bluetooth Share",
      "com.android.systemui.clipboard": "Copy",
      "com.android.printspooler": "Print",
      "com.google.android.apps.translate": "Google Translate",
      "com.microsoft.translator": "Microsoft Translator",
      "com.google.earth": "Google Earth",
      "com.strava": "Strava",
      "com.fitnesskeeper.runkeeper.pro": "RunKeeper",
      "com.fitbit.FitbitMobile": "Fitbit",
      "com.google.android.calendar": "Google Calendar",
      "com.amazon.mShop.android.shopping": "Amazon",
      "com.ebay.mobile": "eBay",
      "com.alibaba.aliexpresshd": "AliExpress",
      "com.wish.android": "Wish",
      "com.flipkart.android": "Flipkart",
      "com.myntra.android": "Myntra",
      "com.snapdeal.main": "Snapdeal",
      "com.phonepe.app": "PhonePe",
      "com.google.android.apps.walletnfcrel": "Google Pay",
      "com.paypal.android.p2pmobile": "PayPal",
      "com.netflix.mediaclient": "Netflix",
      "com.amazon.avod.thirdpartyclient": "Amazon Prime Video",
      "com.google.android.youtube": "YouTube",
      "com.spotify.music": "Spotify",
      "com.tidal": "TIDAL",
      "com.pandora.android": "Pandora",
      "com.deezer.android.app": "Deezer",
      "tv.hulu.app": "Hulu",
      "com.hbo.hbonow": "HBO Max",
      "com.plexapp.android": "Plex",
      "com.google.android.keep": "Google Keep",
      "com.microsoft.todos": "Microsoft To-Do",
      "com.evernote": "Evernote",
      "com.notion.android": "Notion",
      "com.todoist": "Todoist",
      "com.asana.app": "Asana",
      "com.trello": "Trello",
      "com.mindjet.mindmanager": "MindManager",
      "com.wunderkinder.wunderlistandroid": "Wunderlist",
      "com.splendapps.splendo": "SplenDo",
      "com.lenovo.anyshare.gps": "SHAREit",
      "cn.xender": "Xender",
      "com.google.android.apps.nbu.files": "Google Files",
      "com.vivo.easyshare": "Vivo EasyShare",
      "com.samsung.android.app.simplesharing": "Samsung Quick Share",
      "com.coloros.oppo.transfer": "Oppo Share",
      "com.mi.android.globalFileexplorer": "Mi Share",
      "com.apple.airdrop": "AirDrop (iOS)",
      "com.quickshare": "Quick Share",
      "com.wifidirect.share": "Wi-Fi Direct",
      "com.android.chrome": "Google Chrome",
      "org.mozilla.firefox": "Firefox",
      "com.microsoft.emmx": "Microsoft Edge",
      "com.opera.browser": "Opera Browser",
      "com.brave.browser": "Brave Browser",
      "com.kiwibrowser.browser": "Kiwi Browser",
      "com.lynket.browser": "Lynket Browser",
      "com.uc.browser.en": "UC Browser",
      "com.yandex.browser": "Yandex Browser",
      "com.duckduckgo.mobile.android": "DuckDuckGo",
      "com.microsoft.skydrive": "OneDrive",
      "com.box.android": "Box",
      "com.wetransfer.app.live": "WeTransfer",
      "com.mediafire.android": "MediaFire",
      "mega.privacy.android.app": "MEGA",
      "com.nextcloud.client": "Nextcloud",
      "com.owncloud.android": "ownCloud",
      "com.sendanywhere": "Send Anywhere",
      "com.yahoo.mobile.client.android.mail": "Yahoo Mail",
      "com.my.mail": "myMail",
      "com.fsck.k9": "K-9 Mail",
      "com.samsung.android.email.provider": "Samsung Email",
      "com.zoho.mail": "Zoho Mail",
      "com.protonmail.android": "Proton Mail",
      "ru.yandex.mail": "Yandex Mail",
      "com.huawei.email": "Huawei Mail",
      "com.discord": "Discord",
      "com.viber.voip": "Viber",
      "com.facebook.orca": "Facebook Messenger",
      "org.thoughtcrime.securesms": "Signal",
      "com.imo.android.imoim": "Imo",
      "com.kakao.talk": "KakaoTalk",
      "com.zhiliaoapp.musically": "TikTok DM",
      "com.hike.chat.stickers": "Hike Messenger",
      "com.pinterest": "Pinterest",
      "com.reddit.frontpage": "Reddit",
      "tv.twitch.android.app": "Twitch",
      "com.quora.android": "Quora",
      "com.tumblr": "Tumblr",
      "com.clubhouse.app": "Clubhouse",
      "com.mewe": "MeWe",
      "com.gettr.gettr": "GETTR",
      "com.minds.mobile": "Minds",
      "com.weverse.app": "Weverse",
    };

// Identify platform name
    platformMap.forEach((key, value) {
      if (result.raw.contains(key)) {
        platform = value;
      }
    });
    if (platform != '') {
      if (result.status == ShareResultStatus.success) {
        mobileSaveFileShare(
          context: Get.context!,
          fileId: data.id.toString(),
          sharedUrl: sharedUrl,
          sharedBy: platform.toLowerCase(),
        );

        CommonMethod.getXSnackBar(
            "Success 🎉",
            "You're amazing! 🌟 Thank you for sharing on $platform. We truly appreciate your support! 🙌😊",
            greenColor);
      } else if (result.status == ShareResultStatus.dismissed) {
        CommonMethod.getXSnackBar(
            "No Share 😕",
            "Looks like the share wasn’t completed. No worries! You can try again whenever you're ready. We appreciate you! ❤️",
            primaryBlack);
      }
    }
  }

  Future<void> mobileSaveFileShare({
    required BuildContext context,
    required String fileId,
    required String sharedBy,
    required String sharedUrl,
  }) async {
    try {
      var data = {
        "FileId": fileId,
        "SharedBy": sharedBy,
        "SharedUrl": sharedUrl
      };
      var response = await _repo.mobileSaveFileShare(context, data);
      if (response != null) {}
    } catch (e) {
      print("Error in mobileSaveFileShare: $e");
    }
  }
}
