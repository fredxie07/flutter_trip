import 'package:flutter/material.dart';
import 'package:flutter_trips/dao/search_dao.dart';
import 'package:flutter_trips/model/search_model.dart';
import 'package:flutter_trips/widget/search_bar.dart';
import 'package:flutter_trips/widget/webview.dart';

const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
//服务端返回的每一条记录都包含一个type字段 将所有的type保存  判断显示不同的左侧图片
const TYPES = [
    'channelgroup',
    'gs',
    'plane',
    'train',
    'cruise',
    'district',
    'food',
    'hotel',
    'huodong',
    'shop',
    'sight',
    'ticket',
    'travelgroup'
];
class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;
  const SearchPage({Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyword;
  SearchModel searchModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: <Widget>[
            _appBar(),
            MediaQuery.removePadding(
              removeTop: true,
                context: context,
                child: Expanded(
                  flex: 1,
                  child:     ListView.builder(
                    itemCount: searchModel?.data?.length ?? 0,
                    itemBuilder: (context, int position) {
                      return _item(position);
                    },
                  ),
                )
            )
          ],
        )
    );
  }



  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter
              )
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(
                color: Colors.white
            ),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChange: _onTextChanged,
            ),
          ),
        )
      ],
    );
  }

  _onTextChanged(text) {
    setState(() {
      keyword = text;
    });
    if(text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return false;
    }
    String url = widget.searchUrl+text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      //只有输入的内容和服务端返回的keyword返回的内容一致才会渲染
      if(model.keyword == keyword) {
        setState(() {
          print(model);
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

//  符合搜索条件的所有记录
  _item(int postion) {
    if(searchModel == null || searchModel.data == null)
      return null;
    SearchItem item = searchModel.data[postion];
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(
          url: item.url,
          title: '详情',
        )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.3,color: Colors.grey)
          ),
        ),
        child: Row(
          children: <Widget>[
//            左边的图片
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
                //根据服务端返回的type动态显示图片
                image: AssetImage(_typeImage(item.type)) ,
              ),
            ),
            //右边上下布局的文字
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

//  根据服务端返回的符合条件的记录的type显示不同的icon
   String _typeImage(String type) {
    if(type == null)
      return 'images/type_travelgroup.png';
      String path = 'travelgroup';
      for (final val in TYPES) {
        if(type.contains(val)) {
          path = val;
          break;
        }
      }
      return 'images/type_${path.toString()}.png';
  }

//  上下排列的两行文字
  _title(SearchItem item) {
    print(item.zonename);
    if(item == null ) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word,searchModel.keyword));
    spans.add(TextSpan(text: '  '+ (item.districtname ?? '')+ '  '+ (item.zonename ?? ''),style: TextStyle(fontSize: 14,color: Colors.grey) ));

    return RichText(text: TextSpan(children: spans));
  }
  _subTitle(SearchItem item) {
    return Row(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(right: 5),
          child: Text(item.price ?? '',style: TextStyle(fontSize: 14,color: Colors.orange),),
        ),
        Text(item.star?? '',style: TextStyle(color: Colors.grey,fontSize: 12),)
      ],
    );
  }

   _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if(word == null || word.length == 0)
      return spans;
    List<String>arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(color: Colors.black87,fontSize: 16);
    TextStyle keywordStyle = TextStyle(color: Colors.orange,fontSize: 16);
    //拼接高亮字符串
    for(int i = 0; i < arr.length; i++) {
      if((i+1) % 2 == 0) {
        spans.add(TextSpan(text: keyword,style: keywordStyle));
      }
      String val = arr[i];
      if(val != null &&  val.length > 0) {
        spans.add(TextSpan(text: val,style: normalStyle));
      }
    }
    return spans;
  }
}
