import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/categories_controller.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';
import 'package:more_mitro_app/utils/common_category_widget.dart';
import 'package:more_mitro_app/utils/no_data_found.dart';

import '../utils/static_decoration.dart';
import 'sub_categories_screen.dart';

class CategoriesScreen extends StatefulWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var controller = Get.put(CategoriesController());
  // RxnInt selectedIndex = RxnInt();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getCategoriesList(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(),
      backgroundColor: Colors.transparent,
      body: Obx(
        () => !controller.isLoading.value && controller.categoriesList.isEmpty
            ? NoDataFound(
                title: 'Categories',
              )
            : ListView(
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
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
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
                            // selectedIndex.value = index;
                            controller.subCategoriesList.value.clear();
                            Get.to(() => SubCategoriesScreen(
                                  data: controller.categoriesList[index],
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
    );
  }
}
