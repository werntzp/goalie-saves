import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "dart:convert";
import "shared.dart";
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({Key key}) : super(key: key);
  WebViewController _controller;

  // load up a local html page with help information
  _loadHtmlFromAssets() async {
    String fileText = await rootBundle.loadString('assets/help.html');
    _controller.loadUrl(Uri.dataFromString(fileText,
            mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  // main build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(APP_TITLE),
          backgroundColor: Colors.black,
        ),
        body: Center(
            child: Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
              ),
              Center(
                child: Text("How to Use Tendy Tracker",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        fontSize: 25)),
              ),
              Container(
                child: WebView(
                  initialUrl: "about:blank",
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                    _loadHtmlFromAssets();
                  },
                ),
                height: 400.0,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
              ),
              Center(
                child: Text("$APP_TITLE",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              Center(
                child: Text("$APP_VERSION", style: TextStyle(fontSize: 15)),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
              ),
              Center(
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Image.asset(
                    "$SDS_LOGO",
                    width: 100,
                    height: 100,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
              ),
              Center(
                child: FloatingActionButton(
                    heroTag: "fab1",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    backgroundColor: Colors.black,
                    tooltip: "Back",
                    mini: true,
                    child: Icon(Icons.arrow_back)),
              ),
            ],
          ),
        )));
  }
}
