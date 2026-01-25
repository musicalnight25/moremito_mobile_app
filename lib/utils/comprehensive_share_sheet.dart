import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../service/global_share_service.dart';

class ComprehensiveShareSheet extends StatelessWidget {
  final String shareContent;
  final String? phoneNumber;
  final String? username;
  final String? email;

  final Function(String platform) onShared; // 👈 callback

  const ComprehensiveShareSheet({
    super.key,
    required this.shareContent,
    this.phoneNumber,
    this.username,
    this.email,
    required this.onShared,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
        children: [
          _buildItem("WhatsApp", PhosphorIcons.whatsappLogo(), () {
            GlobalShareService.toWhatsApp(
              text: shareContent,
              phoneNumber: phoneNumber,
            );
            onShared("whatsapp");
            Navigator.pop(context);
          }),
          _buildItem("Telegram", PhosphorIcons.telegramLogo(), () {
            GlobalShareService.toTelegram(
              text: shareContent,
              username: username,
            );
            onShared("telegram");
            Navigator.pop(context);
          }),
          _buildItem("Twitter", PhosphorIcons.twitterLogo(), () {
            GlobalShareService.toTwitter(text: shareContent);
            onShared("twitter");
            Navigator.pop(context);
          }),
          _buildItem("Facebook", PhosphorIcons.facebookLogo(), () {
            GlobalShareService.toFacebook(text: shareContent);
            onShared("facebook");
            Navigator.pop(context);
          }),
          _buildItem("Email", PhosphorIcons.envelope(), () {
            GlobalShareService.toEmail(
              subject: "Check this out",
              body: shareContent,
              email: email,
            );
            onShared("email");
            Navigator.pop(context);
          }),
          _buildItem("SMS", PhosphorIcons.chatCircleText(), () {
            GlobalShareService.toSMS(
              text: shareContent,
              phoneNumber: phoneNumber,
            );
            onShared("sms");
            Navigator.pop(context);
          }),
          _buildItem("Copy", PhosphorIcons.copy(), () {
            GlobalShareService.copyToClipboard(shareContent);
            onShared("copy");
            Navigator.pop(context);
          }),
          _buildItem("More", PhosphorIcons.shareNetwork(), () {
            GlobalShareService.toSystem(shareContent);
            onShared("system");
            Navigator.pop(context);
          }),
        ],
      ),
    );
  }

  Widget _buildItem(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.blue),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}
