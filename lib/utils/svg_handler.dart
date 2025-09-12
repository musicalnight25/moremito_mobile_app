import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:more_mitro_app/utils/app_text_style.dart';

class SvgDisplayWidget extends StatelessWidget {
  final String svgString;

  SvgDisplayWidget({required this.svgString});

  @override
  Widget build(BuildContext context) {
    return _buildSvg(svgString);
  }

  Widget _buildSvg(String svgString) {
    try {
      if (_isSvgValid(svgString)) {
        return SvgPicture.string(
          svgString,
          placeholderBuilder: (context) => CircularProgressIndicator(),
          fit: BoxFit.scaleDown,
          height: 24.sp,
          width: 24.sp,
        );
      } else {
        return Text(svgString, style: AppTextStyle.normalBold16);
      }
    } catch (e) {
      print('Error displaying SVG: $e');
      return Text('Error', style: TextStyle(color: Colors.red));
    }
  }

  bool _isSvgValid(String svgString) {
    // Basic check for SVG structure
    final svgPattern =
        RegExp(r'^<svg[^>]*>[\s\S]*</svg>$', caseSensitive: false);
    return svgPattern.hasMatch(svgString);
  }
}
