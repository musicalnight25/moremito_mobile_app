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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSubCategories(null, widget.data.categoryId ?? "0");
    });
  }

  Future<void> _onRefresh() async {
    await controller.getSubCategories(null, widget.data.categoryId ?? "0");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(visibleBackButton: true),
      body: BaseBackgroundWidget(
        child: Obx(() {
          final subCategories = controller.subCategoriesList;

          if (controller.isLoading.value) {
            return CustomScrollView(
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

          if (subCategories.isEmpty) {
            return const NoDataFound(title: 'Subcategories');
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                // 🔹 Title
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      widget.data.categoryName ?? "-",
                      style: AppTextStyle.normalExtraBold,
                    ),
                  ),
                ),

                // 🔹 Masonry Grid (Dynamic Height)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverMasonryGrid.count(
                    crossAxisCount:
                        MediaQuery.of(context).size.width > 600 ? 3 : 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childCount: subCategories.length,
                    itemBuilder: (context, index) {
                      final subCategory = subCategories[index];
                      return GestureDetector(
                        onTap: () {
                          controller.categoriesFileList.clear();
                          Get.to(
                              () => CategoryDetailsScreen(data: subCategory));
                        },
                        child: CategoryWidget(
                          category: subCategory,
                          isSelected: subCategory.isPopular ?? false,
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
    );
  }
}
