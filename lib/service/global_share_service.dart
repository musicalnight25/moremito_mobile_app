import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalShareService {
  static Future<void> _launchApp(Uri url, String fallbackText) async {
    if (!await canLaunchUrl(url)) {
      Share.share(fallbackText);
    } else {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  // Copy to clipboard
  static void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  // ================== WHATSAPP ==================
  static void toWhatsApp({
    required String text,
    String? phoneNumber,
  }) {
    final Uri url = (phoneNumber != null && phoneNumber.isNotEmpty)
        ? Uri.parse(
            "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(text)}")
        : Uri.parse("whatsapp://send?text=${Uri.encodeComponent(text)}");

    _launchApp(url, text);
  }

  // ================== TELEGRAM ==================
  static void toTelegram({
    required String text,
    String? username,
  }) {
    final Uri url = (username != null && username.isNotEmpty)
        ? Uri.parse(
            "https://t.me/${username.replaceAll('@', '')}?text=${Uri.encodeComponent(text)}")
        : Uri.parse("https://t.me/share/url?text=${Uri.encodeComponent(text)}");

    _launchApp(url, text);
  }

  // ================== TWITTER ==================
  static void toTwitter({
    required String text,
    String? username,
  }) {
    final Uri url = Uri.parse(
      "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}",
    );

    _launchApp(url, text);
  }

  // ================== FACEBOOK ==================
  static void toFacebook({
    required String text,
    String? username,
  }) {
    final Uri url = Uri.parse(
      "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(text)}",
    );

    _launchApp(url, text);
  }

  // ================== EMAIL ==================
  static void toEmail({
    required String subject,
    required String body,
    String? email,
  }) {
    final Uri url = Uri.parse(
      "mailto:${email ?? ''}"
      "?subject=${Uri.encodeComponent(subject)}"
      "&body=${Uri.encodeComponent(body)}",
    );

    _launchApp(url, body);
  }

  // ================== SMS ==================
  static void toSMS({
    required String text,
    String? phoneNumber,
  }) {
    final Uri url = Uri.parse(
      "sms:${phoneNumber ?? ''}?body=${Uri.encodeComponent(text)}",
    );

    _launchApp(url, text);
  }

  // ================== SYSTEM SHARE ==================
  static void toSystem(String text) {
    Share.share(text);
  }
}
