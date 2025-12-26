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
      backgroundColor: const Color(0xFFF0F2F5), // Light greyish background
      appBar: const CommonAppBar(title: "Flyer Details"),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final template = controller.template.value;
          final user = controller.userInfo.value;

          if (template == null) {
            return const Center(child: Text("No flyer data found"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [
                _header(template),
                const SizedBox(height: 30),
                _infoCard(user),
                const SizedBox(height: 40),
                _bottomActionButtons(),
              ],
            ),
          );
        }),
      ),
    );
  }

  // ---------------- HEADER ----------------
  Widget _header(template) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E4691), // Solid dark blue from image
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            (template.title ?? "MOREMITO HEALTH SOLUTIONS").toUpperCase(),
            style: AppTextStyle.normalBold20
                .copyWith(color: Colors.white, letterSpacing: 1.2),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            template.subtitle ?? "Reboot your Mitochondria!",
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ---------------- FORM CARD ----------------
  Widget _infoCard(user) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          // Section Title with Orange Underline
          Column(
            children: [
              Text(
                "Customize With Your Information",
                style: AppTextStyle.normalBold18
                    .copyWith(color: const Color(0xFF1E4691)),
              ),
              const SizedBox(height: 4),
              Container(height: 2, width: 40, color: Colors.orange),
            ],
          ),
          const SizedBox(height: 30),

          // Grid-like layout for inputs
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _input("Full Name *", user?.name,
                      "This will appear as the contact person on your flyer")),
              const SizedBox(width: 20),
              Expanded(
                  child: _input("Email Address", user?.email,
                      "Your email for customer inquiries")),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: _input("Phone Number", user?.phone,
                      "Your contact phone number")),
              const SizedBox(width: 20),
              Expanded(
                  child: _input("Website URL", user?.websiteLink,
                      "Your personal website")),
            ],
          ),

          const SizedBox(height: 40),

          // Update Button
          SizedBox(
            width: 200,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save, size: 18, color: Colors.white),
              label: const Text("UPDATE FLYER",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E4691),
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- BOTTOM ACTIONS (PREVIEW, DOWNLOAD, SHARE) ----------------
  Widget _bottomActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _pillButton("PREVIEW", Icons.visibility, const Color(0xFF26C281)),
        const SizedBox(width: 15),
        _pillButton("DOWNLOAD", Icons.download, const Color(0xFFFF912C)),
        const SizedBox(width: 15),
        _pillButton("SHARE", Icons.share, const Color(0xFF7E57C2)),
      ],
    );
  }

  // ---------------- HELPERS ----------------
  Widget _input(String label, String? value, String helper) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyle.normalBold14
                .copyWith(color: const Color(0xFF1E4691))),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value ?? "",
          style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF9F9F9),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          helper,
          style: const TextStyle(
              fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _pillButton(String label, IconData icon, Color color) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          Get.to(() => FlyerPreviewScreen());
        },
        icon: Icon(icon, size: 16, color: Colors.white),
        label: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
