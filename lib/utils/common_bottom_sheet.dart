import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import 'app_text_style.dart';
import 'primary_text_button.dart';
import 'static_decoration.dart';

class CommonBottomSheet extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? messageWidget;
  final Widget? customWidget;
  final String confirmButtonTitle;
  final String? cancelButtonTitle;
  final IconData? icon;
  final Color? confirmButtonColor;
  final Color? confirmButtonTextColor;
  final Color? cancelButtonTextColor;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final bool? showCancelButton;

  CommonBottomSheet({
    required this.title,
    required this.message,
    required this.confirmButtonTitle,
    this.cancelButtonTitle,
    this.customWidget,
    this.icon,
    this.messageWidget,
    this.confirmButtonColor,
    this.confirmButtonTextColor,
    this.cancelButtonTextColor,
    required this.onConfirm,
    this.onCancel,
    this.showCancelButton,
  });

  @override
  Widget build(BuildContext context) {
    Widget contentWidget;

    if (messageWidget != null) {
      contentWidget = messageWidget!;
    } else if (message != null) {
      contentWidget = Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.sp),
        child: Text(
          message!,
          style: AppTextStyle.normalRegular16.copyWith(color: lightBlackColor),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      contentWidget = SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: Get.height - 50, // Prevents full-screen overflow
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon ?? Icons.error_outline,
                size: 40.sp,
              ),
              height15,
              Text(
                title,
                style: AppTextStyle.normalBold24,
              ),
              height10,
              contentWidget,
              height15,
              customWidget ??
                  PrimaryTextButton(
                    title: confirmButtonTitle,
                    onPressed: onConfirm,
                    buttonColor: confirmButtonColor ?? primaryColor,
                    textColor: confirmButtonTextColor ?? primaryWhite,
                  ),
              if (showCancelButton ?? false) ...[
                height10,
                TextButton(
                  onPressed: onCancel ?? () => Get.back(),
                  child: Text(
                    cancelButtonTitle ?? "Cancel",
                    style: AppTextStyle.normalBold16.copyWith(
                      color: cancelButtonTextColor ?? redColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
              height10,
            ],
          ),
        ),
      ),
    );
  }
}
