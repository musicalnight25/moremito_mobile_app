import 'dart:developer';
import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

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
  bool _hasRedirectedEmbeddedPdf = false;
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

  bool _isGoogleViewerUrl(String url) =>
      url.toLowerCase().contains("docs.google.com/gview");

  bool _looksLikePdfUrl(String url) {
    final lower = url.toLowerCase();
    return lower.contains(".pdf") ||
        lower.contains("actionname=compensationplanpdf");
  }

  bool _shouldUseDesktopUserAgent() {
    final lower = widget.url.toLowerCase();
    return lower.contains("actionname=training");
  }

  bool _isTrainingPageUrl(String url) =>
      url.toLowerCase().contains("actionname=training");

  String _toGoogleViewerUrl(String url) {
    final encoded = Uri.encodeComponent(url);
    return "https://docs.google.com/gview?embedded=true&url=$encoded";
  }

  String _getInitialUrl() {
    if (_looksLikePdfUrl(widget.url) && !_isGoogleViewerUrl(widget.url)) {
      return _toGoogleViewerUrl(widget.url);
    }
    return widget.url;
  }

  Future<void> _redirectToGoogleViewerIfNeeded(WebUri? uri) async {
    final current = uri?.toString() ?? "";
    if (current.isEmpty ||
        _isGoogleViewerUrl(current) ||
        !_looksLikePdfUrl(current)) {
      return;
    }

    final viewerUrl = _toGoogleViewerUrl(current);
    await _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(viewerUrl)),
    );
  }

  Future<void> _tryRedirectTrainingEmbeddedPdf(
      InAppWebViewController controller, WebUri? uri) async {
    final current = uri?.toString() ?? "";
    if (current.isEmpty ||
        _hasRedirectedEmbeddedPdf ||
        _isGoogleViewerUrl(current) ||
        !_isTrainingPageUrl(current)) {
      return;
    }

    try {
      final result = await controller.evaluateJavascript(source: '''
        (() => {
          const toAbs = (u) => {
            try { return new URL(u, window.location.href).href; } catch (_) { return u || ''; }
          };
          const links = [];
          document.querySelectorAll('iframe[src],embed[src],object[data],a[href]').forEach((el) => {
            const raw = el.getAttribute('src') || el.getAttribute('data') || el.getAttribute('href') || '';
            if (raw) links.push(toAbs(raw));
          });

          const html = document.documentElement ? document.documentElement.innerHTML : '';
          const match = html.match(/https?:\\/\\/[^"'\\s>]+\\.pdf(?:\\?[^"'\\s>]*)?/i);
          if (match && match[0]) links.push(match[0]);

          const pdf = links.find((u) => (u || '').toLowerCase().includes('.pdf'));
          return pdf || '';
        })();
      ''');

      final pdfUrl = (result ?? '').toString().trim();
      if (pdfUrl.isEmpty || _isGoogleViewerUrl(pdfUrl)) return;

      await _loadPdfIntoInAppViewer(controller, pdfUrl);
    } catch (e) {
      debugPrint('Training PDF extraction failed: $e');
    }
  }

  String? _resolvePdfUrlFromResource(String resourceUrl) {
    if (resourceUrl.isEmpty) return null;

    final lower = resourceUrl.toLowerCase();
    if (_isGoogleViewerUrl(resourceUrl)) return null;

    if (lower.contains("viewer.html?file=")) {
      final uri = Uri.tryParse(resourceUrl);
      final fileParam = uri?.queryParameters["file"];
      if (fileParam == null || fileParam.isEmpty) return null;
      if (fileParam.toLowerCase().startsWith("http")) return fileParam;
      final base = uri?.origin ?? "https://moremito.com";
      return Uri.parse(base).resolve(fileParam).toString();
    }

    if (lower.contains(".pdf")) {
      return resourceUrl;
    }

    if (lower.contains("/upload/")) {
      final uri = Uri.tryParse(resourceUrl);
      if (uri != null) {
        return uri.toString();
      }
    }

    return null;
  }

  Future<void> _loadPdfIntoInAppViewer(
      InAppWebViewController controller, String pdfUrl) async {
    if (_hasRedirectedEmbeddedPdf || _isGoogleViewerUrl(pdfUrl)) return;
    debugPrint('Loading PDF in in-app viewer: $pdfUrl');
    _hasRedirectedEmbeddedPdf = true;
    await controller.loadUrl(
      urlRequest: URLRequest(url: WebUri(_toGoogleViewerUrl(pdfUrl))),
    );
  }

  Future<void> _applyTrainingViewerFixes(
      InAppWebViewController controller, WebUri? uri) async {
    final current = uri?.toString() ?? "";
    if (current.isEmpty || !_isTrainingPageUrl(current)) return;

    try {
      await controller.evaluateJavascript(source: '''
        (() => {
          try {
            const styleId = 'mm-training-mobile-fix-style';
            if (!document.getElementById(styleId)) {
              const style = document.createElement('style');
              style.id = styleId;
              style.innerHTML = `
                html, body {
                  width: 100% !important;
                  min-height: 100% !important;
                  overflow: auto !important;
                  background: #f4f4f4 !important;
                }
                iframe, embed, object, canvas, .pdfViewer, #viewerContainer, #viewer {
                  display: block !important;
                  visibility: visible !important;
                  opacity: 1 !important;
                  width: 100% !important;
                  max-width: 100% !important;
                }
                #viewerContainer, .pdfViewer, #viewer {
                  min-height: 78vh !important;
                }
              `;
              document.head.appendChild(style);
            }

            const elems = document.querySelectorAll('iframe,embed,object,canvas,#viewerContainer,#viewer,.pdfViewer');
            elems.forEach((el) => {
              el.style.setProperty('display', 'block', 'important');
              el.style.setProperty('visibility', 'visible', 'important');
              el.style.setProperty('opacity', '1', 'important');
              el.style.setProperty('width', '100%', 'important');
              el.style.setProperty('min-height', '78vh', 'important');
              if (el.tagName === 'IFRAME') {
                el.removeAttribute('loading');
              }
            });
          } catch (_) {}
        })();
      ''');
    } catch (e) {
      debugPrint('Training viewer style injection failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final initialUrl = _getInitialUrl();

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
              initialUrlRequest: URLRequest(url: WebUri(initialUrl)),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                supportMultipleWindows: true,
                javaScriptCanOpenWindowsAutomatically: true,
                transparentBackground: false,
                cacheEnabled: true,
                useShouldOverrideUrlLoading: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                useHybridComposition: false,
                userAgent: _shouldUseDesktopUserAgent()
                    ? "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
                    : null,
              ),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (_, __) {
                if (!mounted) return;
                _hasRedirectedEmbeddedPdf = false;
                setState(() {
                  _isPageLoading = true;
                  _showBlockingLoader = true;
                  _realProgress = 0;
                  _displayProgress = 0;
                });
                _startProgressSimulation();
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url?.toString() ?? "";
                if (_looksLikePdfUrl(url) && !_isGoogleViewerUrl(url)) {
                  final viewerUrl = _toGoogleViewerUrl(url);
                  await controller.loadUrl(
                    urlRequest: URLRequest(url: WebUri(viewerUrl)),
                  );
                  return NavigationActionPolicy.CANCEL;
                }
                return NavigationActionPolicy.ALLOW;
              },
              onProgressChanged: (_, progress) {
                if (!mounted) return;
                setState(() {
                  _realProgress = progress;
                  _displayProgress =
                      math.max(_displayProgress, progress.toDouble());
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
                    var googleDocsUrl = _toGoogleViewerUrl(url);
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
                _redirectToGoogleViewerIfNeeded(url);
                _tryRedirectTrainingEmbeddedPdf(controller, url);
                _applyTrainingViewerFixes(controller, url);
                if (!mounted) return;
                _completeProgress();
                debugPrint('Page finished loading: $url');
              },
              onLoadResource: (controller, resource) async {
                final url = resource.url.toString();
                if (_isTrainingPageUrl(widget.url) &&
                    (url.toLowerCase().contains(".pdf") ||
                        url.toLowerCase().contains("/upload/") ||
                        url.toLowerCase().contains("viewer.html?file="))) {
                  debugPrint('Training resource candidate: $url');
                }
                final resolvedPdfUrl = _resolvePdfUrlFromResource(url);
                if (resolvedPdfUrl != null) {
                  await _loadPdfIntoInAppViewer(controller, resolvedPdfUrl);
                }
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
                              ? '${"Loading".tr} ${_displayProgress.toInt()}%'
                              : 'Preparing page...'.tr,
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
