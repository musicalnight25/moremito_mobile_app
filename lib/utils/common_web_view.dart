import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'common_app_bar.dart';

class CommonWebView extends StatefulWidget {
  final String url;
  final String title;

  const CommonWebView({Key? key, required this.url, required this.title})
      : super(key: key);

  @override
  _CommonWebViewState createState() => _CommonWebViewState();
}

class _CommonWebViewState extends State<CommonWebView> {
  InAppWebViewController? _webViewController;

  @override
  void initState() {
    log("------url--------${widget.url}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        title: widget.title,
        visibleBackButton: true,
      ),
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),

          // 1. Updated Settings to fix crash & new tab issues
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,

            // Fixes "Uncaught TypeError" seen in your logs (localStorage access)
            domStorageEnabled: true,

            // Fixes "opening in new tab" issue
            supportMultipleWindows: true,

            // Allows the site to initiate the popup
            javaScriptCanOpenWindowsAutomatically: true,
          ),

          onWebViewCreated: (controller) {
            _webViewController = controller;
          },

          // 2. Intercepts the "New Window" request and forces it to load here
          // 2. Intercepts the "New Window" request
          onCreateWindow: (controller, createWindowRequest) async {
            var url = createWindowRequest.request.url.toString();

            if (url.isNotEmpty) {
              log("Blocked new window: $url");

              // CHECK: If it is a PDF, use Google Docs Viewer
              if (url.toLowerCase().endsWith(".pdf")) {
                var googleDocsUrl =
                    "https://docs.google.com/gview?embedded=true&url=$url";
                log("Redirecting PDF to Google Docs Viewer: $googleDocsUrl");
                await controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri(googleDocsUrl)));
              } else {
                // Otherwise load normally
                await controller.loadUrl(
                    urlRequest: createWindowRequest.request);
              }

              return true; // Return true to tell WebView we handled it
            }
            return false;
          },

          onLoadStop: (controller, url) =>
              debugPrint('Page finished loading: $url'),

          onConsoleMessage: (controller, message) =>
              debugPrint(message.message),
        ),
      ),
    );
  }
}
