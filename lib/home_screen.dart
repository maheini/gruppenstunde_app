import 'package:Gruppenstunde/bloc/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LoginCubit _loginCubit = LoginCubit();
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
            BlocBuilder<LoginCubit, LoginState>(
              bloc: _loginCubit,
              builder: (context, state) {
                if (state is Loggedin) {
                  return _loggedInMenu();
                } else {
                  return _loggedOutMenu();
                }
              },
            ),
          ],
        ),
        body: WebView(
          initialUrl: 'https://gruppenstunde.ch',
          javascriptMode: JavascriptMode.unrestricted,
          onPageFinished: (controller) {
            _loginCubit.checkLoginState(_controller);

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

  Widget _loggedOutMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.account_circle),
      onSelected: (result) async {
        // if (result == 1) {
        //   context.read<ListCubit>().import(FileAccessWrapper()).then(
        //     (value) {
        //       if (!value) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //             content: Text(S.of(context).import_failure),
        //             duration: const Duration(seconds: 4),
        //           ),
        //         );
        //       }
        //     },
        //   );
        // } else if (result == 2) {
        //   platformWrapper.openUrl(S.of(context).website_downloads_url,
        //       external: true);
        // } else if (result == 3) {
        //   Navigator.pushNamed(context, '/about');
        // }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: _buildPopupItem(Icons.login, 'Anmelden'),
        ),
        PopupMenuItem(
          value: 2,
          child: _buildPopupItem(Icons.person_add_alt_1, 'Registrieren'),
        ),
        PopupMenuItem(
          value: 3,
          child: _buildPopupItem(Icons.emoji_objects, 'Beitrag erstellen'),
        ),
      ],
    );
  }

  Widget _loggedInMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.account_circle),
      onSelected: (result) async {
        // if (result == 1) {
        //   context.read<ListCubit>().import(FileAccessWrapper()).then(
        //     (value) {
        //       if (!value) {
        //         ScaffoldMessenger.of(context).showSnackBar(
        //           SnackBar(
        //             content: Text(S.of(context).import_failure),
        //             duration: const Duration(seconds: 4),
        //           ),
        //         );
        //       }
        //     },
        //   );
        // } else if (result == 2) {
        //   platformWrapper.openUrl(S.of(context).website_downloads_url,
        //       external: true);
        // } else if (result == 3) {
        //   Navigator.pushNamed(context, '/about');
        // }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: _buildPopupItem(Icons.edit, 'Meine Beiträge'),
        ),
        PopupMenuItem(
          value: 2,
          child: _buildPopupItem(Icons.emoji_objects, 'Beitrag erstellen'),
        ),
        PopupMenuItem(
          value: 3,
          child: _buildPopupItem(Icons.logout, 'Abmelden'),
        ),
      ],
    );
  }

  Widget _buildPopupItem(IconData icon, String name) {
    return Row(
      children: <Widget>[
        Icon(icon, color: Colors.black),
        const SizedBox(width: 10),
        Flexible(child: Text(name)),
      ],
    );
  }
}
