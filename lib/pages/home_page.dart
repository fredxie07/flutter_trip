import 'package:flutter/material.dart';
import 'package:flutter_trips/dao/home_dao.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    loadData();
  }
  String resultString = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(resultString),
      )
    );
  }
  loadData() {
    HomeDao.fetch().then((result) {
//    try {
      setState(() {
        resultString = json.encode(result.config);
      });
//    }catch(e) {
//      setState(() {
//        resultString = e.toString();
//      });
//    }
    });
  }
}

