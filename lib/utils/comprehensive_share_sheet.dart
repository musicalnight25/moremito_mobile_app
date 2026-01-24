// import 'package:flutter/material.dart';
// import 'package:more_mitro_app/utils/colors.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
//
// import '../service/global_share_service.dart';
//
// class ComprehensiveShareSheet extends StatelessWidget {
//   final String shareContent;
//   final String? personName;
//   const ComprehensiveShareSheet(
//       {required this.shareContent, required this.personName});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           GridView.count(
//             shrinkWrap: true,
//             crossAxisCount: 4,
//             mainAxisSpacing: 20,
//             children: [
//               _buildItem(
//                   "WhatsApp",
//                   PhosphorIcons.whatsappLogo(),
//                   () =>
//                       GlobalShareService.toWhatsApp(shareContent, personName)),
//               _buildItem(
//                   "Telegram",
//                   PhosphorIcons.telegramLogo(),
//                   () =>
//                       GlobalShareService.toTelegram(shareContent, personName)),
//               _buildItem("Twitter", PhosphorIcons.twitterLogo(),
//                   () => GlobalShareService.toTwitter(shareContent, personName)),
//               _buildItem(
//                   "Facebook",
//                   PhosphorIcons.facebookLogo(),
//                   () =>
//                       GlobalShareService.toFacebook(shareContent, personName)),
//               _buildItem(
//                   "Email",
//                   PhosphorIcons.envelope(),
//                   () => GlobalShareService.toEmail(
//                       "Check this out", shareContent, personName)),
//               _buildItem("SMS", PhosphorIcons.chatCircleText(),
//                   () => GlobalShareService.toSMS(shareContent, personName)),
//               _buildItem("Copy", PhosphorIcons.copy(), () {
//                 // Logic to copy to clipboard
//                 Navigator.pop(context);
//               }),
//               _buildItem("More", PhosphorIcons.shareNetwork(),
//                   () => GlobalShareService.toSystem(shareContent, personName)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildItem(String label, IconData icon, VoidCallback onTap) {
//     return InkWell(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, size: 32, color: primaryColor),
//           const SizedBox(height: 8),
//           Text(label,
//               style: const TextStyle(fontSize: 11),
//               textAlign: TextAlign.center),
//         ],
//       ),
//     );
//   }
// }
