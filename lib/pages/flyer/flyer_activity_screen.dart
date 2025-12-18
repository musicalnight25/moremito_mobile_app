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
import '../../utils/static_decoration.dart';

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
  // ACTIVITY CARD (WEB MATCH)
  // ------------------------------------------------------------
  Widget _activityTile(FlyerInteractionModel item) {
    return Container(
      width: Get.width,
      margin: EdgeInsets.only(bottom: 12.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.sp),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // DATE
          Text(
            _formatDate(item.createdOn),
            style: AppTextStyle.normalRegular12.copyWith(color: Colors.grey),
          ),

          SizedBox(height: 8.sp),

          // INTERACTION TYPE
          Row(
            children: [
              _interactionIcon(item.interactionType),
              SizedBox(width: 6.sp),
              Text(
                _titleFromType(item.interactionType),
                style: AppTextStyle.normalSemiBold16,
              ),
            ],
          ),

          SizedBox(height: 6.sp),

          // VALUE
          if ((item.interactionValue ?? "").isNotEmpty)
            Text(
              "Value: ${item.interactionValue}",
              style:
                  AppTextStyle.normalRegular14.copyWith(color: Colors.black87),
            ),

          SizedBox(height: 4.sp),

          // IP ADDRESS
          if ((item.ipAddress ?? "").isNotEmpty)
            Text(
              "IP: ${item.ipAddress}",
              style:
                  AppTextStyle.normalRegular13.copyWith(color: Colors.black54),
            ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------
  String _titleFromType(String? type) {
    switch (type) {
      case "play_video":
        return "Video Played";
      case "product_click":
        return "Product Clicked";
      case "button_click":
        return "Button Clicked";
      default:
        return "Interaction";
    }
  }

  Icon _interactionIcon(String? type) {
    switch (type) {
      case "button_click":
        return Icon(Icons.touch_app, size: 18.sp, color: primaryColor);
      case "product_click":
        return Icon(Icons.shopping_cart_outlined,
            size: 18.sp, color: primaryColor);
      case "play_video":
        return Icon(Icons.play_circle_outline,
            size: 18.sp, color: primaryColor);
      default:
        return Icon(Icons.flash_on_outlined, size: 18.sp, color: primaryColor);
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "-";
    final dt = date.toLocal();
    return "${dt.day.toString().padLeft(2, '0')}/"
        "${dt.month.toString().padLeft(2, '0')}/"
        "${dt.year}  "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
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
            return const NoDataFound(title: "No interactions yet");
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(16.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyle.normalBold14.copyWith(
                    color: primaryBlack,
                    height: 1.4,
                  ),
                ),
                // height04,
                // Text(
                //   _getDescriptionByTitle(widget.title),
                //   style: AppTextStyle.normalRegular14.copyWith(
                //     color: Colors.black54,
                //     height: 1.4,
                //   ),
                // ),
                height10,
                // HEADER CARD
                Container(
                  width: Get.width,
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
