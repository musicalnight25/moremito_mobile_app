import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

import '../model/categories_model.dart';

class CommonCategoryWidget extends StatelessWidget {
  final CategoryModel category;
  final bool isSelected;
  final bool isSubCategory;
  const CommonCategoryWidget(
      {Key? key,
      required this.category,
      required this.isSelected,
      required this.isSubCategory});

  @override
  Widget build(BuildContext context) {
    return ShadowContainerWidget(
        padding: 12.sp,
        blurRadius: 0,
        borderWidth: 1.sp,
        // borderColor: isSelected ? primaryColor : null,
        widget: Column(
          children: [
            Container(
              height: 36.sp,
              width: 36.sp,
              decoration:
                  BoxDecoration(color: category.color, shape: BoxShape.circle),
              child: Center(
                child:
                    category.image != null && category.image!.contains(".svg")
                        ? SvgPicture.asset(
                            category.image!,
                            height: 16.sp,
                            width: 16.sp,
                            fit: BoxFit.scaleDown,
                          )
                        : Image.asset(
                            category.image ?? AppAsset.logo,
                            height: 16.sp,
                            width: 16.sp,
                            fit: BoxFit.scaleDown,
                          ),
              ),
            ),
            customHeight(6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    isSubCategory
                        ? category.subCategoryName ?? ""
                        : category.categoryName ?? "-",
                    style: AppTextStyle.normalBold14,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                ),
              ],
            )
          ],
        ));
  }
}
