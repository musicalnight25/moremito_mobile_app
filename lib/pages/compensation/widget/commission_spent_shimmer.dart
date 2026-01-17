import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/shadow_container_widget.dart';

class CommissionSpentShimmer extends StatelessWidget {
  const CommissionSpentShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: ListView.separated(
        padding: EdgeInsets.all(16.sp),
        itemCount: 6,
        separatorBuilder: (_, __) => SizedBox(height: 14.sp),
        itemBuilder: (_, __) {
          return ShadowContainerWidget(
            widget: Padding(
              padding: EdgeInsets.all(8.sp),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 20.sp, width: 100.w, color: Colors.white),
                        Container(
                            height: 16.sp, width: 20.w, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 16.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 14.sp, width: 80.w, color: Colors.white),
                        Container(
                            height: 14.sp, width: 60.w, color: Colors.white),
                      ],
                    ),
                    SizedBox(height: 10.sp),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            height: 14.sp, width: 120.w, color: Colors.white),
                        Container(
                            height: 14.sp, width: 40.w, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
