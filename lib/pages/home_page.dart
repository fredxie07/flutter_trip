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
const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void initState() {
    super.initState();
    _loadData();
  }
  List _imageUrls = [
    'http://pic32.nipic.com/20130823/7459925_151603450000_2.jpg',
    'http://pic163.nipic.com/file/20180421/7092831_140036752037_2.jpg',
    'http://hbimg.b0.upaiyun.com/4147548aacbd056c9311ddc62daf09e24c73e12ffc7d-py9TME_fw658'
  ];
//动态更改的透明度
  double appBarAlpha = 0;
//球区入口数据
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
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
                child:  NotificationListener(
                  onNotification: (scrollNotification) {
                    //滚动时在进行回调 并且只监听当前NotificationListener里面的第一个元素才会触发更改appBar透明度
                    if(scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                    return false;
                  },
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: 150,
                        child: Swiper(
                          itemCount: _imageUrls.length,
                          autoplay: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Image.network(_imageUrls[index],fit: BoxFit.fill,);
                          },
                          pagination: SwiperPagination(),
                        ),
                      ),
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
//                    Container(
//                      height: 800,
//                      child: ListTile(title: Text('哈哈'),),
//                    )
                    ],
                  ),
                )
            ),
            Opacity(
              opacity: appBarAlpha,
              child: Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('首页'),
                  ),
                ),
              ),
            )
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

  _loadData() async{
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        _isLoading = false;
      });
    }catch(e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }
}

