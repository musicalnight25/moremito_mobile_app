import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:more_mitro_app/controller/flyers_controller.dart';
import 'package:more_mitro_app/model/shared_reports_with_me_model.dart';
import 'package:more_mitro_app/pages/marketing/shared_links_activity_screen.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class SharedReportsWithMeScreen extends StatefulWidget {
  const SharedReportsWithMeScreen({super.key});

  @override
  State<SharedReportsWithMeScreen> createState() =>
      _SharedReportsWithMeScreenState();
}

class _SharedReportsWithMeScreenState extends State<SharedReportsWithMeScreen> {
  final FlyersController controller = Get.isRegistered<FlyersController>()
      ? Get.find<FlyersController>()
      : Get.put(FlyersController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.getSharedReportsWithMe();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        controller.hasMoreSharedWithMe.value &&
        !controller.sharedReportsWithMeLoading.value) {
      controller.getSharedReportsWithMe(loadMore: true);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── VIEW: open the shared user's report in a webview ──────────────────────
  void _viewReport(SharedReportWithMeItem item) {
    Get.to(
      () => SharedLinksActivityScreen(
        userId: item.sharedByUserId ?? 0,
        userName: item.sharedByName ?? item.sharedByUserName ?? 'User',
        userHandle: item.sharedByUserName,
      ),
    );
  }

  // ── DECLINE confirm dialog ─────────────────────────────────────────────────
  Future<void> _confirmDecline(SharedReportWithMeItem item) async {
    final commentController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        title: Text(
          'Decline Report',
          style: AppTextStyle.normalBold16.copyWith(color: primaryBlack),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Decline report shared by '
              '"${item.sharedByName ?? item.sharedByUserName ?? ''}"?',
              style:
                  AppTextStyle.normalRegular14.copyWith(color: subTitleColor),
            ),
            height12,
            TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Reason (optional)',
                hintStyle: AppTextStyle.normalRegular14
                    .copyWith(color: borderGreyColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: borderGreyColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: primaryColor),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 10.sp),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style:
                  AppTextStyle.normalRegular14.copyWith(color: subTitleColor),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Decline',
              style: AppTextStyle.normalBold14.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await controller.declineReportShare(
          item.id ?? 0, commentController.text.trim());
      if (success) {
        Get.snackbar(
          'Declined',
          'Report share declined successfully.',
          backgroundColor: Colors.orangeAccent.shade700,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16.sp),
        );
      }
    }
  }

  // ── CARD ──────────────────────────────────────────────────────────────────
  Widget _buildCard(SharedReportWithMeItem item) {
    final name = item.sharedByName ?? item.sharedByUserName ?? '-';
    final initials = name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    final date = item.createdUtc != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(item.createdUtc!)
        : '-';

    return Container(
      padding: EdgeInsets.all(14.sp),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderGreyColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar + name/username/date ────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar
              CircleAvatar(
                radius: 22.r,
                backgroundColor: primaryColor.withOpacity(0.12),
                child: Text(
                  initials.isEmpty ? '?' : initials,
                  style:
                      AppTextStyle.normalBold14.copyWith(color: primaryColor),
                ),
              ),
              SizedBox(width: 12.sp),

              // Name + username + date (stacked, never wraps weirdly)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Full name — single line with ellipsis
                    Text(
                      name,
                      style: AppTextStyle.normalBold14
                          .copyWith(color: primaryBlack),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.sp),
                    // Username in brand colour
                    Text(
                      '@${item.sharedByUserName ?? ''}',
                      style: AppTextStyle.normalRegular12
                          .copyWith(color: primaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.sp),
                    // Date + clock icon
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 11.sp, color: subTitleColor),
                        SizedBox(width: 3.sp),
                        Expanded(
                          child: Text(
                            date,
                            style: AppTextStyle.normalRegular11
                                .copyWith(color: subTitleColor),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Note (if present) ───────────────────────────────────────────
          if (item.note != null && item.note!.isNotEmpty) ...[
            SizedBox(height: 8.sp),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 8.sp, vertical: 4.sp),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.06),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                item.note!,
                style:
                    AppTextStyle.normalRegular12.copyWith(color: subTitleColor),
              ),
            ),
          ],

          SizedBox(height: 12.sp),
          const Divider(height: 1, thickness: 0.5),
          SizedBox(height: 10.sp),

          // ── Action buttons: View + Decline ──────────────────────────────
          Row(
            children: [
              // VIEW button
              Expanded(
                child: GestureDetector(
                  onTap: () => _viewReport(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.visibility_outlined,
                            color: Colors.white, size: 14.sp),
                        SizedBox(width: 5.sp),
                        Text(
                          'View',
                          style: AppTextStyle.normalSemiBold13
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.sp),

              // DECLINE button
              Expanded(
                child: GestureDetector(
                  onTap: () => _confirmDecline(item),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8.sp),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border:
                          Border.all(color: Colors.orangeAccent, width: 0.8),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.close_rounded,
                            color: Colors.orangeAccent, size: 14.sp),
                        SizedBox(width: 5.sp),
                        Text(
                          'Decline',
                          style: AppTextStyle.normalSemiBold13
                              .copyWith(color: Colors.orangeAccent.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Shared With Me',
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            height10,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                'Activities Shared With Me',
                style: AppTextStyle.normalBold18
                    .copyWith(color: primaryColor, height: 1.2),
              ),
            ),
            height04,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                'Reports shared with you by other users.',
                style: AppTextStyle.normalRegular13
                    .copyWith(color: subTitleColor, height: 1.3),
              ),
            ),
            height16,
            Expanded(
              child: Obx(() {
                // Loading spinner (first load)
                if (controller.sharedReportsWithMeLoading.value &&
                    controller.sharedReportsWithMe.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Empty state
                if (controller.sharedReportsWithMe.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 56.sp, color: borderGreyColor),
                        height12,
                        Text(
                          'No activities shared with you yet.',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: subTitleColor),
                        ),
                      ],
                    ),
                  );
                }

                // List
                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () => controller.getSharedReportsWithMe(),
                  child: ListView.separated(
                    controller: _scrollController,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                    itemCount: controller.sharedReportsWithMe.length +
                        (controller.hasMoreSharedWithMe.value ? 1 : 0),
                    separatorBuilder: (_, __) => height10,
                    itemBuilder: (context, index) {
                      // Pagination loader
                      if (index == controller.sharedReportsWithMe.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.sp),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: primaryColor),
                          ),
                        );
                      }

                      return _buildCard(controller.sharedReportsWithMe[index]);
                    },
                  ),
                );
              }),
            ),
            height16,
          ],
        ),
      ),
    );
  }
}
