import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../components/custom_loader.dart';
import '/controllers/payment_controller.dart';

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

  @override
  void initState() {
    super.initState();

    final creationParams = const PlatformWebViewControllerCreationParams();

    _controller =
        WebViewController.fromPlatformCreationParams(creationParams)
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
              onPageStarted: (_) => setState(() => _isLoading = true),
              onPageFinished: (_) => setState(() => _isLoading = false),
            ),
          )
          ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
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
                    top: topPadding + 35,
                    left: 10,
                    right: 10,
                    bottom: 10,
                  ),
                  child: Text(
                    "Complete Card Payment".tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Make WebView take all remaining space
                Expanded(
                  child: Stack(
                    children: [
                      WebViewWidget(controller: _controller),
                      if (_isLoading) Center(child: customLoader()),
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
