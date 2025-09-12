import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/model/categories_model.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';

import '../controller/categories_controller.dart';
import '../utils/app_text_style.dart';
import '../utils/common_app_bar.dart';
import '../utils/common_category_widget.dart';
import '../utils/static_decoration.dart';
import 'category_details_screen.dart';

class SubCategoriesScreen extends StatefulWidget {
  final CategoryModel data;
  SubCategoriesScreen({Key? key, required this.data}) : super(key: key);

  @override
  State<SubCategoriesScreen> createState() => _SubCategoriesScreenState();
}

class _SubCategoriesScreenState extends State<SubCategoriesScreen> {
  var controller = Get.put(CategoriesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getSubCategories(context, widget.data.categoryId ?? "0");
    });
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
          // List<CategoryModel> bestCategories = controller.subCategoriesList
          //     .where((e) => e.isPopular == true)
          //     .toList();
          // List<CategoryModel> remainingCategories = controller.subCategoriesList
          //     .where((e) => e.isPopular == false)
          //     .toList();
          List<CategoryModel> bestCategories =
              controller.subCategoriesList.value;

          if (bestCategories.isEmpty && controller.isLoading.value == false) {
            return NoDataFound();
          }

          if (bestCategories.isEmpty) {
            return SizedBox();
          }

          return ListView(
            children: [
              // if (bestCategories.isNotEmpty)
              buildSubCategory(
                // title: "Best Categories",
                title: widget.data.categoryName ?? "-",
                subCategoriesList: bestCategories,
              ),
              // if (remainingCategories.isNotEmpty)
              //   buildSubCategory(
              //     title: "Remaining Categories",
              //     subCategoriesList: remainingCategories,
              //   ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildSubCategory(
      {required String title, required List<CategoryModel> subCategoriesList}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          height20,
          Text(title, style: AppTextStyle.normalExtraBold),
          customHeight(12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
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
                  controller.categoriesFileList.value.clear();
                  controller.categoriesFileList.refresh();
                  Get.to(() => CategoryDetailsScreen(
                        data: subCategory,
                      ));
                },
                child: CommonCategoryWidget(
                  category: subCategory,
                  isSelected: subCategory.isPopular ?? false,
                  isSubCategory: true,
                ),
              );
            },
          ),
          height20
        ],
      ),
    );
  }
}
