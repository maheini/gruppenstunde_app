import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EntryEditorScreen extends StatefulWidget {
  const EntryEditorScreen({required this.url, Key? key}) : super(key: key);
  final String url;
  @override
  State<EntryEditorScreen> createState() => _EntryEditorScreenState();
}

class _EntryEditorScreenState extends State<EntryEditorScreen> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff161c3d),
        title: const Text(
          'Beitrag bearbeiten',
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
        },
        navigationDelegate: (NavigationRequest request) {
          if (widget.url == 'https://gruppenstunde.ch/erstellen/') {
            if (request.url
                .startsWith('https://gruppenstunde.ch/gruppenstunden/')) {
              Navigator.of(context)
                  .pushReplacementNamed('page', arguments: request.url);
            } else {
              Navigator.of(context).pop();
            }
          } else {
            Navigator.of(context).pop();
          }
          return NavigationDecision.navigate;
        },
      ),
    );
  }
}
