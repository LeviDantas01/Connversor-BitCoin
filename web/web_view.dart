import 'dart:async';

import 'package:conversor_moedas/web/navigation_controls.dart';
import 'package:conversor_moedas/web/web_view_stack.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:conversor_moedas/web/web_view.dart';
import 'dart:io';

class WebViewApp extends StatefulWidget {
  final String url;
  const WebViewApp({super.key, required this.url});

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  final controller = Completer<WebViewController>();

  @override
  void initState() {
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          NavigationControls(controller: controller),
        ],
      ),
      body: WebViewStack(controller: controller,url: widget.url,),
    );
  }
}
