import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/model/categories_model.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/categories_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/common_category_widget.dart';
import '../../utils/static_decoration.dart';
import 'category_details_screen.dart';

class SubCategoriesScreen extends StatefulWidget {
  final CategoryModel data;

  const SubCategoriesScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  final controller = Get.put(CategoriesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSubCategories(null, widget.data.categoryId ?? "0");
    });
  }

  /// Function to handle pull-to-refresh
  Future<void> _onRefresh() async {
    await controller.getSubCategories(null, widget.data.categoryId ?? "0");
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
          List<CategoryModel> subCategories =
              controller.subCategoriesList.value;
          if (controller.isLoading.value) {
            return buildCategoryShimmer();
          }

          if (subCategories.isEmpty) {
            return NoDataFound(title: 'Subcategories');
          }

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: primaryColor,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                buildSubCategory(
                  title: widget.data.categoryName ?? "-",
                  subCategoriesList: subCategories,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget buildSubCategory({
    required String title,
    required List<CategoryModel> subCategoriesList,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20,
          Text(title, style: AppTextStyle.normalExtraBold),
          customHeight(12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              mainAxisSpacing: 10.sp,
              crossAxisSpacing: 10.sp,
              childAspectRatio: 1.8,
            ),
            itemCount: subCategoriesList.length,
            itemBuilder: (context, subIndex) {
              final subCategory = subCategoriesList[subIndex];
              return GestureDetector(
                onTap: () {
                  controller.categoriesFileList.clear();
                  controller.categoriesFileList.refresh();
                  Get.to(() => CategoryDetailsScreen(data: subCategory));
                },
                child: CommonCategoryWidget(
                  category: subCategory,
                  isSelected: subCategory.isPopular ?? false,
                  isSubCategory: true,
                ),
              );
            },
          ),
          height20,
        ],
      ),
    );
  }

  Widget buildCategoryShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
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
}
