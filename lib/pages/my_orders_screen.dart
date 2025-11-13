import 'package:flutter/material.dart';
import '../utils/common_app_bar.dart';

class MyOrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "My Orders", visibleBackButton: true),
      body: Center(child: Text("My Orders Screen")),
    );
  }
}
