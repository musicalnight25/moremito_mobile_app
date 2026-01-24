// import 'package:flutter/services.dart'; // Required for Clipboard
// import 'package:share_plus/share_plus.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class GlobalShareService {
//   static Future<void> _launchApp(Uri url, String fallbackText) async {
//     await launchUrl(
//       url,
//     );
//   }
//
//   // Copies text to mobile clipboard
//   static void copyToClipboard(String text) {
//     Clipboard.setData(ClipboardData(text: text));
//   }
//
//   // Opens WhatsApp directly to a chat if phoneNumber is provided
//   static void toWhatsApp(String text, String? phoneNumber) {
//     final url = (phoneNumber != null && phoneNumber.isNotEmpty)
//         ? Uri.parse(
//             "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(text)}")
//         : Uri.parse("whatsapp://send?text=${Uri.encodeComponent(text)}");
//     _launchApp(url, text);
//   }
//
//   static void toTelegram(String text, String? username) {
//     final url = (username != null && username.isNotEmpty)
//         ? Uri.parse(
//             "https://t.me/${username.replaceAll('@', '')}?text=${Uri.encodeComponent(text)}")
//         : Uri.parse(
//             "https://t.me/share/url?url=&text=${Uri.encodeComponent(text)}");
//     _launchApp(url, text);
//   }
//
//   static void toTwitter(String text, String? personName) {
//     final url = Uri.parse(
//         "https://twitter.com/intent/tweet?text=${Uri.encodeComponent(text)}");
//     _launchApp(url, text);
//   }
//
//   static void toFacebook(String text, String? personName) {
//     final url = Uri.parse(
//         "https://www.facebook.com/sharer/sharer.php?u=${Uri.encodeComponent(text)}");
//     _launchApp(url, text);
//   }
//
//   static void toEmail(String subject, String body, String? email) {
//     final url = Uri.parse(
//         "mailto:${email ?? ''}?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}");
//     _launchApp(url, body);
//   }
//
//   static void toSMS(String text, String? phoneNumber) {
//     final url =
//         Uri.parse("sms:${phoneNumber ?? ''}?body=${Uri.encodeComponent(text)}");
//     _launchApp(url, text);
//   }
//
//   static void toSystem(String text, String? personName) => Share.share(text);
// }
