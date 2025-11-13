import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:more_mitro_app/controller/call_details_controller.dart';
import 'package:more_mitro_app/utils/common_app_bar.dart';

class CallDetailScreen extends StatefulWidget {
  final int id;
  final String templateName;

  const CallDetailScreen({
    Key? key,
    required this.id,
    required this.templateName,
  }) : super(key: key);

  @override
  State<CallDetailScreen> createState() => _CallDetailScreenState();
}

class _CallDetailScreenState extends State<CallDetailScreen> {
  final controller = Get.put(CallDetailsController());

  InAppWebViewController? webView;

  @override
  void initState() {
    super.initState();
    controller.fetchCallDetails(widget.id, widget.templateName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: "Call Details",
        visibleBackButton: true,
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final html = controller.details.value?.htmlPart;
        if (html == null || html.isEmpty) {
          return const Center(child: Text("No content available"));
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

            /// LOAD HTML ONLY AFTER DATA IS READY
            initialData: InAppWebViewInitialData(
              data: html,
              mimeType: "text/html",
              encoding: "utf-8",
              baseUrl: WebUri("https://moremito.com/"),
            ),

            onWebViewCreated: (controller) {
              webView = controller;
            },

            onLoadStop: (controller, url) {
              debugPrint("HTML Loaded Successfully");
            },

            onConsoleMessage: (controller, message) {
              debugPrint("[WebView] ${message.message}");
            },
          ),
        );
      }),
    );
  }
}
