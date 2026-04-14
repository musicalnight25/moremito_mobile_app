import 'dart:async';
import 'package:flutter/material.dart';
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
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategoriesList(context);
    });

    _scrollController.addListener(() {
      if (controller.isGlobalSearch.value &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          controller.hasMore.value &&
          !controller.isLoading.value) {
        controller.getSubCategoriesFiles(
          context,
          "",
          searchText: controller.globalSearchText.value,
          loadMore: true,
        );
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
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
        hintText: "Search Audios, Videos & Docs".tr,
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
                  Text("MoreMito Library".tr, style: AppTextStyle.normalBold20),
                  const SizedBox(height: 6),
                  Text(
                    "Browse audio, video, and document files.".tr,
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
                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: 6,
                        itemBuilder: (_, __) => const CategoryFileShimmer(),
                      );
                    }

                    if (controller.categoriesFileList.isEmpty) {
                      return AlwaysScrollableScrollView(
                        child: NoDataFound(title: "Files".tr),
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
                        return CategoryFileTile(data: file, categoryName: null);
                      },
                    );
                  }

                  // 🔄 Loading (Shimmer) for Categories
                  if (controller.isLoading.value) {
                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: CategoryCardShimmer(),
                        );
                      },
                    );
                  }

                  // 📭 Empty Categories
                  if (controller.categoriesList.isEmpty) {
                    return AlwaysScrollableScrollView(
                      child: NoDataFound(title: "Categories".tr),
                    );
                  }

                  // 📂 Loaded Categories
                  return ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.categoriesList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
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
