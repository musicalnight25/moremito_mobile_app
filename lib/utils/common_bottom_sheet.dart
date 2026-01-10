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
  final bool isDestructive; // Added for red icon styling

  const CommonBottomSheet({
    Key? key,
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
    this.isDestructive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
      decoration: BoxDecoration(
        color: primaryWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- 1. Drag Handle (The "Pill") ---
            Container(
              width: 36.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: borderGreyColor,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 24.h),

            // --- 2. Optional Icon (Sleek Circle) ---
            if (icon != null) ...[
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isDestructive ? softRedColor : paleYellowColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 28.sp,
                  color: isDestructive ? redColor : primaryColor,
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // --- 3. Title ---
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyle.normalBold16.copyWith(
                fontSize: 18.sp,
                color: lightBlackColor,
                letterSpacing: -0.5, // Tighter tracking for modern look
              ),
            ),
            SizedBox(height: 8.h),

            // --- 4. Message Content ---
            if (messageWidget != null)
              messageWidget!
            else if (message != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: lightBlackColor,
                    height: 1.5, // Better readability
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

            SizedBox(height: 24.h),

            // --- 5. Action Buttons ---
            if (customWidget != null)
              customWidget!
            else
              Column(
                children: [
                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: PrimaryTextButton(
                      title: confirmButtonTitle,
                      onPressed: onConfirm,
                      // Sleek logic: If no color provided, use Primary or Red based on context
                      buttonColor: confirmButtonColor ??
                          (isDestructive ? redColor : primaryColor),
                      textColor: confirmButtonTextColor ?? primaryWhite,
                    ),
                  ),

                  // Cancel Button (Styled as ghost button, not just text)
                  if (showCancelButton ?? false) ...[
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 48.h, // Match height of primary button usually
                      child: TextButton(
                        onPressed: onCancel ?? () => Get.back(),
                        style: TextButton.styleFrom(
                          foregroundColor:
                              cancelButtonTextColor ?? lightBlackColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          splashFactory: NoSplash.splashFactory, // cleaner tap
                        ),
                        child: Text(
                          cancelButtonTitle ?? "Cancel",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: cancelButtonTextColor ?? lightBlackColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
