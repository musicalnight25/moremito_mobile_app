import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/widget/category_file_shimmer.dart';
import 'package:more_mitro_app/pages/category/widget/category_file_tile.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/categories_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/static_decoration.dart';
import '../../utils/common_category_widget.dart';
import 'sub_categories_screen.dart';

class CategoriesScreen extends StatefulWidget {
  final bool isFromMenu;

  const CategoriesScreen({Key? key, required this.isFromMenu})
      : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final CategoriesController controller = Get.put(CategoriesController());
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategoriesList(context);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // ---------------- SHIMMER ----------------
  Widget _shimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Obx(() {
      return TextFormFieldWidget(
        controller: _searchController,
        hintText: "Search Audios, Videos & Docs",
        suffixIcon: controller.isGlobalSearch.value
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _searchController.clear();
                  controller.resetGlobalSearch();
                },
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  controller.globalSearchFiles(
                    _searchController.text.trim(),
                  );
                },
              ),
        // 🔥 Trigger search when user presses "Search" on keyboard
        onFieldSubmitted: (value) {
          controller.globalSearchFiles(value?.trim());
        },
      );
    });
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        visibleBackButton: widget.isFromMenu,
      ),
      body: BaseBackgroundWidget(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MoreMito Library', style: AppTextStyle.normalBold20),
                const SizedBox(height: 6),
                Text(
                  "Browse audio, video, and document files.",
                  style: AppTextStyle.normalRegular14
                      .copyWith(color: Colors.black54),
                ),
                const SizedBox(height: 12),
                _searchBar(),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              // 🔍 GLOBAL SEARCH RESULT (FILES)
              if (controller.isGlobalSearch.value) {
                if (controller.isLoading.value &&
                    controller.categoriesFileList.isEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: 6,
                    itemBuilder: (_, __) => const CategoryFileShimmer(),
                  );
                }

                if (controller.categoriesFileList.isEmpty) {
                  return const NoDataFound(title: "Files");
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.categoriesFileList.length,
                  itemBuilder: (context, index) {
                    final file = controller.categoriesFileList[index];
                    return CategoryFileTile(data: file);
                  },
                );
              }

              // 📂 NORMAL CATEGORY VIEW
              if (controller.isLoading.value) {
                return _shimmerGrid();
              }

              if (controller.categoriesList.isEmpty) {
                return const NoDataFound(title: "Categories");
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.8,
                ),
                itemCount: controller.categoriesList.length,
                itemBuilder: (context, index) {
                  final category = controller.categoriesList[index];
                  return GestureDetector(
                    onTap: () {
                      controller.subCategoriesList.clear();
                      Get.to(() => SubCategoriesScreen(data: category));
                    },
                    child: CommonCategoryWidget(
                      category: category,
                      isSelected: category.isPopular ?? false,
                      isSubCategory: false,
                    ),
                  );
                },
              );
            }),
          ),
        ],
      )),
    );
  }
}
