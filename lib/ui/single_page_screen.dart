import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SinglePageScreen extends StatefulWidget {
  const SinglePageScreen({this.url = '', Key? key}) : super(key: key);
  final String url;
  @override
  State<SinglePageScreen> createState() => _SinglePageScreenState();
}

class _SinglePageScreenState extends State<SinglePageScreen> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff161c3d),
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: WebView(
        initialUrl: widget.url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _controller = controller;
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.endsWith('/?edit=true')) {
            Navigator.of(context)
                .pushReplacementNamed('edit', arguments: request.url);
          } else if (!request.url.startsWith('https://gruppenstunde.ch/')) {
            _launchUrl(request.url);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageFinished: (String url) async {
          await _controller?.runJavascript(
              "document.getElementsByTagName('header')[0].style.display='none';");
          await _controller?.runJavascript(
              "document.getElementsByTagName('footer')[0].style.display='none';");
        },
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    Uri adress = Uri.parse(url);
    if (!await launchUrl(
      adress,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $adress';
    }
  }
}
