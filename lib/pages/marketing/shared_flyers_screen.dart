import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/marketing/widget/compact_info_row.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/primary_text_button.dart';
import 'package:more_mitro_app/utils/text_primary_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/flyers_controller.dart';
import '../../model/shared_flyers_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/shadow_container_widget.dart';
import 'flyer_activity_screen.dart';

class SharedFlyersScreen extends StatefulWidget {
  final String title;
  final String filterKey;
  final int? viewUserId; // null = own flyers; non-null = another user's
  final String? viewUserName;

  const SharedFlyersScreen({
    super.key,
    required this.title,
    required this.filterKey,
    this.viewUserId,
    this.viewUserName,
  });

  @override
  State<SharedFlyersScreen> createState() => _SharedFlyersScreenState();
}

class _SharedFlyersScreenState extends State<SharedFlyersScreen> {
  final FlyersController controller = Get.isRegistered<FlyersController>()
      ? Get.find<FlyersController>()
      : Get.put(FlyersController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetPagination();
      controller.getSharedFlyers(
        filterKey: widget.filterKey,
        userId: widget.viewUserId,
      );
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        if (controller.hasMore &&
            !controller.loadMoreLoading.value &&
            !controller.listLoading.value) {
          controller.getSharedFlyers(
            filterKey: widget.filterKey,
            search: _searchController.text,
            userId: widget.viewUserId,
          );
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
                  userId: widget.viewUserId,
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
                                userId: widget.viewUserId,
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
                  controller.getSharedFlyers(
                    filterKey: widget.filterKey,
                    userId: widget.viewUserId,
                  );
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

    void navigateToDetails() {
      if (hasData) {
        Get.to(() => FlyerActivityScreen(
              sharedFlyerId: item.fileShareId!,
              title: item.title ?? "",
              fileType: item.fileType ?? 1,
              sharedTo: item.sharedTo ?? "",
            ));
      }
    }

    return Container(
      margin: EdgeInsets.only(bottom: 14.sp),
      padding: EdgeInsets.all(12.sp), // Reduced padding for compact look
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.sp),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Who (Recipient)
          CompactInfoRow(
            icon: Icons.person_search_outlined,
            label: "Who :",
            value: item.sharedTo ?? "N/A",
            valueColor: primaryBlack,
          ),

          // 2. What (Title - Highlighted)
          if (item.title != null && item.title!.isNotEmpty)
            CompactInfoRow(
              icon: Icons.description_outlined,
              label: "What :",
              value: item.title ?? "",
              valueColor: primaryBlack,
              // isHighlighted: true, // Highlights the main content
            ),

          // 3. When
          CompactInfoRow(
            icon: Icons.calendar_today_outlined,
            label: "When :",
            value: _formatDate(item.sharedOn),
            valueColor: primaryBlack,
          ),

          // 4. Last Activity
          CompactInfoRow(
            icon: Icons.history_outlined,
            label: "Last Activity :",
            value: _formatDate(item.lastInteractionDate),
            valueColor: primaryBlack,
          ),

          const Divider(height: 20, color: borderGreyColor),

          // 5. Footer Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Interactions
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.ads_click,
                        size: 16.sp, color: Colors.green.shade700),
                    SizedBox(width: 6.sp),
                    Text(
                      "Total Activities : ${item.totalInteractions ?? 0}",
                      style: AppTextStyle.normalSemiBold12
                          .copyWith(color: Colors.green.shade900),
                    ),
                  ],
                ),
              ),

              Opacity(
                opacity: hasData ? 1.0 : 0.35,
                child: TextPrimaryButton(
                  title: "View Details",
                  onPressed: navigateToDetails,
                ),
              )
            ],
          ),
        ],
      ),
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
                  Text(
                    widget.viewUserName != null
                        ? "${widget.viewUserName}'s ${widget.title} Activity"
                        : widget.title,
                    style: AppTextStyle.normalBold20,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.viewUserName != null
                        ? "Shared links activity from ${widget.viewUserName}'s recipients"
                        : "Below is the list of activities from your recipients",
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
                if (controller.listLoading.value &&
                    controller.sharedFlyers.isEmpty) {
                  return _shimmerList();
                }

                if (controller.sharedFlyers.isEmpty) {
                  return const NoDataFound(title: "Shared Flyers");
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    controller.resetPagination();
                    await controller.getSharedFlyers(
                      filterKey: widget.filterKey,
                      userId: widget.viewUserId,
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
                      } else {
                        return controller.hasMore
                            ? const Padding(
                                padding: EdgeInsets.all(16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              )
                            : const SizedBox.shrink();
                      }
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
    if (iso == null || iso.isEmpty) return "N/A";
    final d = DateTime.tryParse(iso);
    if (d == null) return "N/A";
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }
}
