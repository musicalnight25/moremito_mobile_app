import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/base_background_widget.dart';
import 'package:more_mitro_app/utils/input_text_field_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../controller/categories_controller.dart';
import '../../utils/app_text_style.dart';
import '../../utils/colors.dart';
import '../../utils/common_app_bar.dart';
import '../../utils/no_data_found.dart';
import '../../utils/static_decoration.dart';
import '../../utils/common_category_widget.dart';
import 'sub_categories_screen.dart';

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
    super.dispose();
  }

  // ---------------- SHIMMER ----------------
  Widget _shimmerGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
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

  // ---------------- SEARCH BAR ----------------
  Widget _searchBar() {
    return TextFormFieldWidget(
      controller: _searchController,
      onChanged: (value) {
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 350), () {
          // controller.searchCategory(value);
        });
      },
      suffixIcon: IconButton(
        icon: const Icon(Icons.search, size: 20),
        onPressed: () {},
      ),
      hintText: "Search Audio, Video & Doc...",
    );
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: CommonAppBar(
        visibleBackButton: widget.isFromMenu,
      ),
      body: BaseBackgroundWidget(
        child: Obx(() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('MoreMito Library', style: AppTextStyle.normalBold20),
                    const SizedBox(height: 6),
                    Text(
                      "Browse categories or search by sub categories, filenames, or tags.",
                      style: AppTextStyle.normalRegular14
                          .copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),
                    _searchBar(),
                  ],
                ),
              ),

              // CONTENT
              Expanded(
                child: controller.isLoading.value
                    ? _shimmerGrid()
                    : controller.categoriesList.isEmpty
                        ? const NoDataFound(title: "Categories")
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
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
            ],
          );
        }),
      ),
    );
  }
}
