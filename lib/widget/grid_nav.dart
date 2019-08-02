import 'package:flutter/material.dart';
import 'package:flutter_trips/model/grid_nav_model.dart';

//网格
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;
  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(('GridNav')),
      ),
    );
  }
}
