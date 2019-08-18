import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trips/model/common_model.dart';
import 'package:flutter_trips/model/grid_nav_model.dart';
import 'package:flutter_trips/model/home_model.dart';
import 'package:flutter_trips/dao/home_dao.dart';
import 'package:flutter_trips/model/sales_box_model.dart';
import 'package:flutter_trips/widget/grid_nav.dart';
import 'package:flutter_trips/widget/loading_container.dart';
import 'package:flutter_trips/widget/local_nav.dart';
import 'package:flutter_trips/widget/sales_box.dart';
import 'package:flutter_trips/widget/sub_nav.dart';
import 'package:flutter_trips/widget/webview.dart';
const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    _handleRefresh();
  }
//动态更改的透明度
  double appBarAlpha = 0;
//球区入口数据
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel ;
  SalesBoxModel salesBoxModel ;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      //剔除padding
      body: LoadingContainer(
        isLoading: _isLoading,
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child:  RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: NotificationListener(
                      onNotification: (scrollNotification) {
                        //滚动时在进行回调 并且只监听当前NotificationListener里面的第一个元素才会触发更改appBar透明度
                        if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                        return false;
                      },
                      child:  _listView
                    )
                )
            ),
            _appBar
          ],
        ),
      )
    );
  }

  //判断是否显示导航栏
  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if( alpha < 0 )
      alpha = 0;
      else if( alpha > 1)
      alpha  = 1;
    setState(() {
       appBarAlpha = alpha;
    });
  }

  Future<Null> _handleRefresh() async{
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        bannerList = model.bannerList;
        _isLoading = false;
      });
    }catch(e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
    return null;
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _banner,
        Padding(
          padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
          child:  LocalNav(localNavList: localNavList,),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child:   GridNav( gridNavModel:gridNavModel ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child:   SubNav( subNavList : subNavList ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
          child:   SalesBox( salesBox: salesBoxModel ),
        ),
      ],
    );
  }

  Widget get _banner {
    return    Container(
      height: 150,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              CommonModel model = bannerList[index];
              Navigator.push(context, MaterialPageRoute(builder: (context) =>WebView(
                url:  model.url,
                title: model.title,
                hideAppBar:model.hideAppBar,
              )));
            },
            child: Image.network(bannerList[index].icon,fit: BoxFit.fill,),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  Widget get _appBar {
    return    Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('谢福泰毕业设计'),
          ),
        ),
      ),
    );
  }
}


