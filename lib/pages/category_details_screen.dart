import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:share_plus/share_plus.dart';

import '../controller/categories_controller.dart';
import '../model/categories_model.dart';
import '../model/category_file_model.dart';
import '../utils/static_decoration.dart';
import 'document_viewer_screen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel data;
  const CategoryDetailsScreen({super.key, required this.data});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final controller = Get.put(CategoriesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSubCategoriesFiles(null, widget.data.subCategoryId ?? "0");
    });
  }

  /// Pull-to-refresh function
  Future<void> _onRefresh() async {
    await controller.getSubCategoriesFiles(
        null, widget.data.subCategoryId ?? "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        visibleBackButton: true,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          final allFiles = controller.categoriesFileList;
          final bestCategories =
              allFiles.where((e) => e.isPopular == true).toList();
          final remainingCategories =
              allFiles.where((e) => e.isPopular == false).toList();

          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (allFiles.isEmpty) {
            return NoDataFound(title: "Files");
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.sp),
              children: [
                height20,
                Text(
                  widget.data.subCategoryName ?? "-",
                  style: AppTextStyle.normalExtraBold,
                ),
                height20,
                if (bestCategories.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Best Categories',
                          style: AppTextStyle.normalBold16
                              .copyWith(color: lightBlackColor)),
                      customHeight(12),
                      Column(
                        children: bestCategories
                            .map((element) => buildFileViewWidget(element))
                            .toList(),
                      ),
                    ],
                  ),
                if (remainingCategories.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      height20,
                      Text('Remaining Categories',
                          style: AppTextStyle.normalBold16
                              .copyWith(color: lightBlackColor)),
                      customHeight(12),
                      Column(
                        children: remainingCategories
                            .map((element) => buildFileViewWidget(element))
                            .toList(),
                      ),
                    ],
                  ),
                height20,
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildFileViewWidget(CategoryFileModel data) {
    bool isAudio = data.filePath != null &&
        (GetUtils.isAudio(data.filePath!) ||
            data.filePath!.toLowerCase().endsWith('.m4a'));
    bool isVideo = data.filePath != null && GetUtils.isVideo(data.filePath!);
    bool isPDF = data.filePath != null && GetUtils.isPDF(data.filePath!);
    bool isImage = data.filePath != null && GetUtils.isImage(data.filePath!);

    return GestureDetector(
      onTap: () {
        Get.to(() => DocumentViewerScreen(data: data));
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.sp),
        child: ShadowContainerWidget(
          padding: 12.sp,
          radius: 12.sp,
          blurRadius: 0,
          borderWidth: 1,
          widget: ClipRRect(
            borderRadius: BorderRadius.circular(8.sp),
            child: Row(
              children: [
                Icon(isVideo
                    ? CupertinoIcons.video_camera
                    : isImage
                        ? Icons.photo_outlined
                        : isAudio
                            ? CupertinoIcons.music_note_2
                            : CupertinoIcons.doc_text),
                customWidth(8),
                Expanded(
                  child: Text(
                    data.fileName ?? "-",
                    style: AppTextStyle.normalBold14,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                customWidth(8),
                Icon(isVideo || isAudio
                    ? CupertinoIcons.play_circle
                    : CupertinoIcons.eye),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void shareFile(CategoryFileModel data) {
  const subject = "File has been shared by Shubham!";
  final body = """
Dear User,

File has been shared by Shubham (Shubham Kumar):

${data.shareUrl}

Best Regards,  
Shubham Kumar
  """;

  Share.share(body, subject: subject);
}
