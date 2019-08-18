import 'package:flutter/material.dart';
//加载进度条组件
class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading; //判断显示进度条还是具体的内容
  final bool cover; //是否要覆盖布局 (child)
  const LoadingContainer({Key key, @required this.isLoading, this.cover = false, @required this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  !cover ? !isLoading ? child: _loadingView : Stack(
      children: <Widget>[
        child,
        isLoading ? _loadingView : null
      ],
    );
  }

  Widget get  _loadingView {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
