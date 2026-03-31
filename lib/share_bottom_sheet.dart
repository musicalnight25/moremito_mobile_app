import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_method.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../service/message_launcher.dart';

class ShareBottomSheet {
  static void show({
    required BuildContext context,
    required String phoneNumber,
    required String message,
    String? email,
    required Function(String platform) onShared,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildItem(
                icon: PhosphorIconsFill.whatsappLogo,
                label: "WhatsApp".tr,
                color: Colors.green,
                onTap: () async {
                  Navigator.pop(context);
                  await MessageLauncher.openWhatsApp(
                    phoneNumber: phoneNumber,
                    message: message,
                  );
                  onShared("whatsapp");
                },
              ),
              _buildItem(
                icon: PhosphorIconsFill.chatCircleText,
                label: "Message".tr,
                color: Colors.blue,
                onTap: () async {
                  Navigator.pop(context);
                  await MessageLauncher.sendSMS(
                    phoneNumber: phoneNumber,
                    message: message,
                  );
                  onShared("message");
                },
              ),
              if (email != null && email.isNotEmpty)
                _buildItem(
                  icon: PhosphorIconsFill.envelopeSimple,
                  label: "Email".tr,
                  color: Colors.redAccent,
                  onTap: () async {
                    Navigator.pop(context);
                    await MessageLauncher.sendEmail(
                      email: email,
                      subject: "File Shared with You",
                      body: message,
                    );
                    onShared("email");
                  },
                ),
              _buildItem(
                icon: PhosphorIconsRegular.dotsThreeOutline,
                label: "More".tr,
                color: Colors.grey,
                onTap: () async {
                  Navigator.pop(context);

                  ShareResult result = await Share.share(message,
                      subject: "File Shared with You");
                  String platform = "";
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
                    "com.samsung.android.app.simplesharing":
                        "Samsung Quick Share",
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
                  platformMap.forEach((key, value) {
                    if (result.raw.contains(key)) {
                      platform = value;
                    }
                  });
                  if (platform != '') {
                    if (result.status == ShareResultStatus.success) {
                      onShared("other");
                      CommonMethod.getXSnackBar(
                        "Success 🎉".tr, 
                        "You're amazing! 🌟 Thank you for sharing on $platform. We truly appreciate your support! 🙌😊".tr,
                        greenColor,
                      );
                    } else if (result.status == ShareResultStatus.dismissed) {
                      CommonMethod.getXSnackBar(
                        "No Share 😕".tr, 
                        "Looks like the share wasn’t completed. No worries! You can try again whenever you're ready. We appreciate you! ❤️".tr,
                        primaryBlack,
                      );
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  static Widget _buildItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
