import 'package:flutter/material.dart';
import 'package:flutter_trips/dao/travel_dao.dart';
import 'package:flutter_trips/model/travel_model.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_trips/widget/loading_container.dart';
import 'package:flutter_trips/widget/webview.dart';

const PAGE_SIZE = 10;
const _TRAVEL_URL = 'https://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5';
class TravelTabPage extends StatefulWidget {
  final String travelUrl; //接口地址
  final String groupChannelCode;
  const TravelTabPage({Key key, this.travelUrl, this.groupChannelCode}) : super(key: key); //显示哪个类型的tab内容
  @override
  _TravelTabPageState createState() => _TravelTabPageState();
}

class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin {
  List<TravelItem> travelItems = [];
  int pageIndex = 1;
  bool _isLoading = true;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: LoadingContainer(
            isLoading: _isLoading,
            //瀑布流插件
            child: new StaggeredGridView.countBuilder (
              crossAxisCount: 4, //显示四列
              itemCount: travelItems?.length ?? 0,
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) => _TravelItem(index: index, travelItem: travelItems[index],),
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.fit(2), //每个元素占两列的位置
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ),
        ),
      )
    );
  }

  //获取服务端数据
  void _loadData({loadMore = false}) {
    if(loadMore) {
      pageIndex ++;
    }else {
      pageIndex = 1;
    }
    TravelDao.fetch(widget.travelUrl ?? _TRAVEL_URL,widget.groupChannelCode, pageIndex, PAGE_SIZE).then((TravelModel model) {
      //判断，当前页面是否存在于构件树中，存在赋值，不存在结束操作。
      if (!mounted) {
        return;
      }
      _isLoading = false;
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        if(travelItems != null) {
          travelItems.addAll(items);
        }else {
          travelItems = items;
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  //清洗数据 移除article为空的模型
  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if(resultList == null)
      return [];
    List<TravelItem> filterItem = [];
    resultList.forEach((item) {
      if(item.article != null) {
        filterItem.add(item);
      }
    });
    return filterItem;
  }

  @override
  bool get wantKeepAlive => true;

  Future<Null> _handleRefresh() async{
    _loadData();
    return null;
  }
}

//瀑布流的每一个小卡片
class _TravelItem extends StatelessWidget {
  final TravelItem travelItem;
  final int index;
  const _TravelItem({Key key, this.travelItem, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(travelItem.article.urls != null && travelItem.article.urls.length > 0 ) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(
            url:  travelItem.article.urls[0].h5Url,
            title: '详情',
          )));
        }
      },
      child: Card(
        child: PhysicalModel(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(travelItem.article.articleTitle,maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 14,color: Colors.black87),),
              ),
              _infoText()
            ],
          ),
        ),
      ),
    );
  }

//  卡片中的大图片
  _itemImage() {
    return Stack(
      children: <Widget>[
        Image.network(travelItem.article.images[0]?.dynamicUrl),
        Positioned(
          left: 8,
          bottom: 8,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(Icons.location_on,color: Colors.white,size: 12,),
                ),
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  //处理图片中显示的未知信息为空的情况
  String _poiName() {
    var pois = travelItem.article.pois;
    return pois == null || pois.length == 0 ? '未知' : pois[0] ?. poiName ?? '未知';
  }

  //卡片中用户信息和点赞数的布局
  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6,0,6,10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(travelItem.article.author?.coverImage ?. dynamicUrl,width: 24,height: 24,),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(travelItem.article.author?.nickName, maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12),   ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(Icons.thumb_up,size: 14,color: Colors.grey,),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(travelItem.article.likeCount.toString(),style: TextStyle(fontSize: 10),),
              )
            ],
          )
        ],
      ),
    );
  }
}


