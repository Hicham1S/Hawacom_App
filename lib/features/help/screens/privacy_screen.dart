import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Privacy policy screen with WebView
class PrivacyScreen extends StatefulWidget {
  final String? url;
  final String? pageId;

  const PrivacyScreen({
    super.key,
    this.url,
    this.pageId,
  });

  @override
  State<PrivacyScreen> createState() => _PrivacyScreenState();
}

class _PrivacyScreenState extends State<PrivacyScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    // Determine the URL to load
    String urlToLoad;
    if (widget.url != null && widget.url!.isNotEmpty) {
      urlToLoad = widget.url!;
    } else if (widget.pageId != null && widget.pageId!.isNotEmpty) {
      // Build URL from page ID - adjust the base URL to match your API
      urlToLoad =
          'https://hawacom.sa/admin/public/api/custom_pages/${widget.pageId}';
    } else {
      // Default privacy policy URL
      urlToLoad = 'https://hawacom.sa/privacy-policy';
    }

    // Initialize the WebView controller
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
              _hasError = false;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              _isLoading = false;
              _hasError = true;
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(urlToLoad));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سياسة الخصوصية - Privacy Policy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.reload();
            },
            tooltip: 'إعادة التحميل - Reload',
          ),
        ],
      ),
      body: Stack(
        children: [
          // WebView
          WebViewWidget(controller: _controller),

          // Loading indicator
          if (_isLoading && !_hasError)
            const Center(
              child: CircularProgressIndicator(),
            ),

          // Error view
          if (_hasError)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'فشل في تحميل الصفحة\nFailed to load page',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _hasError = false;
                          _isLoading = true;
                        });
                        _controller.reload();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة - Retry'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
