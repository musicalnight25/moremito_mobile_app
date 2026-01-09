import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import '../../../utils/app_text_style.dart';
import '../../../utils/colors.dart';

class CompactInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  const CompactInfoRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: Colors.transparent,
          width: 0.6,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.12),
              borderRadius: BorderRadius.circular(5.r),
            ),
            child: Icon(
              icon,
              size: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyle.normalRegular14.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                SizedBox(height: 2.h),
                ReadMoreText(
                  value,
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  colorClickableText: primaryColor,
                  trimCollapsedText: ' Read more',
                  trimExpandedText: ' Less',
                  style: AppTextStyle.normalBold14.copyWith(
                    color: valueColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
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
