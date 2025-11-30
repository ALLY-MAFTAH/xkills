import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutWebView extends StatefulWidget {
  final String url;
  const CheckoutWebView({super.key, required this.url});

  @override
  State<CheckoutWebView> createState() => _CheckoutWebViewState();
}

class _CheckoutWebViewState extends State<CheckoutWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // Creation params — optional advanced config
    final creationParams = const PlatformWebViewControllerCreationParams();

    _controller = WebViewController.fromPlatformCreationParams(creationParams)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
         NavigationDelegate(
           onNavigationRequest: (NavigationRequest request) {
             if (request.url.contains('payment-complete')) {
               Navigator.pop(context, true);
               return NavigationDecision.prevent;
             }
             return NavigationDecision.navigate;
           },
           onPageStarted: (String url) {
             setState(() => _isLoading = true);
           },
           onPageFinished: (String url) {
             setState(() => _isLoading = false);
           },
           onWebResourceError: (WebResourceError error) {
             // handle error
           },
         ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Payment')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
