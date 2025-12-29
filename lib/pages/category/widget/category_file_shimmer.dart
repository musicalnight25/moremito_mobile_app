import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more_mitro_app/utils/shadow_container_widget.dart';
import 'package:shimmer/shimmer.dart';

class CategoryFileShimmer extends StatelessWidget {
  const CategoryFileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: ShadowContainerWidget(
        widget: Row(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 30,
                height: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                        height: 14,
                        width: double.infinity,
                        color: Colors.white),
                  ),
                  SizedBox(height: 6),
                  Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                          height: 12, width: 150, color: Colors.white)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
