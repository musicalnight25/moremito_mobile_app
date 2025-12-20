import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more_mitro_app/utils/app_asset.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';

class PrimaryTextButton extends StatelessWidget {
  String? title;
  String? prefixIcon;
  String? trailIcon;
  VoidCallback? onPressed;
  Color? buttonColor;
  Color? textColor;
  Color? iconColor;
  double? width;
  double? height;
  bool isLoading;
  Widget? prefixIconWidget;
  BorderSide? border;
  bool autofocus;
  BorderRadiusGeometry? borderRadius;

  PrimaryTextButton({
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double padding = 20.sp; // Define horizontal padding
    final double buttonWidth =
        width ?? MediaQuery.of(context).size.width - (2 * padding);

    return Center(
      child: TextButton(
        autofocus: autofocus,
        style: TextButton.styleFrom(
            foregroundColor: textColor ?? primaryWhite,
            shape: RoundedRectangleBorder(
              side: border ?? BorderSide.none,
              borderRadius: borderRadius ?? BorderRadius.circular(12.sp),
            ),
            disabledForegroundColor: primaryWhite.withOpacity(0.38),
            backgroundColor: buttonColor ?? primaryColor,
            fixedSize: Size(
              buttonWidth,
              height ?? 42.sp,
            ),
            alignment: Alignment.center,
            textStyle: AppTextStyle.normalBold18),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  children: [
                    if (prefixIconWidget != null || prefixIcon != null)
                      prefixIconWidget ??
                          SvgPicture.asset(prefixIcon!,
                              color: iconColor, height: 20.sp, width: 20.sp),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.sp),
                      child: Text(
                        title.toString(),
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.normalBold18
                            .copyWith(color: textColor ?? primaryWhite),
                      ),
                    ),
                    // if (trailIcon != null)
                    // SvgPicture.asset(AppAsset.arrow_forward,
                    //     color: iconColor, height: 20.sp, width: 20.sp)
                  ],
                ),
              ),
        onPressed: onPressed,
      ),
    );
  }
}
