import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../model/categories_model.dart';
import '../model/category_file_model.dart';
import '../service/network_repository.dart';
import '../utils/colors.dart';
import '../utils/common_method.dart';

class CategoriesController extends GetxController {
  final NetworkRepository _networkRepository = NetworkRepository();

  RxList<CategoryModel> categoriesList = <CategoryModel>[].obs;
  RxList<CategoryFileModel> categoriesFileList = <CategoryFileModel>[].obs;
  RxList<CategoryModel> subCategoriesList = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool hasMore = true.obs;
  int _page = 1;
  RxString searchText = ''.obs;
  RxBool isGlobalSearch = false.obs;
  RxString globalSearchText = ''.obs;

  Future<void> getCategoriesList(BuildContext context) async {
    isLoading.value = true;
    try {
      var response = await _networkRepository.getCategoriesList();
      if (response != null) {
        final model = categoryResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          categoriesList.value = model.data ?? [];
        }
      }
    } catch (e) {
      print("Error in getCategoriesList: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubCategories(
      BuildContext? context, String categoryID) async {
    isLoading.value = true;
    try {
      var response =
          await _networkRepository.getSubCategories(context, categoryID);
      if (response != null) {
        final model = categoryResponseModelFromJson(json.encode(response));
        if (model.status == true) {
          subCategoriesList.value = model.data ?? [];
        }
      }
    } catch (e) {
      print("Error in getSubCategories: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSubCategoriesFiles(
    BuildContext? context,
    String subCategoryId, {
    String? searchText,
    bool loadMore = false,
  }) async {
    if (isLoading.value) return;

    if (!loadMore) {
      _page = 1;
      categoriesFileList.clear();
      hasMore.value = true;
    }

    isLoading.value = true;

    try {
      final response = await _networkRepository.getSubCategoriesFiles(
        context,
        subCategoryId,
        searchText: searchText,
        pageNumber: _page,
      );

      final model = CategoryFileResponseModel.fromJson(response);

      if (model.data != null) {
        categoriesFileList.addAll(model.data!.files);
        hasMore.value = model.data!.hasMore;

        if (model.data!.hasMore) {
          _page++;
        }
      }
    } catch (e) {
      debugPrint("getSubCategoriesFiles error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void globalSearchFiles(String? searchText) {
    isGlobalSearch.value = searchText != null && searchText.isNotEmpty;
    globalSearchText.value = searchText ?? '';

    getSubCategoriesFiles(
      null,
      "", // ✅ SubCategoryId MUST be null/empty
      searchText: searchText,
      loadMore: false,
    );
  }

  void resetGlobalSearch() {
    isGlobalSearch.value = false;
    globalSearchText.value = '';
    categoriesFileList.clear();
  }

  void resetAndSearch(String? text, String subCategoryId) {
    searchText.value = text ?? "";

    _page = 1;
    categoriesFileList.clear();
    hasMore.value = true;
    getSubCategoriesFiles(null, subCategoryId, searchText: text);
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
      var response =
          await _networkRepository.mobileSaveFileShare(context, data);
      if (response != null) {}
    } catch (e) {
      print("Error in mobileSaveFileShare: $e");
    }
  }

  Future<String?> generateLink({
    required BuildContext context,
    required String fileId,
    required String SharedTo,
  }) async {
    try {
      var data = {"FileId": fileId, "SharedTo": SharedTo};
      var response = await _networkRepository.generateLink(context, data);
      if (response != null && response['Data'] != null) {
        return response['Data'];
      }
    } catch (e) {
      print("Error in generateLink: $e");
    }
    return null;
  }

  Future<void> shareFile({
    required CategoryFileModel data,
    required String message,
    required String sharedUrl,
    required String recipientName,
  }) async {
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
}
