import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/announcement_details_controller.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';

class AnnouncementDetailScreen extends StatefulWidget {
  final int id;

  const AnnouncementDetailScreen({Key? key, required this.id})
      : super(key: key);

  @override
  State<AnnouncementDetailScreen> createState() =>
      _AnnouncementDetailScreenState();
}

class _AnnouncementDetailScreenState
    extends State<AnnouncementDetailScreen> {
  final controller = Get.put(AnnouncementDetailsController());

  InAppWebViewController? webView;

  @override
  void initState() {
    super.initState();
    controller.fetchAnnouncementDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Announcement Details".tr,
        visibleBackButton: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final html = controller.details.value?.htmlPart;
        if (html == null || html.isEmpty) {
          return Center(child: Text("No content available".tr));
        }

        return SafeArea(
          child: InAppWebView(
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              supportZoom: true,
              useWideViewPort: true,
              builtInZoomControls: true,
              displayZoomControls: false,
            ),

            initialData: InAppWebViewInitialData(
              data: html,
              mimeType: "text/html",
              encoding: "utf-8",
              baseUrl: WebUri("https://moremito.com/"),
            ),

            onWebViewCreated: (controller) {
              webView = controller;
            },
          ),
        );
      }),
    );
  }
}