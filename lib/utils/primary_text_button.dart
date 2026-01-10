import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more_mitro_app/utils/app_asset.dart'; // Ensure this path is correct
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';

class PrimaryTextButton extends StatelessWidget {
  final String title;
  final String? prefixIcon;
  final String? trailIcon;
  final VoidCallback? onPressed;
  final Color? buttonColor;
  final Color? textColor;
  final Color? iconColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final Widget? prefixIconWidget;
  final BorderSide? border;
  final bool autofocus;
  final BorderRadiusGeometry? borderRadius;
  final double? fontSize;

  const PrimaryTextButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.buttonColor,
    this.textColor,
    this.iconColor,
    this.isLoading = false,
    this.prefixIcon,
    this.prefixIconWidget,
    this.trailIcon,
    this.border,
    this.width,
    this.height,
    this.borderRadius,
    this.autofocus = true,
    this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Default colors based on your sleek theme
    final Color effectiveTextColor = textColor ?? primaryWhite;
    final Color effectiveButtonColor = buttonColor ?? primaryColor;

    return SizedBox(
      // Fills parent width by default, or uses custom width
      width: width ?? double.infinity,
      height: height ?? 48.h, // Standard "Professional" touch target height
      child: TextButton(
        autofocus: autofocus,
        onPressed: isLoading ? null : onPressed,
        style: TextButton.styleFrom(
          backgroundColor: effectiveButtonColor,
          foregroundColor: effectiveTextColor,
          disabledBackgroundColor: effectiveButtonColor.withOpacity(0.5),
          disabledForegroundColor: effectiveTextColor.withOpacity(0.5),
          elevation: 0,
          // Flat sleek look
          shape: RoundedRectangleBorder(
            side: border ?? BorderSide.none,
            borderRadius: borderRadius ?? BorderRadius.circular(12.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          // Removes default tap ripple splash overflow
          splashFactory: InkRipple.splashFactory,
        ),
        child: isLoading
            ? SizedBox(
                height: 20.h,
                width: 20.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  // Loader color matches text color (e.g., white on blue, blue on white)
                  valueColor: AlwaysStoppedAnimation<Color>(effectiveTextColor),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Shrinks row to fit content
                children: [
                  // --- Prefix Icon ---
                  if (prefixIconWidget != null) ...[
                    prefixIconWidget!,
                    SizedBox(width: 8.w),
                  ] else if (prefixIcon != null) ...[
                    SvgPicture.asset(
                      prefixIcon!,
                      // ignore: deprecated_member_use
                      color: iconColor ?? effectiveTextColor,
                      height: 20.sp,
                      width: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                  ],

                  // --- Title ---
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.normalBold14.copyWith(
                        fontSize: fontSize ?? 16.sp,
                        // Slightly larger for readability
                        color: effectiveTextColor,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // --- Trailing Icon (Optional) ---
                  if (trailIcon != null) ...[
                    SizedBox(width: 8.w),
                    SvgPicture.asset(
                      trailIcon!,
                      // ignore: deprecated_member_use
                      color: iconColor ?? effectiveTextColor,
                      height: 18.sp,
                      width: 18.sp,
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
