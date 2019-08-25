import 'package:flutter/material.dart';
import 'package:flutter_trips/widget/webview.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var  defaultColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
          url: 'https://m.ctrip.com/webapp/myctrip/',
          hideAppBar: true,
          backForbid: true,
          statusBarColor: '4c5bca',
        )
    );
  }
}

