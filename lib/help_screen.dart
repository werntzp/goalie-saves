import "package:flutter/material.dart";
import "shared.dart";
import 'package:webview_flutter/webview_flutter.dart';

class HelpScreen extends StatelessWidget {
  HelpScreen({Key key}) : super(key: key);
  WebViewController _controller;

  // main build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text(APP_TITLE),
          backgroundColor: Colors.black,
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
              ),
              Container(
                child: WebView(
                  initialUrl: "https://www.google.com",
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller = webViewController;
                    //_loadHtmlFromAssets();
                  },
                ),
                height: 425.0,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
                padding: const EdgeInsets.all(2.0),
              ),
              Center(
                child: Text("Version 1.0, September 2020",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
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
