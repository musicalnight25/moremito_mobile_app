import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/widget/category_card_shimmer.dart';
import 'package:more_mitro_app/pages/category/widget/category_widget.dart';

import '../../controller/categories_controller.dart';
import '../../model/categories_model.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/input_text_field_widget.dart';
import '../../utils/no_data_found.dart';
import 'category_details_screen.dart';
import 'widget/category_file_shimmer.dart';
import 'widget/category_file_tile.dart';

class SubCategoriesScreen extends StatefulWidget {
  final CategoryModel data;

  const SubCategoriesScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final CategoriesController controller = Get.put(CategoriesController());
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  final RxBool _isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getSubCategories(null, widget.data.categoryId ?? "0");
    });

    _scrollController.addListener(() {
      if (_isSearching.value &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          controller.hasMore.value &&
          !controller.isLoading.value) {
        controller.getSubCategoriesFiles(
          context,
          widget.data.categoryId ?? "0",
          searchText: _searchController.text.trim(),
          loadMore: true,
        );
      }
    });
  }

  void _applySearch(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _clearSearch();
    } else {
      _isSearching.value = true;
      controller.resetAndSearch(trimmed, widget.data.categoryId ?? "0");
    }
  }

  void _onSearchChanged(String? value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applySearch(value ?? '');
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _isSearching.value = false;
    controller.categoriesFileList.clear();
  }

  Future<void> _onRefresh() async {
    if (_isSearching.value) {
      controller.resetAndSearch(
          _searchController.text.trim(), widget.data.categoryId ?? "0");
    } else {
      await controller.getSubCategories(null, widget.data.categoryId ?? "0");
    }
  }

  Widget _searchBar() {
    return Obx(() {
      return TextFormFieldWidget(
        controller: _searchController,
        hintText: "Search Audios, Videos & Docs".tr,
        onChanged: _onSearchChanged,
        suffixIcon: _isSearching.value
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: _clearSearch,
              )
            : IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _applySearch(_searchController.text),
              ),
        onFieldSubmitted: (value) => _applySearch(value ?? ''),
      );
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header + Search Bar
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data.categoryName ?? "-",
                    style: AppTextStyle.normalExtraBold,
                  ),
                  const SizedBox(height: 12),
                  _searchBar(),
                ],
              ),
            ),

            // 🔹 Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: primaryColor,
                child: Obx(() {
                  // 🔍 SEARCH RESULT (FILES)
                  if (_isSearching.value) {
                    if (controller.isLoading.value &&
                        controller.categoriesFileList.isEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: 6,
                        itemBuilder: (_, __) => const CategoryFileShimmer(),
                      );
                    }

                    if (controller.categoriesFileList.isEmpty) {
                      return CustomScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverFillRemaining(
                            child: Center(
                              child: NoDataFound(title: "Files".tr),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.categoriesFileList.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.categoriesFileList.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        final file = controller.categoriesFileList[index];
                        return CategoryFileTile(
                          data: file,
                          categoryName: widget.data.categoryName,
                        );
                      },
                    );
                  }

                  // 🔄 Loading (Shimmer) for SubCategories
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: 6,
                      itemBuilder: (_, __) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CategoryCardShimmer(),
                        );
                      },
                    );
                  }

                  // 📭 Empty SubCategories
                  if (controller.subCategoriesList.isEmpty) {
                    return CustomScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          child: Center(
                            child: NoDataFound(title: "Subcategories".tr),
                          ),
                        ),
                      ],
                    );
                  }

                  // 📂 Loaded SubCategories
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: controller.subCategoriesList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final subCategory = controller.subCategoriesList[index];
                      return GestureDetector(
                        onTap: () {
                          controller.categoriesFileList.clear();
                          Get.to(
                              () => CategoryDetailsScreen(data: subCategory));
                        },
                        child: CategoryWidget(
                          category: subCategory,
                          isSubCategory: true,
                          isListTile: true,
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
