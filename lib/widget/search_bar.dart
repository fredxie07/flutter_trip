import 'package:flutter/material.dart';

enum SearchBarType {home, normal, homeLight}
class SearchBar extends StatefulWidget {
  final bool enabled; //是否禁用搜索框
  final bool hideLeft; //是否隐藏左侧返回按钮
  final SearchBarType searchBarType ; //分为首页与搜索页两个不同样式的搜索框
  final String hint;//内容为空时显示的默认提示文案
  final String defaultText; //页面初始化时显示的文案
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChange;

  const SearchBar({
    Key key,
    this.enabled = true,
    this.hideLeft,
    this.searchBarType = SearchBarType.normal,
    this.hint,
    this.defaultText,
    this.leftButtonClick,
    this.rightButtonClick,
    this.speakClick,
    this.inputBoxClick,
    this.onChange
  }) : super(key: key);
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false; //是否显示清除按钮
  final TextEditingController _controller = new TextEditingController();

  @override
  void initState() {
    if(widget.defaultText != null)
      setState(() {
        _controller.text = widget.defaultText;
      });
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return widget.searchBarType== SearchBarType.normal ?
        _genNormalSearch():
        _genHomeSearch();
  }

  //搜索页面搜索框
  _genNormalSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
              child: widget.hideLeft ?? false ? null : Icon(Icons.arrow_back_ios,color: Colors.grey,size: 26,),
            ),
              widget.leftButtonClick
          ),
          //中间的搜索框
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
//          右侧的搜索按钮
          _wrapTap(
            Container(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child:Text('搜索',style: TextStyle(color: Colors.blue,fontSize: 17),) ,
            ),
              widget.rightButtonClick
          )
        ],
      ),
    );
  }

  //首页搜索框
  _genHomeSearch() {
    return Container(
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    Text('北京',style: TextStyle(color: _homeFontColor(),fontSize: 14),),
                    Icon(Icons.expand_more,color: _homeFontColor(),size: 22,)
                  ],
                )
              ),
              widget.leftButtonClick
          ),
          //中间的搜索框
          Expanded(
            flex: 1,
            child: _inputBox(),
          ),
//          右侧的搜索按钮
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(Icons.comment,color: _homeFontColor(),size: 26,),
              ),
              widget.rightButtonClick
          )
        ],
      ),
    );
  }

  _inputBox() {
    Color inputBoxColor; //搜索框颜色
    if(widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    }else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
     return Container(
       height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
        color: inputBoxColor,
        borderRadius: BorderRadius.circular(widget.searchBarType == SearchBarType.normal ? 5 : 15)
      ),
      child: Row (
        children: <Widget>[
          Icon(Icons.search,size: 20,color:widget.searchBarType == SearchBarType.normal ? Color(0xffA9A9A9): Colors.blue),
          Expanded(
              flex: 1,
              child: widget.searchBarType == SearchBarType.normal ?
              TextField(
                controller: _controller,
                onChanged: _onchanged,
                autofocus: true,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontWeight: FontWeight.w300
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                  border: InputBorder.none,
                  hintText: widget.hint ?? '',
                  hintStyle: TextStyle(fontSize: 15)
                ),
              ) : _wrapTap(
                Container(
                  child: Text(widget.defaultText,style: TextStyle(fontSize: 13,color: Colors.grey),),
                ),
                widget.inputBoxClick
              )
          ),
          !showClear ? _wrapTap(
            Icon(Icons.mic,size: 22,color: widget.searchBarType == SearchBarType.normal ? Colors.blue : Colors.grey,),
            widget.speakClick
          ): _wrapTap(
            Icon(Icons.clear,size: 22,color: Colors.grey,),
              () {
              setState(() {
                _controller.clear();
              });
              _onchanged('');
              }
          )
        ],
      ),
    );
  }

  //输入框发生变化
  _onchanged(String text) {
    if(text.length > 0) {
      setState(() {
        showClear = true;
      });
    }else {
      setState(() {
        showClear = false;
      });
    }
    if(widget.onChange != null) {
      widget.onChange(text);
    }
  }
  _wrapTap(Widget child, void Function() callBack) {
    return GestureDetector(
      onTap: () {
        if(callBack != null) callBack();
      },
        child:child
    );
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight ? Colors.black54 : Colors.white;
  }
}
