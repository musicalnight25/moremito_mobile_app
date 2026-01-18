import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/shadow_container_widget.dart';

class OrderCompensationDetailShimmer extends StatelessWidget {
  const OrderCompensationDetailShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: ListView(
        padding: EdgeInsets.all(16.sp),
        children: [
          /// Order number shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 22.sp,
              width: 100.w,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.sp),

          /// Processing text shimmer
          Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 14.sp,
              width: 160.w,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.sp),

          /// Card shimmers
          ...List.generate(1, (_) => _cardShimmer()),
        ],
      ),
    );
  }

  Widget _cardShimmer() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.sp),
      child: ShadowContainerWidget(
        widget: Padding(
          padding: EdgeInsets.all(12.sp),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              children: List.generate(9, (_) => _rowShimmer()),
            ),
          ),
        ),
      ),
    );
  }

  Widget _rowShimmer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Label shimmer
          Container(
            height: 14.sp,
            width: 120.w,
            color: Colors.white,
          ),

          /// Value shimmer
          Container(
            height: 14.sp,
            width: 80.w,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
