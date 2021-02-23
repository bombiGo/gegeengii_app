import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class CustomWebView extends StatefulWidget {
  final String selectedUrl;

  CustomWebView({this.selectedUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      url = Uri.decodeComponent(url);

      print("url: $url");

      if (url.contains('https://gegeengii.mn/social?')) {
        if (url.contains("?token")) {
          var params = url.split("token=");
          var userId = params[1].split("&")[3];
          userId = userId.split("#")[0];

          List<String> userData = [
            params[1].split("&")[0].toString(),
            params[1].split("&")[1].toString(),
            params[1].split("&")[2].toString(),
            userId.toString()
          ];

          String jsonData = jsonEncode(userData);
          Navigator.pop(context, jsonData);
        } else {
          var params = url.split("error=");
          var endparam = params[1].split("&");

          String jsonData = jsonEncode([endparam[0]]);

          Navigator.pop(context, jsonData);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.selectedUrl,
      userAgent: "Mozilla/5.0 Google",
      appBar: new AppBar(
        backgroundColor: Color.fromRGBO(66, 103, 178, 1),
        title: new Text("Social login"),
      ),
    );
  }
}
