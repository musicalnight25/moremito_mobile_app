import 'package:flutter/material.dart';
import '../utils/common_app_bar.dart';

class MyNetworkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(title: "My Network", visibleBackButton: true),
      body: Center(child: Text("My Network Screen")),
    );
  }
}
