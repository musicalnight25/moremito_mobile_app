import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/utils/colors.dart';

class BaseBackgroundWidget extends StatelessWidget {
  final Widget child;
  const BaseBackgroundWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [bgPrimaryShadowColor, primaryWhite, bgPrimaryShadowColor],
            stops: [0.1, 0.5, 1.0]),
      ),
      child: SafeArea(child: child),
    );
  }
}
