import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenIframe extends StatelessWidget {
  static const routeName = '/webview-iframe';
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewScreenIframe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedUrl = ModalRoute.of(context)!.settings.arguments as String;
    print(selectedUrl);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/dd.png',
              height: 200,
              width: 200,
            ),
          ],
        ),
      ),
      body: WebView(
        initialUrl: Uri.dataFromString(
                '<html><body>'
                    '<iframe style="height: 100%;width:100%" src="https://player.vdocipher.com/v2/?$selectedUrl"></iframe>'
                    '</body></html>',
                mimeType: 'text/html')
            .toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
