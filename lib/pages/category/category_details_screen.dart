import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/widget/category_file_shimmer.dart';
import 'package:more_mitro_app/pages/category/widget/category_file_tile.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';

import '../../controller/categories_controller.dart';
import '../../model/categories_model.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final CategoryModel data;

  const CategoryDetailsScreen({super.key, required this.data});

  @override
  State<CategoryDetailsScreen> createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  final CategoriesController controller = Get.put(CategoriesController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.resetAndSearch(null, widget.data.subCategoryId ?? "");
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          controller.hasMore.value &&
          !controller.isLoading.value) {
        controller.getSubCategoriesFiles(
          null,
          widget.data.subCategoryId ?? "",
          loadMore: true,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          final list = controller.categoriesFileList;

          if (controller.isLoading.value && list.isEmpty) {
            return _buildShimmer();
          }

          return Column(
            children: [
              _searchBar(),
              Expanded(
                child: list.isEmpty
                    ? NoDataFound(title: "Files".tr)
                    : ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.sp),
                        controller: _scrollController,
                        itemCount:
                            list.length + (controller.hasMore.value ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == list.length) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return CategoryFileTile(
                            data: list[index],
                            categoryName: widget.data.categoryName,
                          );
                        },
                      ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _searchBar() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormFieldWidget(
          controller: _searchController,
          hintText: "Search Audios, Videos & Docs".tr,
          suffixIcon: controller.searchText.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    controller.resetAndSearch(
                      null,
                      widget.data.subCategoryId ?? "",
                    );
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    controller.resetAndSearch(
                      _searchController.text.trim(),
                      widget.data.subCategoryId ?? "",
                    );
                  },
                ), // 🔥 Trigger search on keyboard submit
          onFieldSubmitted: (value) {
            controller.resetAndSearch(
              value?.trim(),
              widget.data.subCategoryId ?? "",
            );
          },
        ),
      );
    });
  }

  Widget _buildShimmer() {
    return ListView.builder(
      itemCount: 16,
      padding: EdgeInsets.symmetric(horizontal: 16.sp),
      itemBuilder: (_, __) => const CategoryFileShimmer(),
    );
  }
}
