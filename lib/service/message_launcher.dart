import 'package:url_launcher/url_launcher.dart';

class MessageLauncher {
  /// Send SMS
  static Future<void> sendSMS({
    required String phoneNumber,
    required String message,
  }) async {
    final Uri uri = Uri.parse(
      'sms:$phoneNumber?body=${Uri.encodeComponent(message)}',
    );

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch SMS';
    }
  }

  /// Open WhatsApp
  static Future<void> openWhatsApp({
    required String phoneNumber,
    required String message,
  }) async {
    final String formattedPhone =
    phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');

    final Uri uri = Uri.parse(
      'https://wa.me/$formattedPhone?text=${Uri.encodeComponent(message)}',
    );

    if (!await canLaunchUrl(uri)) {
      throw 'WhatsApp not installed';
    }

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  /// WhatsApp → fallback to SMS
  static Future<void> sendMessageSmart({
    required String phoneNumber,
    required String message,
  }) async {
    try {
      await openWhatsApp(phoneNumber: phoneNumber, message: message);
    } catch (_) {
      await sendSMS(phoneNumber: phoneNumber, message: message);
    }
  }
}
