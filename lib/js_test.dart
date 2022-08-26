import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() => runApp(MaterialApp(home: WebViewExample()));

class WebViewExample extends StatefulWidget {
  @override
  _WebViewExampleState createState() => _WebViewExampleState();
}

class _WebViewExampleState extends State<WebViewExample> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String msg = '0';
  int count = 0;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter WebView example'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'From Javascript:',
            ),
            Text(
              '$msg',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(
              height: 1,
              child: Offstage(
                offstage: true,
                child: WebView(
                  initialUrl: 'about:blank',
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.complete(webViewController);
                    _loadHtmlFromAssets();
                  },
                  javascriptChannels: <JavascriptChannel>{
                    _toasterJavascriptChannel(context),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: favoriteButton(),
    );
  }

  _loadHtmlFromAssets() async {
    String file = await rootBundle.loadString('assets/js/js_test.html');
    final c = await _controller.future;
    c.loadUrl(Uri.dataFromString(file,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          setState(() {
            msg = message.message;
          });
        });
  }

  Widget favoriteButton() {
    return FutureBuilder<WebViewController>(
        future: _controller.future,
        builder: (BuildContext context,
            AsyncSnapshot<WebViewController> snapshot) {
          if (snapshot.hasData) {
            final controller = snapshot.data!;
            return FloatingActionButton(
              onPressed: () async {
                controller.evaluateJavascript('fromFlutter(${++count})');
              },
              child: const Icon(Icons.favorite),
            );
          }
          return Container();
        });
  }
}
