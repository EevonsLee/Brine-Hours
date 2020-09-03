import 'package:flutter/material.dart';
import 'package:tenement_net/models/home.dart';
import 'package:tenement_net/widgets/ImageWidget.dart';
import "../widgets/BottomNavWidget.dart";
import 'package:city_pickers/city_pickers.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../common/store.dart' as BaseStore;
import '../models/home.dart';
import '../service/request.dart';
import '../common/loading.dart';
import '../widgets/ImageWidget.dart';

class City {
  City(this.cityId, this.cityName);
  final String cityId;
  final String cityName;
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title});
  final String title;
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  City city;
  Home Data = null; //数据变量

  void _getData(context) async {
    // 结合service做数据请求
    Home _data = await Request(context).getHome();
    print(_data);
    setState(() {
      Data = _data;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 初次数据的请求
    if (Data == null) {
      _getData((context));
    }
    // store初始化配置
    return new StoreProvider(
        store: BaseStore.AppStore,
        child: Scaffold(
          // 首页标题书写
          appBar: AppBar(
            title: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: double.infinity,
                minHeight: 50.0,
              ),
              child: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned(
                        left: 5,
                        child: new StoreConnector(builder: (context, calback) {
                          return GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(city != null ? city.cityName : "深圳市",
                                      style: TextStyle(fontSize: 16.0)),
                                  Icon(Icons.arrow_drop_down)
                                ],
                              ),
                              onTap: () async {
                                Result result =
                                    await CityPickers.showCityPicker(
                                  context: context,
                                  showType: ShowType.pc,
                                  cancelWidget: new Text(
                                    '取消',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                  confirmWidget: new Text(
                                    '确定',
                                    style: new TextStyle(color: Colors.black),
                                  ),
                                  height: 260,
                                ); //城市选择控件实例化
                                if (result != null) {
                                  setState(() {
                                    city = new City(
                                        result.cityId, result.cityName);
                                    calback();
                                  });
                                }
                              });
                        }, converter: (store) {
                          return () => store.dispatch(
                              BaseStore.LocationAction(payload: city.cityName));
                        })),
                    Container(
                      child: Center(
                        child: Transform.translate(
                          offset: Offset(25, 0),
                          child: Text(widget.title),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.pushNamed(context, "projectList");
                },
              )
            ],
          ),
          bottomNavigationBar: BottomNavWidget(
            select: 0,
          ),
          body: Data != null
              ? SingleChildScrollView(
                  child: Container(
                    color: Colors.grey[200],
                    // 整体的垂直布局
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        // banner模块
                        DecoratedBox(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: Data.banner != null
                                    ? NetworkImage(Data.banner)
                                    : AssetImage("assets/images/01.png"),
                                fit: BoxFit.cover),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 180.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                // 模拟模态框
                                Container(
                                  margin: EdgeInsets.only(top: 20),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(180, 255, 255, 255),
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "projectList");
                                      },
                                      child: Container(
                                        width: 300,
                                        height: 25,
                                        padding: EdgeInsets.only(left: 10),
                                        alignment: Alignment.centerLeft,
                                        child: Icon(Icons.search, size: 16),
                                      ),
                                    ),
                                  ),
                                ),
                                // 中间描述文字
                                Container(
                                  margin: EdgeInsets.only(top: 25),
                                  child: Center(
                                    child: Text(
                                      "品牌公寓直租房源",
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // 分类模块
                        Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            alignment: Alignment.center,
                            child: Wrap(
                              spacing: 40.0, //主轴方向的边距
                              runSpacing: 4.0, //纵轴方向间距
                              alignment: WrapAlignment.start,
                              children: Data.icons.map((i) {
                                return GestureDetector(
                                  child: Column(
                                    children: <Widget>[
                                      ClipOval(
                                        child: ImageWidget(
                                            url: i['icon'],
                                            w: 60.0,
                                            h: 60.0,
                                            fit: BoxFit.fill),
                                      ),
                                      Text(i['text'])
                                    ],
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(context, "projectList",
                                        arguments: {i['search']: true});
                                  },
                                );
                              }).toList(),
                            )),
                        // 地区模块
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 9.0),
                          color: Colors.white,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: Data.region.map((i) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, "projectList", arguments: {
                                          'cur_region': i['text']
                                        });
                                      },
                                      child: Container(
                                        width: 86,
                                        height: 76,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: <Widget>[
                                            ImageWidget(
                                                url: i['icon'],
                                                w: 86,
                                                h: 76,
                                                fit: BoxFit.fill),
                                            Center(
                                              child: Text(
                                                i['text'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ));
                                }).toList(),
                              )),
                        ),
                        // 猜你喜欢
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 9.0),
                          color: Colors.white,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("猜你喜欢"),
                                      GestureDetector(
                                          child: Text("查看更多"),
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              "projectList",
                                            );
                                          })
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: Data.apart.map((i) {
                                    return GestureDetector(
                                        onTap: () {},
                                        child: Container(
                                          width: 260,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(children: [
                                            ImageWidget(
                                                url: i['ppt_file_url'],
                                                w: 260,
                                                h: 150,
                                                fit: BoxFit.fill),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Row(
                                                children: <Widget>[
                                                  Text(i['detail']['title'])
                                                ],
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                Text(i['detail']['type'],
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontSize: 12.0)),
                                                Text(i['detail']['price'],
                                                    style: TextStyle(
                                                        color:
                                                            Colors.orange[900],
                                                        fontSize: 10.0))
                                              ],
                                            )
                                          ]),
                                        ));
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                        // 品牌公寓
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 9.0),
                          color: Colors.white,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
                                child: DefaultTextStyle(
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("品牌公寓"),
                                      GestureDetector(
                                          child: Text("查看更多"),
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, "projectList");
                                          })
                                    ],
                                  ),
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: Data.flats.map((i) {
                                    return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "projectList",
                                              arguments: {'search': i['text']});
                                        },
                                        child: Container(
                                          width: 70,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 3.0),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey[200],
                                                width: 1.0,
                                                style: BorderStyle.solid),
                                          ),
                                          child: Column(children: [
                                            Container(
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.grey[200],
                                                    width: 1.0,
                                                    style: BorderStyle.solid,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              30.0))),
                                              width: 60.0,
                                              height: 60.0,
                                              child: ClipOval(
                                                child: Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child: ImageWidget(
                                                    url: i['icon'],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5.0),
                                              child: Text(i['text']),
                                            )
                                          ]),
                                        ));
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : Loading(
                  color: Colors.white,
                  opacity: 0.9,
                ),
        ));
  }
}
