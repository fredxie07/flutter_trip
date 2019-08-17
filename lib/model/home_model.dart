import 'package:flutter_trips/model/common_model.dart';
import 'package:flutter_trips/model/config_model.dart';
import 'package:flutter_trips/model/grid_nav_model.dart';
import 'package:flutter_trips/model/sales_box_model.dart';

//首页model
class HomeModel {
  final ConfigModel config;
  //首页轮播图
  final List<CommonModel> bannerList;
  //首页banner 下面的五个图标
  final List<CommonModel> localNavList;
  //首页网格（酒店，机票，旅游）
  final GridNavModel gridNav;
  //首页网格下的两排图标
  final List<CommonModel> subNavList;
  //首页最下方的活动人口
  final SalesBoxModel salesBox;

  HomeModel({this.config,this.bannerList,this.localNavList,this.gridNav,this.subNavList,this.salesBox});

  factory HomeModel.fromJson(Map<String,dynamic> json) {
    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList = localNavListJson.map((i) => CommonModel.fromJson(i)).toList();

    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList = bannerListJson.map((i) => CommonModel.fromJson(i)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList = subNavListJson.map((i) => CommonModel.fromJson(i)).toList();
    return HomeModel(
      localNavList: localNavList,
      bannerList: bannerList,
      subNavList: subNavList,
      config: ConfigModel.fromJson(json['config']),
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox:SalesBoxModel.fromJson(json['salesBox'])
    );
  }
}