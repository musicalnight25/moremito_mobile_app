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

  // No manual disposal of _webViewController is necessary.

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
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
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
