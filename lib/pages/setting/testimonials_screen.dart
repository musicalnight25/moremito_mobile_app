import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../utils/common_app_bar.dart';

class TestimonialsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "Testimonials".tr, visibleBackButton: true),
      body: Center(child: Text("Testimonials Screen".tr)),
    );
  }
}
