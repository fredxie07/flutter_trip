import 'package:flutter/material.dart';
import 'package:flutter_trips/pages/home_page.dart';
import 'package:flutter_trips/pages/my_page.dart';
import 'package:flutter_trips/pages/search_page.dart';
import 'package:flutter_trips/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  //pageView的controller  initialPage定义页面初始化时默认显示第几个页面
  final  PageController _controller = PageController(
    initialPage: 0
  );
  //底部导航图标的默认颜色
  final _defaultColor = Colors.grey;
//  底部导航图标的激活状态的颜色
  final _activeColor = Colors.blue;

  num _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        onPageChanged: (index) {
          print(index);
          setState(() {
            _currentIndex = index;
          });
        },
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true,),
          TravelPage(),
        MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          //pageView跳转到指定的页面
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color: _defaultColor),
            activeIcon: Icon(Icons.home,color: _activeColor,),
            title: Text('首页',style: TextStyle(color: _currentIndex != 0 ? _defaultColor : _activeColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,color: _defaultColor),
              activeIcon: Icon(Icons.search,color: _activeColor,),
              title: Text('搜索',style: TextStyle(color: _currentIndex != 1 ? _defaultColor : _activeColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.camera,color: _defaultColor),
              activeIcon: Icon(Icons.camera,color: _activeColor,),
              title: Text('旅拍',style: TextStyle(color: _currentIndex != 2 ? _defaultColor : _activeColor),)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,color: _defaultColor),
              activeIcon: Icon(Icons.account_circle,color: _activeColor,),
              title: Text('我的',style: TextStyle(color: _currentIndex != 3 ? _defaultColor : _activeColor),)
          ),
        ],
      ),
    );
  }
}

