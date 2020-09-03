import 'package:flutter/material.dart';

import './HomePage.dart';
import './CollectListPage.dart';
import './OrderListPage.dart';
import './PersonalCenter.dart';
import './ProjectList.dart';
import './ProjectDetail.dart';
import './LoginPage.dart';
import './RegisterPage.dart';
import './PersonalInformation.dart';
import './PersonalInformationChange.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "租房网",
      theme: ThemeData(
        // 主要色调
        primaryColor: Colors.white,
      ),
      // 路由表
      routes: {
        "loginPage": (context) => LoginPage(),
        "registerPage": (context) => RegisterPage(),
        'personalInformation': (context) => PersonalInformation(
              title: '个人信息',
            ),
        "personalInformationChange": (context) => PersonalInformationChange(
              title: "个人信息修改",
              arg: ModalRoute.of(context).settings.arguments,
            ),
        "projectList": (context) => ProjectList(
              title: "房源列表页",
              arg: ModalRoute.of(context).settings.arguments,
            ),
        "projectDetail": (context) => ProjectDetail(title: "房源详情页"),
        "personalCenter": (context) => PersonalCenter(title: "我的"),
        "orderListPage": (context) => OrderListPage(title: "预约"),
        "collectListPage": (context) => CollectListPage(title: "收藏"),
        "/": (context) => HomePage(title: "首页")
      },
      initialRoute: "/",
    );
  }
}
