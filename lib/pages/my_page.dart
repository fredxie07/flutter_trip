import 'package:flutter/material.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  var  defaultColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text('我的'),
        ),
    );
  }
}

