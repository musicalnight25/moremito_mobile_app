import 'dart:developer';
import 'dart:async';
import 'dart:math' as math;

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
  bool _isPageLoading = true;
  bool _showBlockingLoader = true;
  int _realProgress = 0;
  double _displayProgress = 0;
  Timer? _progressTimer;

  @override
  void initState() {
    log("------url--------${widget.url}");
    super.initState();
    _startProgressSimulation();
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  void _startProgressSimulation() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted || !_isPageLoading) return;
      setState(() {
        final target = math.max(_displayProgress, _realProgress.toDouble());
        if (target < 70) {
          _displayProgress = math.min(70, target + 1.8);
        } else if (target < 90) {
          _displayProgress = math.min(90, target + 0.9);
        } else if (target < 96) {
          _displayProgress = math.min(96, target + 0.35);
        } else {
          _displayProgress = target;
        }
      });
    });
  }

  void _completeProgress() {
    _progressTimer?.cancel();
    setState(() {
      _displayProgress = 100;
      _realProgress = 100;
      _isPageLoading = false;
      _showBlockingLoader = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: CommonAppBar(
        title: widget.title,
        visibleBackButton: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportMultipleWindows: true,
                javaScriptCanOpenWindowsAutomatically: true,
                transparentBackground: false,
                cacheEnabled: true,
              ),
              onWebViewCreated: (_) {},
              onLoadStart: (_, __) {
                if (!mounted) return;
                setState(() {
                  _isPageLoading = true;
                  _showBlockingLoader = true;
                  _realProgress = 0;
                  _displayProgress = 0;
                });
                _startProgressSimulation();
              },
              onProgressChanged: (_, progress) {
                if (!mounted) return;
                setState(() {
                  _realProgress = progress;
                  _displayProgress = math.max(_displayProgress, progress.toDouble());
                  _isPageLoading = progress < 100;
                  if (progress >= 70) {
                    _showBlockingLoader = false;
                  }
                });
              },
              onPageCommitVisible: (_, __) {
                if (!mounted) return;
                setState(() {
                  _showBlockingLoader = false;
                });
              },
              onCreateWindow: (controller, createWindowRequest) async {
                var url = createWindowRequest.request.url.toString();

                if (url.isNotEmpty) {
                  log("Blocked new window: $url");

                  if (url.toLowerCase().endsWith(".pdf")) {
                    var googleDocsUrl =
                        "https://docs.google.com/gview?embedded=true&url=$url";
                    log("Redirecting PDF to Google Docs Viewer: $googleDocsUrl");
                    await controller.loadUrl(
                        urlRequest: URLRequest(url: WebUri(googleDocsUrl)));
                  } else {
                    await controller.loadUrl(
                        urlRequest: createWindowRequest.request);
                  }

                  return true;
                }
                return false;
              },
              onLoadStop: (controller, url) {
                if (!mounted) return;
                _completeProgress();
                debugPrint('Page finished loading: $url');
              },
              onReceivedError: (_, __, error) {
                if (!mounted) return;
                _progressTimer?.cancel();
                setState(() {
                  _isPageLoading = false;
                  _showBlockingLoader = false;
                });
                debugPrint('WebView error: ${error.description}');
              },
              onConsoleMessage: (controller, message) =>
                  debugPrint(message.message),
            ),
            if (_isPageLoading) ...[
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                child: LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: const Color(0xFFCBD5E1),
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF0F766E)),
                  value: _displayProgress <= 0 ? null : _displayProgress / 100,
                ),
              ),
              if (_showBlockingLoader)
                Container(
                  color: const Color(0xFFF4F6F8),
                  alignment: Alignment.center,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 16,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor:
                                AlwaysStoppedAnimation(Color(0xFF0F766E)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          _displayProgress > 0
                              ? 'Loading ${_displayProgress.toInt()}%'
                              : 'Preparing page...',
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
