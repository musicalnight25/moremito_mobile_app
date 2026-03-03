import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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

class SubCategoriesScreen extends StatefulWidget {
  final CategoryModel data;

  const SubCategoriesScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final CategoriesController controller = Get.put(CategoriesController());
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  // Local reactive filtered list
  final RxList<CategoryModel> _filteredList = <CategoryModel>[].obs;
  final RxBool _isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getSubCategories(null, widget.data.categoryId ?? "0");
      _filteredList.assignAll(controller.subCategoriesList);
    });

    // Update filtered list whenever subCategoriesList changes (e.g., on refresh)
    ever(controller.subCategoriesList, (_) {
      _applySearch(_searchController.text);
    });
  }

  void _applySearch(String query) {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) {
      _isSearching.value = false;
      _filteredList.assignAll(controller.subCategoriesList);
    } else {
      _isSearching.value = true;
      _filteredList.assignAll(
        controller.subCategoriesList.where(
          (item) => (item.categoryName ?? '').toLowerCase().contains(trimmed),
        ),
      );
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
    _filteredList.assignAll(controller.subCategoriesList);
  }

  Future<void> _onRefresh() async {
    await controller.getSubCategories(null, widget.data.categoryId ?? "0");
    _applySearch(_searchController.text);
  }

  Widget _searchBar() {
    return Obx(() {
      return TextFormFieldWidget(
        controller: _searchController,
        hintText: "Search Audios, Videos & Docs",
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
              child: Obx(() {
                if (controller.isLoading.value) {
                  return CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverMasonryGrid.count(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childCount: 6,
                          itemBuilder: (context, index) {
                            return const CategoryCardShimmer();
                          },
                        ),
                      ),
                    ],
                  );
                }

                final list = _filteredList;

                if (list.isEmpty) {
                  return NoDataFound(
                    title: _isSearching.value
                        ? 'No results for "${_searchController.text}"'
                        : 'Subcategories',
                  );
                }

                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  color: primaryColor,
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverMasonryGrid.count(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 600 ? 3 : 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childCount: list.length,
                          itemBuilder: (context, index) {
                            final subCategory = list[index];
                            return GestureDetector(
                              onTap: () {
                                controller.categoriesFileList.clear();
                                Get.to(() =>
                                    CategoryDetailsScreen(data: subCategory));
                              },
                              child: CategoryWidget(
                                category: subCategory,
                                isSubCategory: true,
                              ),
                            );
                          },
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(height: 24),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
