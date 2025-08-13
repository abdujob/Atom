import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WaveWebViewPage extends StatefulWidget {
  final String paymentUrl;

  const WaveWebViewPage({super.key, required this.paymentUrl});

  @override
  State<WaveWebViewPage> createState() => _WaveWebViewPageState();
}

class _WaveWebViewPageState extends State<WaveWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.paymentUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted); // Permettre JavaScript si nécessaire
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Paiement Wave"),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
