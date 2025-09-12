import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:more_mitro_app/utils/colors.dart';

class ShadowContainerWidget extends StatelessWidget {
  final Widget widget;
  double? padding;
  double? radius;
  BorderRadiusGeometry? customRadius;
  double? blurRadius;
  double? borderWidth;
  Color? shadowColor;
  Color? borderColor;
  Color? color;

  ShadowContainerWidget(
      {Key? key,
      required this.widget,
      this.padding,
      this.radius,
      this.borderWidth,
      this.blurRadius,
      this.customRadius,
      this.borderColor,
      this.shadowColor,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(padding ?? 12.0),
        decoration: BoxDecoration(
          color: color ?? primaryWhite,
          boxShadow: blurRadius == 0
              ? null
              : [
                  BoxShadow(
                    blurRadius: blurRadius ?? 10.0,
                    color: shadowColor ?? borderGreyColor,
                  ),
                ],
          borderRadius: customRadius ?? BorderRadius.circular(radius ?? 12.sp),
          border: Border.all(
              color: borderColor ?? borderGreyColor,
              width: borderWidth ?? 2.sp),
        ),
        child: widget);
  }
}
