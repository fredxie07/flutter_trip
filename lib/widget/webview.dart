import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

//webview黑名单 这些地址不能跳转 如果跳转到这些地址  直接返回app
const CATCH_URLS = ['m.ctrip.com/','m.ctrip.com/html5','m.ctrip.com/html5/','m.ctrip.com/webapp/activity/overseasindex?from=https%3A%2F%2Fm.ctrip.com%2Fhtml5%2F'];
class WebView extends StatefulWidget {
  final String url; //webview的地址
  final String statusBarColor; //appBar的颜色
  final String title; //appBar的title
  final bool hideAppBar; //是否隐藏appBar
  final bool backForbid; //是否禁止返回app

  const WebView({Key key, this.url, this.statusBarColor, this.title, this.hideAppBar, this.backForbid = false}) : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final webviewReference = new FlutterWebviewPlugin();
  StreamSubscription<String> _onUrlChange;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false; //是否从webview返回过app
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //监听页面url变化  返回值为stream
    _onUrlChange = webviewReference.onUrlChanged.listen((String url) {

    });
    //H5页面发生变化时的监听 （用户切换页面时）返回stream
    _onStateChanged = webviewReference.onStateChanged.listen((WebViewStateChanged state) {
      switch(state.type) {
        case WebViewState.startLoad:
          print('state.urlstate.urlstate.urlstate.url${state.url}');
          //如果当前的url包含在定义的CATCH_URLS里面  并且不能让程序跳转到这个url里面
          if(_isToMain(state.url) && !exiting) {
            //如果禁止返回 就还加载当前h5页面
            if(widget.backForbid) {
              webviewReference.goBack();
            }else {
              Navigator.pop(context);
              exiting = true;
            }
          }
          break;
        default:
          break;
      }
    });
    //打开webview发生网络错误
    _onHttpError = webviewReference.onHttpError.listen((WebViewHttpError error) {
        print(error.toString());
    });
    //防止页面重复打开
    webviewReference.close();
  }

  _isToMain(String url) {
    bool contain = false;
    for(final  value in CATCH_URLS) {
      if(url ?. endsWith(value) ?? false) {
        contain = true;
        break;
      }
    }
    return contain;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    //取消监听
    _onUrlChange.cancel();
    _onStateChanged.cancel();
    _onHttpError.cancel();
    webviewReference.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.black;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar(Color(int.parse('0xff'+statusBarColorStr)),backButtonColor),
//          webview展示的内容
          Expanded(
            child: WebviewScaffold(
                url: widget.url,
                withZoom: true,
                withLocalStorage: true,
                hidden: true,
                initialChild: Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ),
          )
        ],
      ),
    );
  }

  //打开webview的appBar的显示方式
  _appBar(Color backGroundColor, Color backButtonColor) {
    //第一种显示
    if(widget.hideAppBar ?? false) {
      return Container(
        color: backGroundColor,
        height: 30,
      );
    }
    //第二种方式显示
    return Container(
      color: backButtonColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            GestureDetector(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close,color: widget.statusBarColor == '4289ff' ?  Colors.black :  backButtonColor,size: 26,),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(widget.title ?? '',style: TextStyle(color: backButtonColor,fontSize: 20),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
