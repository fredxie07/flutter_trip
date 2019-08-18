import 'package:flutter/material.dart';
import 'package:flutter_trips/dao/search_dao.dart';
import 'package:flutter_trips/model/search_model.dart';
import 'package:flutter_trips/navigator/tab_navigator.dart';
import 'package:flutter_trips/widget/search_bar.dart';

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          SearchBar(
            hideLeft: false,
            defaultText: '哈哈',
            hint: '123',
            leftButtonClick: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TabNavigator()));
            },
            onChange: _onTextChanged,
          ),
        ],
      )
    );
  }
  _onTextChanged(text) {
    print(text);
  }
}

