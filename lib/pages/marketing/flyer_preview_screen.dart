import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/flyer_templates_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';

class FlyerPreviewScreen extends StatelessWidget {
  final controller = Get.find<FlyerTemplatesController>();

  FlyerPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Flyer Preview",
            style: TextStyle(color: Color(0xFF1E4691))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final template = controller.template.value;
        final user = controller.userInfo.value;

        if (template == null || user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(
                  bottom: 100, left: 16, right: 16, top: 10),
              child: Column(
                children: [
                  _buildMainHeader(template),
                  const SizedBox(height: 15),
                  _buildHeroImageSection(),
                  const SizedBox(height: 15),
                  _buildSectionCard(
                    title: "Company Overview & Testimonials",
                    child: _buildVideoPlaceholder(),
                  ),
                  const SizedBox(height: 15),
                  _buildScientistCredit(),
                  const SizedBox(height: 15),
                  _buildProductCard(
                    "ULTRAMITO RESTORE",
                    "Works from the inside out growing mitochondria to increase cellular energy...",
                  ),
                  const SizedBox(height: 15),
                  _buildContactInfo(user),
                  const SizedBox(height: 15),
                  _buildQRCodeSection(user),
                  const SizedBox(height: 15),
                  _buildFooter(user),
                ],
              ),
            ),
            _buildBottomActionButtons(),
          ],
        );
      }),
    );
  }

  // 1. Blue Header
  Widget _buildMainHeader(template) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF4A69BD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            template.title?.toUpperCase() ?? "MOREMITO HEALTH SOLUTIONS",
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Text(
            template.subtitle ?? "Reboot your Mitochondria!",
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // 2. Hero Image Section
  Widget _buildHeroImageSection() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1511632765486-a01980e01a18?q=80&w=1000",
            // Generic family image
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black.withOpacity(0.6),
              padding: const EdgeInsets.all(10),
              child: const Text(
                "Mitochondria are what's keeping you alive right now...",
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          )
        ],
      ),
    );
  }

  // 3. Contact Info Section (Matching image_d9b12b.png)
  Widget _buildContactInfo(user) {
    return _buildSectionCard(
      title: "CONTACT INFORMATION",
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
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
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
                text: "$label ",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 12)),
            TextSpan(
                text: value ?? "",
                style: const TextStyle(color: Colors.black54, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // 4. QR Code Section
  Widget _buildQRCodeSection(user) {
    return _buildSectionCard(
      title: "SCAN TO VISIT",
      child: Column(
        children: [
          if (user.qrCodeImagePath != null)
            Image.network(user.qrCodeImagePath!, height: 150, width: 150),
          const SizedBox(height: 10),
          const Text(
              "Scan this QR code with your mobile device to visit our website",
              style: TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  // Helper Card Builder
  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDF5),
        borderRadius: BorderRadius.circular(12),
        border:
            const Border(left: BorderSide(color: Color(0xFF1E4691), width: 4)),
      ),
      child: Column(
        children: [
          Text(title.toUpperCase(),
              style: const TextStyle(
                  color: Color(0xFF1E4691),
                  fontWeight: FontWeight.bold,
                  fontSize: 16)),
          const SizedBox(height: 15),
          child,
        ],
      ),
    );
  }

  Widget _buildProductCard(String title, String desc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border:
            const Border(left: BorderSide(color: Color(0xFF1E4691), width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Color(0xFF1E4691), fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF26C281),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text("Click Here",
                style: TextStyle(color: Colors.white, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildScientistCredit() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EDF5),
        borderRadius: BorderRadius.circular(12),
        border:
            const Border(left: BorderSide(color: Color(0xFF1E4691), width: 4)),
      ),
      child: const Text(
        "Created by scientist and formulator Dr. Bevan Elliott.",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Color(0xFF1E4691),
            fontWeight: FontWeight.bold,
            fontSize: 14),
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFF2C3E50),
      child: const Icon(Icons.play_circle_fill, color: Colors.white, size: 50),
    );
  }

  Widget _buildFooter(user) {
    return Column(
      children: [
        const Text("MoreMito Health Solutions - Reboot your Mitochondria!",
            style: TextStyle(fontSize: 10)),
        Text("© 2025 MoreMito Health Solutions. All rights reserved.",
            style: TextStyle(fontSize: 10)),
        Text("This flyer was generated on December 26, 2025",
            style: TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildBottomActionButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Row(
          children: [
            Expanded(child: _actionButton("Print PDF", Icons.print)),
            const SizedBox(width: 15),
            Expanded(child: _actionButton("Download PDF", Icons.download)),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String title, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 16, color: Colors.white),
      label: Text(title,
          style: const TextStyle(color: Colors.white, fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1E4691),
        padding: const EdgeInsets.symmetric(vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
