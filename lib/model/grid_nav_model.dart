
import 'package:flutter_trips/model/common_model.dart';

//首页网格model
class GridNavModel {
  final GridNavItem hotel; //酒店
  final GridNavItem flight; //机票
  final GridNavItem travel; //旅游
  GridNavModel({this.hotel,this.flight,this.travel});
  //工厂
  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    return json != null  ? GridNavModel (
      hotel: GridNavItem.fromJson(json['hotel']),
      flight: GridNavItem.fromJson(json['flight']),
      travel: GridNavItem.fromJson(json['travel']),
    ): null;
  }
}

//处理gridNav（网格）的既有字符串又有object的数据格式
class GridNavItem{
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel   item1;
  final CommonModel   item2;
  final CommonModel   item3;
  final CommonModel   item4;

  GridNavItem({this.startColor, this.endColor, this.mainItem, this.item1, this.item2, this.item3, this.item4});
factory  GridNavItem.fromJson(Map<String, dynamic> json) {
    return GridNavItem(
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem:CommonModel.fromJson( json['mainItem']),
      item1:CommonModel.fromJson(json['item1']),
      item2:CommonModel.fromJson(json['item2']),
      item3:CommonModel.fromJson(json['item3']),
      item4:CommonModel.fromJson(json['item4']),
    );
  }
}