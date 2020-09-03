import 'package:flutter/material.dart';
import "../widgets/BottomNavWidget.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:redux/redux.dart';
import '../common/store.dart' as BaseStore;

import '../widgets/ImageWidget.dart';
import '../service/request.dart';

class CollectListPage extends StatefulWidget {
  CollectListPage({Key key, this.title});
  final String title;
  final Store store = BaseStore.AppStore;
  @override
  CollectListPageState createState() {
    return CollectListPageState();
  }
}

class CollectListPageState extends State<CollectListPage> {
  List _renderList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInitData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavWidget(
        select: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: _renderList.map((e) {
            return GestureDetector(
              onTap: () {
                widget.store
                    .dispatch(BaseStore.ProjectDetailAction(payload: e));
                Navigator.pushNamed(context, 'projectDetail');
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    ImageWidget(url: e['ppt_file_url'], w: 150, h: 120),
                    Container(width: 10),
                    Expanded(
                      child: Wrap(
                        children: <Widget>[
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                e['ppt_name'].length <= 10
                                    ? e['ppt_name']
                                    : e['ppt_name'].substring(0, 10) + "...",
                                style: TextStyle(fontSize: 18),
                              ),
                              Text(
                                e['region_name'] + e['ar_name'],
                                style: TextStyle(fontSize: 14, height: 2.0),
                              ),
                              Row(
                                children:
                                    e['detail']['label_group'].map<Widget>((i) {
                                  return Container(
                                      margin: EdgeInsets.only(right: 10),
                                      child: Text(i,
                                          style: TextStyle(
                                              fontSize: 14,
                                              background: new Paint()
                                                ..color = Colors.blue[50],
                                              height: 2.0)));
                                }).toList(),
                              ),
                              Flex(
                                mainAxisSize: MainAxisSize.max,
                                direction: Axis.horizontal,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    e['detail']['price'] + '/月',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.red[300],
                                        height: 2.0),
                                  )
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

// 请求数据
  void getInitData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');
    if (userId == null) {
      Navigator.pushReplacementNamed(context, 'loginPage');
    } else {
      var _data = await Request(context).getCollectionList(queryParameters: {
        'userId': userId,
      });
      setState(() {
        _renderList.addAll(_data.list);
      });
    }
  }
}
