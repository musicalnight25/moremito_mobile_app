import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/flyers_controller.dart';
import '../../model/shared_flyers_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/shadow_container_widget.dart';
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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.resetPagination();

    controller.getSharedFlyers(filterKey: widget.filterKey);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        if (!controller.loadMoreLoading.value && controller.hasMore) {
          controller.getSharedFlyers(filterKey: widget.filterKey);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget _filterSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // 🔍 Search Field
          TextFormFieldWidget(
            controller: _searchController,
            hintText: "Search recipient",
            suffixIcon: IconButton(
              icon: const Icon(Icons.search, size: 20),
              onPressed: () {
                controller.resetPagination();
                controller.getSharedFlyers(
                  filterKey: widget.filterKey,
                  search: _searchController.text,
                  fileType: controller.currentFileType.value,
                );
              },
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),

          const SizedBox(height: 10),

          // FILTER ROW
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IgnorePointer(
                    ignoring: false,
                    child: Obx(() => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.currentFileType.value ?? "All",
                            icon: const Icon(Icons.keyboard_arrow_down_rounded),
                            items: const [
                              DropdownMenuItem(
                                  value: "All", child: Text("All")),
                              DropdownMenuItem(
                                  value: "Files",
                                  child: Text("Audios, Videos & Docs")),
                              DropdownMenuItem(
                                  value: "Flyers", child: Text("Flyers")),
                              DropdownMenuItem(
                                  value: "SMS",
                                  child: Text("SMS requested info ")),
                            ],
                            onChanged: (value) {
                              controller.currentFileType.value =
                                  value == "All" ? null : value;

                              controller.resetPagination();
                              controller.getSharedFlyers(
                                filterKey: widget.filterKey,
                                search: _searchController.text,
                                fileType: controller.currentFileType.value,
                              );
                            },
                          ),
                        )),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Clear Button
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  _searchController.clear();
                  controller.currentFileType.value = null;
                  controller.resetPagination();
                  controller.getSharedFlyers(filterKey: widget.filterKey);
                },
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.close, size: 20),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCard(SharedFlyerItem item) {
    final hasData = (item.totalInteractions ?? 0) > 0;

    return InkWell(
      onTap: hasData
          ? () => Get.to(() => FlyerActivityScreen(
                sharedFlyerId: item.fileShareId!,
                title: item.title ?? "",
                sharedTo: item.sharedTo ?? "",
              ))
          : null,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.sp),
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(16.sp),
          border: Border.all(color: borderGreyColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Interaction Eye Icon
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.title ?? "Untitled Flyer",
                    style:
                        AppTextStyle.normalBold16.copyWith(color: primaryBlack),
                  ),
                ),
                if (hasData)
                  Icon(Icons.visibility_outlined,
                      size: 20.sp, color: primaryColor),
              ],
            ),

            if (item.subTitle != null && item.subTitle!.isNotEmpty) ...[
              height04,
              Text(
                item.subTitle!,
                style: AppTextStyle.normalRegular14
                    .copyWith(color: lightBlackColor),
              ),
            ],

            const Divider(height: 24, color: borderGreyColor),

            // Shared Details Section
            Row(
              children: [
                _infoTile(
                  icon: Icons.person_outline,
                  label: "Shared To",
                  value: item.sharedTo ?? "N/A",
                ),
                const Spacer(),
                _infoTile(
                  icon: Icons.calendar_today_outlined,
                  label: "Date",
                  value: _formatDate(item.sharedOn),
                ),
              ],
            ),

            height12,

            // Interaction Footer
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.analytics_outlined,
                    size: 16.sp, color: primaryBlack),
                width08,
                Text(
                  "Total Interactions: ",
                  style: AppTextStyle.normalRegular13
                      .copyWith(color: primaryBlack),
                ),
                Text(
                  "${item.totalInteractions ?? 0}",
                  style:
                      AppTextStyle.normalBold14.copyWith(color: primaryBlack),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

// Small helper widget for the Shared To and Date info
  Widget _infoTile(
      {required IconData icon, required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14.sp, color: hintGreyColor),
            width04,
            Text(label,
                style: AppTextStyle.normalRegular12
                    .copyWith(color: hintGreyColor)),
          ],
        ),
        height04,
        Text(
          value,
          style: AppTextStyle.normalSemiBold14.copyWith(color: primaryBlack),
        ),
      ],
    );
  }

  // ────────────────────────────────────────────────
  // SHIMMER
  // ────────────────────────────────────────────────
  Widget _shimmerList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: _shimmerCard(),
      ),
    );
  }

  Widget _shimmerCard() {
    return ShadowContainerWidget(
      widget: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12,
              width: 180,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Date row
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12,
              width: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Bottom row (icon + count)
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 12,
                  width: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const Spacer(),
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 14,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
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
      appBar: const CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Column(
          children: [
            // ---------------- FILTER SECTION ----------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.title, style: AppTextStyle.normalBold20),
                  const SizedBox(height: 6),
                  Text(
                    "Below is the list of activities from your recipients",
                    style: AppTextStyle.normalRegular14
                        .copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 12),
                  _filterSection(),
                ],
              ),
            ),

            // ---------------- CONTENT ----------------
            Expanded(
              child: Obx(() {
                // 1️⃣ SHOW SHIMMER WHEN LOADING FIRST TIME
                if (controller.listLoading.value &&
                    controller.sharedFlyers.isEmpty) {
                  return _shimmerList();
                }

                // 2️⃣ EMPTY STATE
                if (controller.sharedFlyers.isEmpty) {
                  return const NoDataFound(title: "Shared Flyers");
                }

                // 3️⃣ LIST VIEW
                return RefreshIndicator(
                  onRefresh: () async {
                    controller.resetPagination();
                    await controller.getSharedFlyers(
                      filterKey: widget.filterKey,
                    );
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.sharedFlyers.length +
                        (controller.loadMoreLoading.value ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < controller.sharedFlyers.length) {
                        return _buildCard(controller.sharedFlyers[index]);
                      }

                      // bottom loading
                      return const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String? iso) {
    if (iso == null || iso.isEmpty) return "-";
    final d = DateTime.tryParse(iso);
    if (d == null) return "-";
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }
}
