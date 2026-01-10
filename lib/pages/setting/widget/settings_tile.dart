import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';
import 'package:more_mitro_app/utils/colors.dart';
import 'package:more_mitro_app/utils/static_decoration.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12.r),
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15.sp),
        margin: EdgeInsets.only(bottom: 12.sp),
        decoration: BoxDecoration(
          color: primaryWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderGreyColor.withOpacity(0.6)),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: bgPrimaryShadowColor.withOpacity(0.25),
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 18.sp, color: primaryColor),
            width12,
            Expanded(
              child: Text(
                title,
                style: AppTextStyle.normalSemiBold15.copyWith(
                  color: primaryBlack,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
