import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import '../../../utils/colors.dart';

class SurveyShimmerTile extends StatelessWidget {
  const SurveyShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 14.sp),
      padding: EdgeInsets.all(18.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                  width: 220.sp, height: 16.sp, color: borderGreyColor)),
          SizedBox(height: 10.sp),
          Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                  width: double.infinity,
                  height: 14.sp,
                  color: borderGreyColor)),
          SizedBox(height: 8.sp),
          Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                  width: double.infinity,
                  height: 14.sp,
                  color: borderGreyColor)),
          SizedBox(height: 8.sp),
          Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                  width: 170.sp, height: 14.sp, color: borderGreyColor)),
        ],
      ),
    );
  }
}
