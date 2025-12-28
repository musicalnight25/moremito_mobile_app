import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/flyer_templates_controller.dart';
import '../../model/flyer_template_model.dart';
import '../../model/preview_response_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/colors.dart';
import '../../utils/no_data_found.dart';
import 'flyer_detail_screen.dart';
import 'flyer_preview_screen.dart';

class FlyerTemplatesScreen extends StatefulWidget {
  const FlyerTemplatesScreen({super.key});

  @override
  State<FlyerTemplatesScreen> createState() => _FlyerTemplatesScreenState();
}

class _FlyerTemplatesScreenState extends State<FlyerTemplatesScreen> {
  final controller = Get.put(FlyerTemplatesController());

  @override
  void initState() {
    super.initState();
    controller.fetchTemplates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.isLoading.value) {
            return _shimmer();
          }

          if (controller.templates.isEmpty) {
            return const NoDataFound(title: "No Flyers Found");
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              /// 🔹 HEADER
              Text(
                "List of Flyers",
                style: AppTextStyle.normalBold20,
              ),
              const SizedBox(height: 6),
              Text(
                "Tap a flyer to preview, customize, or share",
                style: AppTextStyle.normalRegular14
                    .copyWith(color: Colors.black54),
              ),
              const SizedBox(height: 16),

              /// 🔹 LIST
              ...controller.templates.map((item) => _flyerCard(item)).toList(),
            ],
          );
        }),
      ),
    );
  }

  // ------------------------------------------------------------------

  Widget _flyerCard(FlyerTemplateModel item) {
    return GestureDetector(
      onTap: () {
        Get.to(() => FlyerDetailScreen(templateId: item.templateId!));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title ?? "",
              style: AppTextStyle.normalBold18,
            ),
            const SizedBox(height: 6),
            Text(
              item.subtitle ?? "",
              style:
                  AppTextStyle.normalRegular14.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Icon(Icons.visibility, size: 18),
                SizedBox(width: 6),
                Text("Preview & Customize"),
                Spacer(),
                Icon(Icons.arrow_forward_ios, size: 16),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------------
  // SHIMMER
  Widget _shimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
