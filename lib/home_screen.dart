import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  WebViewController? _controller;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller?.currentUrl() == 'https://gruppenstunde.ch/') {
          return true;
        }
        _controller?.goBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff161c3d),
          title: const Text(
            'Gruppenstunde',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              _controller?.loadUrl('https://gruppenstunde.ch');
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _controller?.runJavascript(
                    "document.getElementsByClassName('menu-mobile-toggle')[0].click();");
                _controller?.runJavascript(
                    "document.getElementsByClassName('close-sidebar-panel')[0].style.display='none';");

                // _controller?.goBack();
              },
              icon: const Icon(
                Icons.menu,
              ),
            ),
          ],
        ),
        body: WebView(
          initialUrl: 'https://gruppenstunde.ch',
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (controller) {
            _controller?.runJavascript(
                "document.getElementsByTagName('header')[0].style.display='none';");
            _controller?.runJavascript(
                "document.getElementsByTagName('footer')[0].style.display='none';");
          },
          onWebViewCreated: (controller) {
            _controller = controller;
            _controller?.runJavascript(
                "document.getElementsByTagName('header')[0].style.display='none';");
            _controller?.runJavascript(
                "document.getElementsByTagName('footer')[0].style.display='none';");
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith("https://gruppenstunde.ch")) {
              return NavigationDecision.navigate;
            } else {
              _launchUrl(request.url);
              return NavigationDecision.prevent;
            }
          },
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    Uri adress = Uri.parse(url);
    if (!await launchUrl(
      adress,
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Could not launch $adress';
    }
  }
}
