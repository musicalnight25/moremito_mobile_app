import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../utils/common_app_bar.dart';

class MitochondriaStoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CommonAppBar(title: "Mitochondria Story".tr, visibleBackButton: true),
      body: Center(child: Text("Mitochondria Story Screen".tr)),
    );
  }
}
