import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyAccountScreen extends StatefulWidget {
  const MyAccountScreen({required this.url, Key? key}) : super(key: key);
  final String url;
  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_controller == null) {
          return true;
        }
        String currentUrl = await _controller!.currentUrl() ?? '';

        if (currentUrl.startsWith('https://gruppenstunde.ch/mein-konto/')) {
          return true;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff161c3d),
          title: const Text(
            'Mein Konto',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: WebView(
          initialUrl: widget.url,
          onWebViewCreated: (controller) {
            _controller = controller;
          },
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (String url) async {
            await _controller?.runJavascript(
                "document.getElementsByTagName('header')[0].style.display='none';");
            await _controller?.runJavascript(
                "document.getElementsByTagName('footer')[0].style.display='none';");
            await _controller?.runJavascript(
                "document.getElementById('rememberme').checked = true;");
            await _controller?.runJavascript(
                "document.querySelector('[data-id=\"393b5b2\"]').style.display = 'none';");
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url
                .startsWith('https://gruppenstunde.ch/gruppenstunden/')) {
              Navigator.of(context)
                  .pushNamed('page', arguments: request.url)
                  .then((value) => _controller?.reload());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      ),
    );
  }
}
