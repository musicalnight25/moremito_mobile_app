import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_text_style.dart';
import 'colors.dart';

class TextPrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final Color? color;

  const TextPrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? primaryColor;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4.sp),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 6.sp),
        child: Text(
          title,
          style: AppTextStyle.normalSemiBold14.copyWith(
            color: textColor,
            decoration: TextDecoration.underline,
            decorationColor: textColor,
          ),
        ),
      ),
    );
  }
}
