import 'package:flutter/material.dart';

class BottomNavWidget extends StatefulWidget {
  BottomNavWidget({Key key, this.select = 0});
  final int select;
  @override
  BottomNavWidgetState createState() {
    return BottomNavWidgetState();
  }
}

class BottomNavWidgetState extends State<BottomNavWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        // 选中的颜色
        selectedItemColor: Colors.blue,
        // 未选中颜色
        unselectedItemColor: Color(0xff666666),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), title: Text('预约')),
          BottomNavigationBarItem(icon: Icon(Icons.school), title: Text('收藏')),
          BottomNavigationBarItem(icon: Icon(Icons.people), title: Text('我的')),
        ],
        // 索引
        currentIndex: widget.select,
        // 按钮的布局
        type: BottomNavigationBarType.fixed,
        // 事件
        onTap: (int index) {
          switch (index) {
            case 0:
              {
                Navigator.pushNamedAndRemoveUntil(
                    context, "/", (route) => false);
              }
              break;
            case 1:
              {
                Navigator.pushNamedAndRemoveUntil(
                    context, "orderListPage", (route) => false);
              }
              break;
            case 2:
              {
                Navigator.pushNamedAndRemoveUntil(
                    context, "collectListPage", (route) => false);
              }
              break;
            case 3:
              {
                Navigator.pushNamedAndRemoveUntil(
                    context, "personalCenter", (route) => false);
              }
              break;
          }
        });
  }
}
