import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/categories_controller.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_category_widget.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';

import '../utils/static_decoration.dart';
import 'sub_categories_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final controller = Get.put(CategoriesController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategoriesList(context);
    });
  }

  Future<void> _onRefresh() async {
    await controller.getCategoriesList(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      backgroundColor: Colors.transparent,
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.categoriesList.isEmpty
                ? NoDataFound(title: 'Categories')
                : RefreshIndicator(
                    onRefresh: _onRefresh,
                    color: primaryColor,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.sp),
                      children: [
                        height20,
                        Text(
                          "Categories",
                          style: AppTextStyle.normalExtraBold,
                        ),
                        height20,
                        Obx(
                          () => GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              mainAxisSpacing: 10.sp,
                              crossAxisSpacing: 10.sp,
                              childAspectRatio: 1.8,
                            ),
                            itemCount: controller.categoriesList.length,
                            itemBuilder: (context, index) {
                              final category = controller.categoriesList[index];
                              return GestureDetector(
                                onTap: () {
                                  controller.subCategoriesList.clear();
                                  Get.to(() => SubCategoriesScreen(
                                        data: category,
                                      ));
                                },
                                child: CommonCategoryWidget(
                                  category: category,
                                  isSelected: category.isPopular ?? false,
                                  isSubCategory: false,
                                ),
                              );
                            },
                          ),
                        ),
                        height20,
                      ],
                    ),
                  ),
      ),
    );
  }
}
