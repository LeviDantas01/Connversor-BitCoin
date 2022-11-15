import 'dart:async';
import 'package:conversor_moedas/main.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NavigationControls extends StatelessWidget {
  const NavigationControls({required this.controller, Key? key})
      : super(key: key);

  final Completer<WebViewController> controller;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller.future,
      builder: (context, snapshot) {
        final WebViewController? controller = snapshot.data;
        if (snapshot.connectionState != ConnectionState.done ||
            controller == null) {
          return Row(
            children: const <Widget>[
              Icon(Icons.close),
            ],
          );
        }
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (c) {
                      return Home();
                    },
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
