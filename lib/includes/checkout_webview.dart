import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '../../theme/app_colors.dart';

class CompletePaymentWebView extends StatefulWidget {
  final String url;
  const CompletePaymentWebView({super.key, required this.url});

  @override
  State<CompletePaymentWebView> createState() => _CompletePaymentWebViewState();
}

class _CompletePaymentWebViewState extends State<CompletePaymentWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  static const String redirectHost = "app.local";
  static const String redirectPath = "/payment-complete";

  @override
  void initState() {
    super.initState();

    final creationParams = const PlatformWebViewControllerCreationParams();

    _controller =
        WebViewController.fromPlatformCreationParams(creationParams)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: _handleNavigation,
              onPageStarted: (_) => setState(() => _isLoading = true),
              onPageFinished: (_) => setState(() => _isLoading = false),
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  NavigationDecision _handleNavigation(NavigationRequest request) {
    final uri = Uri.parse(request.url);
    debugPrint("WebView navigating to: $uri");

    // 🔥 Catch redirect
    if (uri.host == redirectHost && uri.path == redirectPath) {
      _handleRedirect(uri);
      return NavigationDecision.prevent;
    }

    // 🔒 Prevent external apps / browser jumps
    if (uri.scheme == "intent" ||
        uri.scheme == "tel" ||
        uri.scheme == "mailto") {
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _handleRedirect(Uri uri) {
    final status = uri.queryParameters['status'];
    final orderId = uri.queryParameters['order_id'];

    debugPrint("Payment redirect captured:");
    debugPrint("Status: $status");
    debugPrint("Order ID: $orderId");

    Navigator.pop(context, {
      "status": status,
      "order_id": orderId,
    });
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top:  65,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    "Complete Card Payment".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Expanded(
                  child: Stack(
                    children: [
                      WebViewWidget(controller: _controller),
                      if (_isLoading)
                        Center(
                          child: customLoader(
                            color: AppColors.primaryColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          appBrand(context: context, hasBackButton: true),
        ],
      ),
    );
  }
}
