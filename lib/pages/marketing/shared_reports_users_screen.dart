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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: "Shared Activity",
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
                style: AppTextStyle.normalBold18.copyWith(
                  color: primaryColor,
                  height: 1.2,
                ),
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
                    child: Text(
                      "No shared activities found.",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: subTitleColor),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: borderGreyColor),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: DataTable(
                            columnSpacing: 20.sp,
                            headingRowColor: MaterialStateProperty.all(
                                primaryColor.withOpacity(0.05)),
                            headingTextStyle: AppTextStyle.normalBold14
                                .copyWith(color: primaryColor),
                            dataTextStyle: AppTextStyle.normalRegular13
                                .copyWith(color: primaryBlack),
                            columns: const [
                              DataColumn(label: Text("Username")),
                              DataColumn(label: Text("Name")),
                              DataColumn(label: Text("Email")),
                              DataColumn(label: Text("Shared Date")),
                              DataColumn(label: Text("Note")),
                              DataColumn(label: Text("Action")),
                            ],
                            rows: controller.sharedReportsUsers.map((user) {
                              return DataRow(cells: [
                                DataCell(Text(user.userName ?? "-")),
                                DataCell(Text(
                                    "${user.firstName ?? ""} ${user.lastName ?? ""}")),
                                DataCell(Text(user.email ?? "-")),
                                DataCell(Text(user.sharedDate != null
                                    ? DateFormat('MM/dd/yyyy HH:mm')
                                        .format(user.sharedDate!)
                                    : "-")),
                                DataCell(ConstrainedBox(
                                  constraints: BoxConstraints(maxWidth: 150.w),
                                  child: Text(user.note ?? "-",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                )),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline,
                                        color: Colors.redAccent),
                                    onPressed: () {
                                      // TODO: Implement delete functionality if API available
                                      Get.snackbar("Info",
                                          "Delete functionality coming soon.",
                                          backgroundColor: primaryColor,
                                          colorText: Colors.white);
                                    },
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            height20,
          ],
        ),
      ),
    );
  }
}
