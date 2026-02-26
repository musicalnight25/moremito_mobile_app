import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:more_mitro_app/controller/flyers_controller.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class SharedReportsUsersScreen extends StatefulWidget {
  const SharedReportsUsersScreen({super.key});

  @override
  State<SharedReportsUsersScreen> createState() =>
      _SharedReportsUsersScreenState();
}

class _SharedReportsUsersScreenState extends State<SharedReportsUsersScreen> {
  final FlyersController controller = Get.find<FlyersController>();

  @override
  void initState() {
    super.initState();
    controller.getSharedReportsUsers();
  }

  Future<void> _confirmDelete(int shareId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
        title: Text("Remove Share",
            style: AppTextStyle.normalBold16.copyWith(color: primaryBlack)),
        content: Text(
          "Stop sharing your report with \"$name\"?",
          style: AppTextStyle.normalRegular14.copyWith(color: subTitleColor),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text("Cancel",
                style: AppTextStyle.normalRegular14
                    .copyWith(color: subTitleColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r)),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text("Remove",
                style: AppTextStyle.normalBold14.copyWith(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await controller.deleteReportShare(shareId);
      if (success) {
        Get.snackbar(
          "Removed",
          "Report share removed successfully.",
          backgroundColor: primaryColor,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          margin: EdgeInsets.all(16.sp),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "My Shared Reports",
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
                "Users I Have Shared Reports With",
                style: AppTextStyle.normalBold18
                    .copyWith(color: primaryColor, height: 1.2),
              ),
            ),
            height04,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              child: Text(
                "Manage users who can see your shared link activity report.",
                style: AppTextStyle.normalRegular13
                    .copyWith(color: subTitleColor, height: 1.3),
              ),
            ),
            height16,
            Expanded(
              child: Obx(() {
                if (controller.sharedReportsUsersLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.sharedReportsUsers.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_outline,
                            size: 56.sp, color: borderGreyColor),
                        height12,
                        Text(
                          "You haven't shared your report\nwith anyone yet.",
                          textAlign: TextAlign.center,
                          style: AppTextStyle.normalRegular14
                              .copyWith(color: subTitleColor),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.sp, vertical: 4.sp),
                  itemCount: controller.sharedReportsUsers.length,
                  separatorBuilder: (_, __) => height10,
                  itemBuilder: (context, index) {
                    final user = controller.sharedReportsUsers[index];
                    final name =
                        "${user.firstName ?? ''} ${user.lastName ?? ''}".trim();
                    final initials = name.isNotEmpty
                        ? name
                            .split(' ')
                            .where((w) => w.isNotEmpty)
                            .take(2)
                            .map((w) => w[0].toUpperCase())
                            .join()
                        : "?";
                    final date = user.sharedDate != null
                        ? DateFormat('dd MMM yyyy').format(user.sharedDate!)
                        : "-";

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
                          )
                        ],
                      ),
                      child: Row(
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 24.r,
                            backgroundColor: primaryColor.withOpacity(0.12),
                            child: Text(
                              initials,
                              style: AppTextStyle.normalBold14
                                  .copyWith(color: primaryColor),
                            ),
                          ),
                          width12,
                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name.isEmpty ? user.userName ?? "-" : name,
                                  style: AppTextStyle.normalBold14
                                      .copyWith(color: primaryBlack),
                                ),
                                height04,
                                Text(
                                  user.email ?? "-",
                                  style: AppTextStyle.normalRegular12
                                      .copyWith(color: subTitleColor),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (user.note != null &&
                                    user.note!.isNotEmpty) ...[
                                  height04,
                                  Row(
                                    children: [
                                      Icon(Icons.notes,
                                          size: 12.sp, color: subTitleColor),
                                      SizedBox(width: 4.sp),
                                      Expanded(
                                        child: Text(
                                          user.note!,
                                          style: AppTextStyle.normalRegular12
                                              .copyWith(color: subTitleColor),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                          width10,
                          // Date + Delete
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                date,
                                style: AppTextStyle.normalRegular10
                                    .copyWith(color: subTitleColor),
                              ),
                              height08,
                              GestureDetector(
                                onTap: () =>
                                    _confirmDelete(user.shareId ?? 0, name),
                                child: Container(
                                  padding: EdgeInsets.all(6.sp),
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Icon(Icons.delete_outline,
                                      color: Colors.redAccent, size: 18.sp),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
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
