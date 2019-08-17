import 'package:flutter/material.dart';
import 'package:flutter_trips/model/common_model.dart';
import 'package:flutter_trips/model/grid_nav_model.dart';
import 'package:flutter_trips/widget/webview.dart';

//网格卡片
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;
  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: _gridNavItems(context)
    );
  }
  _gridNavItems(BuildContext context) {
    List <Widget> items  = [];
    if(gridNavModel == null) return items;
    if(gridNavModel.hotel != null) {
      items.add(_gridNavItem(context,gridNavModel.hotel,true));
    }
    if(gridNavModel.flight != null) {
      items.add(_gridNavItem(context,gridNavModel.flight,false));
    }
    if(gridNavModel.travel != null) {
      items.add( _gridNavItem(context,gridNavModel.travel,false));
    }
    return items;
  }
  //分组网格
  _gridNavItem(BuildContext context, GridNavItem gridNavItem, bool first) {
      List<Widget> items = [];
      items.add(_mainItem(context, gridNavItem.mainItem));
      items.add(_doubleItem(context, gridNavItem.item1,gridNavItem.item2,));
      items.add(_doubleItem(context, gridNavItem.item3,gridNavItem.item4,));
      // 让三个item水平排列
      List<Widget> expandItems = [];
      items.forEach((item) {
        expandItems.add(Expanded(child: item,flex: 1));
      });
      Color startColor = Color(int.parse('0xff'+gridNavItem.startColor));
      Color endColor = Color(int.parse('0xff'+gridNavItem.endColor));
      return Container(
        height: 88,
        margin: first ?  null : EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          //线性渐变
          gradient: LinearGradient(
            colors: [startColor,endColor]
          )
        ),
        child: Row(
          children: expandItems,
        ),
      );
  }

  //最左侧带图片的大item
  _mainItem(BuildContext context, CommonModel model ) {
    return _wrapGesture(context, model, Stack(
      children: <Widget>[
        Image.network(model.icon,fit: BoxFit.fill,height: 88,alignment: AlignmentDirectional.bottomEnd,),
        Text(model.title,style: TextStyle(fontSize: 14,color: Colors.white))
      ],
    ),
    );
  }

  //上下挨着的item
  /*
  * @params context 上下文
  * @params topItem 上下挨着的item1
  * @params topItem 上下挨着的item2
  * @params centerItem 是否时中间的item
  * */
  _doubleItem(BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _item(context, topItem,true,),
        ),
        Expanded(
          child: _item(context, bottomItem,false,),
        ),
      ],
    );
  }

//  每一个小的item
  _item(BuildContext context,CommonModel item, bool isTopItem) {
    BorderSide borderSide = BorderSide(width: 0.8,color: Colors.white);
    return FractionallySizedBox(
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left:borderSide,
            bottom: isTopItem ? borderSide : BorderSide.none
          )
        ),
        child:_wrapGesture(context, item, Center(
          child: Text(item.title,textAlign: TextAlign.center,style: TextStyle(fontSize: 14,color: Colors.white),),
        ),)
      ),
    );
  }

  //封装公共跳转到webview的组件
  _wrapGesture(BuildContext context,CommonModel model,Widget widget, ) {
    return GestureDetector(
      child: widget,
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebView(
          url: model.url ,
          statusBarColor: model.statusBarColor,
          hideAppBar: model.hideAppBar,
          title: model.title,
        )));
      },
    );
  }
}
