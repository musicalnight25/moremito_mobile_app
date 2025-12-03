import 'package:flutter/material.dart';
import '../../utils/common_app_bar.dart';

class GriefReliefZoomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
          title: "Grief Relief Zoom Call", visibleBackButton: true),
      body: Center(child: Text("Grief Relief Zoom Call Screen")),
    );
  }
}
