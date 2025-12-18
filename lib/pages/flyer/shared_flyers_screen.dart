import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';

import '../../controller/flyers_controller.dart';
import '../../model/shared_flyers_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/static_decoration.dart';
import 'flyer_activity_screen.dart';

class SharedFlyersScreen extends StatefulWidget {
  final String title;
  final String filterKey;

  const SharedFlyersScreen({
    super.key,
    required this.title,
    required this.filterKey,
  });

  @override
  State<SharedFlyersScreen> createState() => _SharedFlyersScreenState();
}

class _SharedFlyersScreenState extends State<SharedFlyersScreen> {
  final FlyersController controller = Get.put(FlyersController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Safety: load first page if opened directly
    if (controller.sharedFlyers.isEmpty) {
      controller.getSharedFlyers(filterKey: widget.filterKey);
    }

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!controller.hasMore) return;
    if (controller.loadMoreLoading.value) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      controller.getSharedFlyers(filterKey: widget.filterKey);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------
  // CARD (FIGMA MATCH)
  // ------------------------------------------------------------
  Widget _tile(SharedFlyerItem item) {
    final int total = item.totalInteractions ?? 0;
    final bool isViewEnabled = total > 0;
    return InkWell(
      borderRadius: BorderRadius.circular(14.sp),
      onTap: isViewEnabled
          ? () {
              Get.to(() => FlyerActivityScreen(
                    sharedFlyerId: item.fileShareId!,
                    title: item.title ?? "",
                    sharedTo: item.sharedTo ?? "",
                  ));
            }
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.sp),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              item.title ?? "Untitled",
              style: AppTextStyle.normalSemiBold16,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: 4.sp),

            // SUBTITLE
            if ((item.subTitle ?? "").isNotEmpty)
              Text(
                item.subTitle!,
                style: AppTextStyle.normalRegular14
                    .copyWith(color: Colors.black54),
              ),

            SizedBox(height: 4.sp),

            // DATE
            Text(
              _formatDate(item.sharedOn),
              style: AppTextStyle.normalRegular13.copyWith(color: Colors.grey),
            ),

            SizedBox(height: 14.sp),

            // SHARED TO + LAST ACTIVITY
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person_outline,
                  size: 20.sp,
                  color: Colors.black,
                ),
                SizedBox(width: 10.sp),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Shared To:",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.black54),
                    ),
                    SizedBox(height: 2.sp),
                    Text(
                      item.sharedTo ?? "-",
                      style: AppTextStyle.normalSemiBold16,
                    ),
                    SizedBox(height: 2.sp),
                    Text(
                      "Last Activity: ${_lastActivityText(item)}",
                      style: AppTextStyle.normalRegular13
                          .copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(height: 14.sp),

            Divider(color: Colors.grey.shade300),

            SizedBox(height: 8.sp),

            // TOTAL + EYE ICON
            Row(
              children: [
                Icon(
                  Icons.refresh,
                  size: 20.sp,
                  color: primaryColor,
                ),
                SizedBox(width: 6.sp),
                Text(
                  "Total: ${item.totalInteractions ?? 0}",
                  style: AppTextStyle.normalSemiBold14,
                ),
                const Spacer(),
                if (isViewEnabled)
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 22.sp,
                    color: Colors.black,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _lastActivityText(SharedFlyerItem item) {
    if (item.lastInteractionDate == null || item.lastInteractionDate!.isEmpty) {
      return "No activity";
    }
    return _formatDate(item.lastInteractionDate);
  }

  // ------------------------------------------------------------
  // DATE FORMAT
  // ------------------------------------------------------------
  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return "${dt.day.toString().padLeft(2, '0')}/"
          "${dt.month.toString().padLeft(2, '0')}/"
          "${dt.year}";
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
        // title: widget.title,
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          // INITIAL LOADING
          if (controller.listLoading.value && controller.sharedFlyers.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // EMPTY STATE
          if (controller.sharedFlyers.isEmpty) {
            return const NoDataFound(title: "Shared Flyers");
          }

          return RefreshIndicator(
            color: primaryColor,
            onRefresh: () async {
              controller.resetPagination();
              await controller.getSharedFlyers(
                filterKey: widget.filterKey,
              );
            },
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.sp),
              itemCount: controller.sharedFlyers.length +
                  (controller.loadMoreLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < controller.sharedFlyers.length) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: AppTextStyle.normalBold20.copyWith(
                                    color: primaryBlack,
                                    height: 1.4,
                                  ),
                                ),
                                height04,
                                Text(
                                  _getDescriptionByTitle(widget.title),
                                  style: AppTextStyle.normalRegular14.copyWith(
                                    color: Colors.black54,
                                    height: 1.4,
                                  ),
                                ),
                                height10
                              ],
                            )
                          : SizedBox(),
                      _tile(controller.sharedFlyers[index]),
                    ],
                  );
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.sp),
                    child: Center(
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                }
              },
            ),
          );
        }),
      ),
    );
  }

  String _getDescriptionByTitle(String title) {
    return "Below is the list of flyers you shared during $title.";
  }
}
