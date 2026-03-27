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
  final bool isListTile;

  const CategoryWidget({
    Key? key,
    required this.category,
    required this.isSubCategory,
    this.isListTile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isListTile) {
      final String title =
          isSubCategory ? category.subCategoryName ?? "" : category.categoryName ?? "";
      final String subtitle = (category.shortDesc ?? category.description ?? "").trim();

      return ShadowContainerWidget(
        padding: 12.sp,
        borderWidth: 1.sp,
        blurRadius: 2,
        widget: Row(
          children: [
            Container(
              height: 44.sp,
              width: 44.sp,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor.withValues(alpha: 0.1),
              ),
              child: Icon(
                category.icon ?? PhosphorIcons.folder(),
                color: primaryColor,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 12.sp),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.normalBold14.copyWith(height: 1.2),
                  ),
                  if (subtitle.isNotEmpty) ...[
                    SizedBox(height: 4.sp),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.normalRegular12
                          .copyWith(color: Colors.black54, height: 1.3),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      );
    }

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
                  primaryColor.withValues(alpha: 0.9),
                  primaryColor.withValues(alpha: 0.6),
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
