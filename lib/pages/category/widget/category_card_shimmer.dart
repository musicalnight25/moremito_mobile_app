import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/shadow_container_widget.dart';

class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowContainerWidget(
      padding: 14.sp,
      borderWidth: 1.sp,
      blurRadius: 3,
      widget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔵 Icon shimmer
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

          SizedBox(height: 10.sp),

          // 📝 Title shimmer (line 1)
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

          // 📝 Title shimmer (line 2 – optional)
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 12.sp,
              width: 100.sp,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
