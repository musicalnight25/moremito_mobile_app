import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';

import '../../controller/flyers_controller.dart';
import '../../model/flyer_interaction_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';

class FlyerActivityScreen extends StatefulWidget {
  final int sharedFlyerId;
  final String title;
  final String sharedTo;

  const FlyerActivityScreen({
    super.key,
    required this.sharedFlyerId,
    required this.title,
    required this.sharedTo,
  });

  @override
  State<FlyerActivityScreen> createState() => _FlyerActivityScreenState();
}

class _FlyerActivityScreenState extends State<FlyerActivityScreen> {
  final FlyersController controller = Get.find<FlyersController>();

  @override
  void initState() {
    super.initState();
    controller.getFlyerInteractions(
      sharedFlyerId: widget.sharedFlyerId,
    );
  }

  // ------------------------------------------------------------
  // ACTIVITY TILE (FIGMA)
  // ------------------------------------------------------------
  Widget _activityTile(FlyerInteraction item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _titleFromType(item.interactionType),
            style: AppTextStyle.normalSemiBold16,
          ),
          SizedBox(height: 4.sp),
          Text(
            item.interactionValue ?? "",
            style: AppTextStyle.normalRegular14.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 6.sp),
          Text(
            _formatDate(item.timestamp),
            style: AppTextStyle.normalRegular12.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _titleFromType(String? type) {
    switch (type) {
      case "play_video":
        return "Play Video";
      case "product_click":
        return "Product Click";
      case "button_click":
        return "Button Click";
      default:
        return "Interaction";
    }
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "-";
    try {
      final dt = DateTime.parse(iso).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}  "
          "${dt.hour.toString().padLeft(2, '0')}:"
          "${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return "-";
    }
  }

  // ------------------------------------------------------------
  // BUILD
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        title: widget.title,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          if (controller.activityLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.interactions.isEmpty) {
            return const NoDataFound(title: "No Activity Found");
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CARD
                Container(
                  padding: EdgeInsets.all(16.sp),
                  decoration: BoxDecoration(
                    color: primaryWhite,
                    borderRadius: BorderRadius.circular(16.sp),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Activity By",
                        style: AppTextStyle.normalRegular14
                            .copyWith(color: Colors.black54),
                      ),
                      SizedBox(height: 4.sp),
                      Text(
                        widget.sharedTo,
                        style: AppTextStyle.normalSemiBold18,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16.sp),

                // ACTIVITY LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.interactions.length,
                  itemBuilder: (context, index) {
                    return _activityTile(controller.interactions[index]);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
