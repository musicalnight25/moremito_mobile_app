import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/flyer_templates_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/colors.dart';
import 'flyer_preview_screen.dart';

class FlyerDetailScreen extends StatefulWidget {
  final int templateId;

  const FlyerDetailScreen({super.key, required this.templateId});

  @override
  State<FlyerDetailScreen> createState() => _FlyerDetailScreenState();
}

class _FlyerDetailScreenState extends State<FlyerDetailScreen> {
  final controller = Get.put(FlyerTemplatesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchTemplateDetail(widget.templateId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        visibleBackButton: true,
        title: "Customize Flyer",
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.flyerTemplateDetailModel.value?.template == null) {
            return const Center(child: Text("No flyer data found"));
          }

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPreviewBanner(
                      controller.flyerTemplateDetailModel.value?.template),
                  const SizedBox(height: 25),
                  _buildSectionHeader(
                      "Personal Details", "Update how you appear on the flyer"),
                  _infoCard(
                      controller.flyerTemplateDetailModel.value?.userFlyer),
                  const SizedBox(height: 30),
                  _bottomActionButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  // 1. TOP PREVIEW BANNER (Visual Focus)
  Widget _buildPreviewBanner(template) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5))
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          const SizedBox(height: 12),
          Text(
            (template.title ?? "Flyer Template").toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            template.subtitle ?? "Customize your business outreach",
            style:
                TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String sub) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppTextStyle.normalBold18.copyWith(color: Colors.black87)),
          Text(sub, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  // 2. MODERN FORM CARD
  Widget _infoCard(user) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Column(
        children: [
          _modernInput("Full Name", Icons.person_outline, user?.name),
          const SizedBox(height: 16),
          _modernInput("Email Address", Icons.email_outlined, user?.email),
          const SizedBox(height: 16),
          _modernInput(
              "Phone Number", Icons.phone_android_outlined, user?.phone),
          const SizedBox(height: 16),
          _modernInput(
              "Website URL", Icons.language_outlined, user?.websiteLink),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.snackbar("Success", "Information updated locally!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.white);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text("SAVE CHANGES",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  // 3. HELPER FOR MODERN TEXT FIELDS
  Widget _modernInput(String label, IconData icon, String? initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54)),
        ),
        TextFormField(
          initialValue: initialValue ?? "",
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: primaryColor),
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ],
    );
  }

  // 4. BOTTOM ACTION ROW
  Widget _bottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _actionButton(
              "PREVIEW",
              Icons.remove_red_eye_rounded,
              orangeColor,
              () => Get.to(() => FlyerPreviewScreen(
                    templateId: widget.templateId,
                  ))),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _actionButton(
              "SHARE FLYER", Icons.share_rounded, const Color(0xFF6C63FF),
              () async {
            await controller.shareTemplates(
                controller.flyerTemplateDetailModel.value!.template!);
          }),
        ),
      ],
    );
  }

  Widget _actionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
