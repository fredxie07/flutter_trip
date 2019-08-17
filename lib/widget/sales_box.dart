import 'package:flutter/material.dart';
import 'package:flutter_trips/model/common_model.dart';
import 'package:flutter_trips/model/sales_box_model.dart';
import 'package:flutter_trips/widget/webview.dart';

//底部卡片入口
class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBox;
  const SalesBox({Key key, @required this.salesBox}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
      ),
      child: _items(context)
    );
  }
  Widget _items (BuildContext context) {
    if(salesBox == null) return null;
    List<Widget> items = [];
    items.add(_doubleItem(context, salesBox.bigCard1, salesBox.bigCard2,true, false ));
    items.add(_doubleItem(context, salesBox.smallCard1, salesBox.smallCard2,false, false ));
    items.add(_doubleItem(context, salesBox.smallCard3, salesBox.smallCard4,false, true ));
//    计算出每一行显示的图标的数量
//    int separate = (subNavList.length  / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        Container(
          height: 44,
          margin: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1,color: Color(0xfff2f2f2))
            )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Image.network(salesBox.icon,height: 15, fit: BoxFit.fill,),
              Container(
                padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
                margin: EdgeInsets.only(right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient:  LinearGradient(
                    colors: [Color(0xffff4e63), Color(0xffff6cc9) ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight
                  )
                ),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => WebView(url: salesBox.moreUrl,title: '更多活动',)) );
                  },
                  child: Text('获取更多福利 >', style: TextStyle(color: Colors.white,fontSize: 12),),
                )
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:   items.sublist(0,1)
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:   items.sublist(1,2)
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:   items.sublist(2,3)
        ),
      ],
    );
  }

  /*
  * 卡片分组
  * @params leftCard 左边卡片的数据 卡片分左右两部分
  * @params rightCard 右边卡片的数据
  * @params isBig 判断当前卡片是否为大卡片  卡片布局分为左右两部分  卡片的大小不一样也要区分出来
  * @isLast 是不是布局中两个大卡片的最后一个  要做特殊处理
  * */
  Widget _doubleItem(BuildContext context, CommonModel leftCard, CommonModel rightCard, bool isBig, bool isLast ) {
    return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: <Widget>[
      _item(context,leftCard, true, isLast,isBig),
      _item(context,rightCard, false, isLast,isBig),
    ],
    );
  }

/*
*每一个小的item
*@params model 当前卡片的数据
* @params isLeft 因为两个卡片分为左右两边 要判断是左边的还是右边的卡片
* @params isLast 是否是最后一个卡片
* @isBig 是否是大卡片  要做图片高度的处理
* */
  Widget _item(BuildContext context, CommonModel model, bool isLeft, bool isLast, bool isBig) {
    BorderSide borderSide = BorderSide(width: 0.8,color: Color(0xfff2f2f2));
    return  GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => WebView(
            url: model.url ,
            statusBarColor: model.statusBarColor,
            hideAppBar: model.hideAppBar,
          )));
        },
        child:  Container(
          decoration: BoxDecoration(
            border: Border(
              right: isLeft ? borderSide : BorderSide.none,
              bottom: isLast ? borderSide : BorderSide.none
            )
          ),
          child: Image.network(
            model.icon,
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width/2 - 10,
            height: isBig ? 129 : 80,
          ),
        )
      );
  }
}
