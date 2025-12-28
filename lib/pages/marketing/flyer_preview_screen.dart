import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/network_image_widget.dart';
import '../../controller/flyer_templates_controller.dart';
import '../../model/preview_response_model.dart';
import '../../utils/colors.dart';
import '../../utils/video_player_widget.dart';

class FlyerPreviewScreen extends StatefulWidget {
  final int templateId;

  const FlyerPreviewScreen({super.key, required this.templateId});

  @override
  State<FlyerPreviewScreen> createState() => _FlyerPreviewScreenState();
}

class _FlyerPreviewScreenState extends State<FlyerPreviewScreen> {
  final controller = Get.find<FlyerTemplatesController>();

  @override
  void initState() {
    super.initState();
    // Fetch data dynamically on load
    controller.fetchFlyerPreview(widget.templateId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          // Handling Loading State
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final preview = controller.previewModel.value;

          if (preview == null) {
            return const Center(child: Text("No Preview Data Available"));
          }

          final user = preview.userFlyerInfo;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildFlyerHeader(preview),
                      const SizedBox(height: 16),
                      _buildHeroImage(preview),
                      const SizedBox(height: 16),
                      _buildVideoCard(context, preview),
                      const SizedBox(height: 16),
                      _buildActionButtons(),
                      const SizedBox(height: 16),
                      _buildScientistCard(preview),
                      const SizedBox(height: 16),
                      _buildInfoHighlightCard(preview),
                      const SizedBox(height: 16),
                      _buildProductList(preview.products ?? []),
                      const SizedBox(height: 16),
                      if (user != null) _buildContactInfoCard(user),
                      const SizedBox(height: 16),
                      _buildFDAWarningCard(),
                      const SizedBox(height: 16),
                      if (user != null) _buildQRCard(user),
                      const SizedBox(height: 24),
                      _buildFooter(preview),
                    ],
                  ),
                ),
              ),
              _buildBottomActionButtons(),
            ],
          );
        }),
      ),
    );
  }

  // --- Header Card (Dynamic Title/Subtitle) ---
  Widget _buildFlyerHeader(PreviewModel preview) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3B5FC7),
            Color(0xFF2C4DA6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            (preview.title ?? "MOREMITO HEALTH SOLUTIONS").toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            preview.subtitle ?? "Reboot your Mitochondria!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontSize: 15,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  // --- Hero Image Section (Dynamic Content) ---
  Widget _buildHeroImage(PreviewModel preview) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1511632765486-a01980e01a18?q=80&w=1200",
            height: 330.sp,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 16,
            left: 16,
            child: Image.asset(AppAsset.logo, height: 36),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    preview.templateName ??
                        "Mitochondria are what’s keeping you alive right now.",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.55),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    "CLICK HERE TO LEARN HOW THEY CAN ALSO HELP YOU GET MORE OUT OF LIFE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Dynamic Video Card ---
  Widget _buildVideoCard(BuildContext context, PreviewModel preview) {
    return _cardWrapper(
      title: "Company Overview & Testimonials",
      child: Column(
        children: [
          Text(
            preview.templateName ??
                "Mitochondria are the tiny furnaces in your body!",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () {
              if (preview.videoUrl != null) {
                Get.to(() => VideoPlayerWidget(videoUrl: preview.videoUrl!));
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.network(
                    "https://images.unsplash.com/photo-1576091160550-2173dba999ef?q=80&w=1000",
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Container(height: 200, color: Colors.black.withOpacity(0.35)),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle),
                    padding: const EdgeInsets.all(14),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white, size: 40),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _actionButton(text: "Click here for more Testimonials", onTap: () {}),
          const SizedBox(height: 14),
          _actionButton(
              text: "Click here for more Information and to Order",
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _actionButton({required String text, required VoidCallback onTap}) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4))
          ],
        ),
        child: Center(
          child: Text(text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87)),
        ),
      ),
    );
  }

  // --- Scientist Card (Dynamic) ---
  Widget _buildScientistCard(PreviewModel preview) {
    return _cardWrapper(
      child: Text(
        preview.scientistTitle ??
            "Created by scientist and formulator Dr. Bevan Elliott.",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
      ),
    );
  }

  // --- Dynamic Intro Highlight ---
  Widget _buildInfoHighlightCard(PreviewModel preview) {
    return _cardWrapper(
      child: Text(
        preview.scientistIntro ??
            "Mitochondria are the components in your cells that produce energy...",
        style: const TextStyle(
            fontSize: 14, height: 1.6, color: Color(0xFF333333)),
      ),
    );
  }

  // --- Dynamic Product List ---
  Widget _buildProductList(List<ProductModel> products) {
    return Column(
      children: products
          .map((product) => Column(
                children: [
                  _productItem(
                      product.productName ?? "",
                      product.productDescription ?? "",
                      product.productLink ?? ""),
                  const SizedBox(height: 12),
                ],
              ))
          .toList(),
    );
  }

  Widget _productItem(String title, String desc, String link) {
    return _cardWrapper(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 6),
          Text(desc,
              style: const TextStyle(
                  fontSize: 13, color: Colors.black87, height: 1.4)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(horizontal: 20),
            ),
            child: const Text("Click Here",
                style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  // --- Contact Info (Dynamic) ---
  Widget _buildContactInfoCard(UserFlyerInfoModel user) {
    return _cardWrapper(
      title: "CONTACT INFORMATION",
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            _contactRow("Contact Person:", user.name),
            _contactRow("Phone:", user.phone),
            _contactRow("Email:", user.email),
            _contactRow("Website:", user.websiteLink),
          ],
        ),
      ),
    );
  }

  Widget _contactRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("$label ",
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          Flexible(
              child:
                  Text(value ?? "N/A", style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _buildFDAWarningCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(left: BorderSide(color: primaryColor, width: 4)),
      ),
      child: const Text(
        "This product has not been evaluated by the Food and Drug Administration. This product is not intended to diagnose, treat, cure, or prevent any disease.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  // --- Dynamic QR Code ---
  Widget _buildQRCard(UserFlyerInfoModel user) {
    return _cardWrapper(
      title: "SCAN TO VISIT",
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade200),
                borderRadius: BorderRadius.circular(12)),
            child: NetworkImageWidget(
                imageUrl: user.qrCodeImagePath ?? "", height: 120, width: 120),
          ),
          const SizedBox(height: 10),
          const Text(
              "Scan this QR code with your mobile device to visit our website",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // --- Dynamic Footer ---
  Widget _buildFooter(PreviewModel preview) {
    return Column(
      children: [
        Text(preview.templateName ?? "MoreMito Health Solutions",
            style: TextStyle(
                fontSize: 11,
                color: primaryColor,
                fontWeight: FontWeight.bold)),
        const Text("© 2025 MoreMito Health Solutions. All rights reserved.",
            style: TextStyle(fontSize: 10, color: Colors.grey)),
        Text("Generated on: ${preview.createdOn?.toString() ?? "N/A"}",
            style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
      ],
    );
  }

  // --- Bottom PDF Actions ---
  Widget _buildBottomActionButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: Row(
        children: [
          Expanded(
              child:
                  _actionBtn(Icons.picture_as_pdf, "Print PDF", primaryColor)),
          const SizedBox(width: 12),
          Expanded(
              child: _actionBtn(Icons.download, "Download PDF", primaryColor)),
        ],
      ),
    );
  }

  Widget _actionBtn(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18, color: Colors.white),
      label: Text(label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _cardWrapper({required Widget child, String? title}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
        border: Border(left: BorderSide(color: primaryColor, width: 4)),
      ),
      child: Column(
        children: [
          if (title != null) ...[
            Text(title,
                style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            const SizedBox(height: 12),
          ],
          child,
        ],
      ),
    );
  }
}
