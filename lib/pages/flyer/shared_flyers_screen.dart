// lib/screen/flyer/shared_flyers_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../controller/flyers_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';

class SharedFlyersScreen extends StatefulWidget {
  final String title;
  final String filterKey;

  const SharedFlyersScreen(
      {super.key, required this.title, required this.filterKey});

  @override
  State<SharedFlyersScreen> createState() => _SharedFlyersScreenState();
}

class _SharedFlyersScreenState extends State<SharedFlyersScreen> {
  final FlyersController controller = Get.put(FlyersController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // we assume controller already loaded first page in parent tap handler,
    // but if user navigates manually, ensure at least first load:
    if (controller.sharedFlyers.isEmpty) {
      controller.getSharedFlyers(filterKey: widget.filterKey);
    }

    scrollController.addListener(() {
      if (!controller.hasMore) return;
      if (controller.loadMoreLoading.value) return;
      double maxScroll = scrollController.position.maxScrollExtent;
      double currentScroll = scrollController.position.pixels;

      if (currentScroll >= maxScroll * 0.80) {
        controller.getSharedFlyers(filterKey: widget.filterKey);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget _tile(item) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.sp),
      child: ListTile(
        title: Text(item.title ?? "Untitled",
            style: AppTextStyle.normalSemiBold16),
        subtitle: Text(
            "Recipients: ${item.recipients ?? 0}  •  Activity: ${item.activity ?? 0}"),
        trailing: Text(item.sharedOn ?? ""),
        onTap: () {
          // you can navigate to details screen for shared flyer
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: widget.title, visibleBackButton: true),
      backgroundColor: primaryWhite,
      body: Obx(() {
        if (controller.listLoading.value && controller.sharedFlyers.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.sharedFlyers.isEmpty) {
          return const NoDataFound(title: "Shared Flyers");
        }

        return ListView.builder(
          controller: scrollController,
          padding: EdgeInsets.all(16.sp),
          itemCount: controller.sharedFlyers.length +
              (controller.loadMoreLoading.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index < controller.sharedFlyers.length) {
              final item = controller.sharedFlyers[index];
              return _tile(item);
            } else {
              // loading indicator
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 18.sp),
                child: Center(
                    child: CircularProgressIndicator(color: primaryColor)),
              );
            }
          },
        );
      }),
    );
  }
}
