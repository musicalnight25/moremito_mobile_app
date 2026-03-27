import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/shadow_container_widget.dart';

class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainerWidget(
      padding: 12.sp,
      borderWidth: 1.sp,
      blurRadius: 2,
      widget: Row(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 44.sp,
              width: 44.sp,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 12.sp),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 14.sp,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6.sp),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    height: 12.sp,
                    width: 170.sp,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
