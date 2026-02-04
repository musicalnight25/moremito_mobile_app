import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/pages/category/sub_categories_screen.dart';
import 'package:more_mitro_app/pages/category/widget/category_card_shimmer.dart';
import 'package:more_mitro_app/pages/category/widget/category_widget.dart';

import '../../controller/categories_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/base_background_widget.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/input_text_field_widget.dart';
import 'widget/category_file_shimmer.dart';
import 'widget/category_file_tile.dart';

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
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    if (controller.isGlobalSearch.value) {
      controller.globalSearchFiles(_searchController.text.trim());
    } else {
      await controller.getCategoriesList(context);
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        visibleBackButton: widget.isFromMenu,
      ),
      body: BaseBackgroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Header
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

            // 🔹 Content
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                child: Obx(() {
                  // 🔍 GLOBAL SEARCH RESULT (FILES)
                  if (controller.isGlobalSearch.value) {
                    if (controller.isLoading.value &&
                        controller.categoriesFileList.isEmpty) {
                      return MasonryGridView.count(
                        padding: const EdgeInsets.all(16),
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 600 ? 3 : 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        itemCount: 6,
                        itemBuilder: (_, __) => const CategoryFileShimmer(),
                      );
                    }

                    if (controller.categoriesFileList.isEmpty) {
                      return const AlwaysScrollableScrollView(
                        child: NoDataFound(title: "Files"),
                      );
                    }

                    return MasonryGridView.count(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      crossAxisCount:
                          MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: controller.categoriesFileList.length,
                      itemBuilder: (context, index) {
                        final file = controller.categoriesFileList[index];
                        return CategoryFileTile(data: file);
                      },
                    );
                  }

                  // 🔄 Loading (Shimmer) for Categories
                  if (controller.isLoading.value) {
                    return CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.all(16),
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

                  // 📭 Empty Categories
                  if (controller.categoriesList.isEmpty) {
                    return const AlwaysScrollableScrollView(
                      child: NoDataFound(title: "Categories"),
                    );
                  }

                  // 📂 Loaded Categories
                  return MasonryGridView.count(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    itemCount: controller.categoriesList.length,
                    itemBuilder: (context, index) {
                      final category = controller.categoriesList[index];
                      return GestureDetector(
                        onTap: () {
                          controller.subCategoriesList.clear();
                          Get.to(() => SubCategoriesScreen(data: category));
                        },
                        child: CategoryWidget(
                          category: category,
                          isSubCategory: false,
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

/// 🔧 Helper widget to make empty state refreshable
class AlwaysScrollableScrollView extends StatelessWidget {
  final Widget child;

  const AlwaysScrollableScrollView({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Center(child: child),
      ),
    );
  }
}
