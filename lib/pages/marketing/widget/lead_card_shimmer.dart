import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../utils/colors.dart';

class LeadCardShimmer extends StatelessWidget {
  const LeadCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // We wrap the list in a ListView or Column in the parent,
    // here we just return one card instance.
    return Container(
      margin: EdgeInsets.only(bottom: 18.sp),
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderGreyColor.withOpacity(.4)),
        // Optional: Remove shadow for shimmer to make it look flatter/lighter
        // boxShadow: [...]
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// NAME + STATUS BADGE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Name Placeholder
                Container(
                  width: 150.w,
                  height: 20.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Badge Placeholder
                Container(
                  width: 80.w,
                  height: 24.sp,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ],
            ),

            SizedBox(height: 8.h), // Matches height06 roughly

            /// DATE
            Container(
              width: 100.w,
              height: 14.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            Divider(height: 22.sp),

            /// VERTICAL ITEMS (Phone, Email, etc.)
            // We create 4 dummy rows to match your 4 fields
            ...List.generate(4, (index) => _buildShimmerLine()),

            SizedBox(height: 16.h),

            /// NOTES HIGHLIGHT BOX PLACEHOLDER
            Container(
              width: double.infinity,
              height: 60.sp,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),

            SizedBox(height: 18.h),

            /// BUTTON PLACEHOLDER
            Container(
              width: double.infinity,
              height: 48.sp, // Standard button height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8), // Match button radius
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerLine() {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.sp),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label (e.g., "Phone")
          Container(
            width: 60.w,
            height: 12.sp,
            margin: EdgeInsets.only(bottom: 4.sp),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          // Value (e.g., "123-456...")
          Container(
            width: double.infinity,
            height: 14.sp,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ],
      ),
    );
  }
}
