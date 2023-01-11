import 'package:estate_portal_copy/screens/pages/signIn_page.dart';
import 'package:estate_portal_copy/services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late WebViewController _controller;

  get onClickedSignUp => null;
  _goBack() async {
    if (await _controller.canGoBack()) {
      _controller.goBack;
    }
  }

  _goForward() async {
    if (await _controller.canGoForward()) {
      _controller.goForward;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(''),
            ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginPage(onClickedSignUp: () {})));
                },
                child: Text(
                  'Sign In',
                  style: TextStyle(
                      color: Constants.redDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ))
          ],
        ),
      ),
      body: WebView(
        initialUrl: 'https://romaxproperties.com',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webviewcontroller) {
          _controller = webviewcontroller;
        },
      ),
    );
  }
}
