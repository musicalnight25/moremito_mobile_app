import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../model/categories_model.dart';
import '../../../utils/app_text_style.dart';
import '../../../utils/colors.dart';
import '../../../utils/shadow_container_widget.dart';

class CategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final bool isSubCategory;

  const CategoryWidget({
    Key? key,
    required this.category,
    required this.isSubCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainerWidget(
      padding: 14.sp,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔵 Icon
          Container(
            height: 46.sp,
            width: 46.sp,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.9),
                  primaryColor.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Icon(
              category.icon ?? PhosphorIcons.folder(),
              color: Colors.white,
              size: 22.sp,
            ),
          ),

          SizedBox(height: 10.sp),

          // 📝 Title
          Text(
            isSubCategory
                ? category.subCategoryName ?? ""
                : category.categoryName ?? "",
            style: AppTextStyle.normalBold14.copyWith(height: 1.25),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
