import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tenement_net/widgets/ImageWidget.dart';
import '../common/store.dart' as BaseStore;
import '../service/request.dart';
import '../models/project_list.dart';
import '../widgets/ProjectFilter.dart';

class ProjectList extends StatefulWidget {
  ProjectList({Key key, this.title, this.arg});
  final String title;
  final Map arg;
  final Store store = BaseStore.AppStore;
  @override
  State<StatefulWidget> createState() {
    return _ProjectList();
  }
}

class _ProjectList extends State<ProjectList> {
  //接口数据
  Project_list Data = new Project_list();
  List _renderList = []; //渲染数据
  int count = 100; //默认总条数
  int pageNum = 0; //页码
  bool firstRequest = true; //是否是初次请求
  FocusNode focusNode1 = new FocusNode(); //焦点控制变量
  // 请求参数

  Map sendParams = {
    'cur_region': '全部',
    'cur_area': '全部',
    'price': '',
    'room': '不限',
    'special': [],
  };
// 搜索输入框的controller
  final TextEditingController _controller = new TextEditingController();

  // 修改请求参数

  void changeSendParams({Map params}) {
    setState(() {
      sendParams[params['type']] = params['val'];
    });
  }

  //请求数据函数
  dynamic _retrieveData(context, {Map params = null}) async {
    // 只有深圳才有数据
    if (!widget.store?.state.location.contains('深圳')) {
      setState(() {
        _renderList = [];
        return null;
      });
    }

    var _projectList = await Request(context).getProjectList(queryParameters: {
      'location': widget.store?.state.location,
      'pageRow': 20, //每页条数
      'pageNum': ++pageNum,
      'search': _controller.text, //输入框字段（搜索字段）
      'params': params != null ? params : sendParams, //请求筛选参数
      'classes': widget.arg //分类数据请求
    });

    setState(() {
      Data = _projectList;
      count = Data.total['count'];
      _renderList.addAll(Data.list);
    });
  }

  //默认弹出框控制字段（tab高亮字段）
  int modelState = 0;

  // 筛选数据函数
  void retrieveDataFilter(context) {
    setState(() {
      _renderList = [];
      pageNum = 0;
      _retrieveData(context);
      modelState = 0;
    });
  }

  // 筛选弹框控制函数
  void changeFilter(i) {
    setState(() {
      modelState = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    // 数据的初次请求
    if (firstRequest) {
      _retrieveData(context);
      setState(() {
        firstRequest = false;
      });
    }
    return new StoreProvider(
      store: widget.store,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            centerTitle: true,
          ),
          body: Stack(
            children: <Widget>[
              Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 360,
                      height: 30,
                      margin: EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.fromLTRB(10, 3, 0, 0),
                            child: Icon(Icons.search, size: 16),
                          ),
                          Expanded(
                            child: TextField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.center,
                              controller: _controller,
                              focusNode: focusNode1,
                              style: TextStyle(fontSize: 14.0),
                              onEditingComplete: () {
                                setState(() {
                                  _renderList = [];
                                  pageNum = 0;
                                  _retrieveData(context);
                                  focusNode1.unfocus();
                                });
                              },
                              // 默认提示
                              decoration: new InputDecoration(
                                border: InputBorder.none,
                                hintText: '请输入公寓名称',
                                contentPadding:
                                    EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 14.0),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey[200], width: 2),
                        bottom: BorderSide(color: Colors.grey[200], width: 2),
                      ),
                    ),
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '区域',
                                      style: TextStyle(
                                          color: modelState == 1
                                              ? Colors.blue[300]
                                              : null),
                                    ),
                                    Icon(
                                        modelState == 1
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: modelState == 1
                                            ? Colors.blue[300]
                                            : null)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    if (modelState == 1) {
                                      modelState = 0;
                                    } else {
                                      modelState = 1;
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 10,
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '租金',
                                      style: TextStyle(
                                          color: modelState == 2
                                              ? Colors.blue[300]
                                              : null),
                                    ),
                                    Icon(
                                        modelState == 2
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: modelState == 2
                                            ? Colors.blue[300]
                                            : null)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    if (modelState == 2) {
                                      modelState = 0;
                                    } else {
                                      modelState = 2;
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 10,
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '户型',
                                      style: TextStyle(
                                          color: modelState == 3
                                              ? Colors.blue[300]
                                              : null),
                                    ),
                                    Icon(
                                        modelState == 3
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: modelState == 3
                                            ? Colors.blue[300]
                                            : null)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    if (modelState == 3) {
                                      modelState = 0;
                                    } else {
                                      modelState = 3;
                                    }
                                  });
                                },
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 10,
                              decoration:
                                  BoxDecoration(color: Colors.grey[300]),
                            ),
                            Expanded(
                              flex: 1,
                              child: GestureDetector(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '更多',
                                      style: TextStyle(
                                          color: modelState == 4
                                              ? Colors.blue[300]
                                              : null),
                                    ),
                                    Icon(
                                        modelState == 4
                                            ? Icons.arrow_drop_up
                                            : Icons.arrow_drop_down,
                                        color: modelState == 4
                                            ? Colors.blue[300]
                                            : null)
                                  ],
                                ),
                                onTap: () {
                                  setState(() {
                                    if (modelState == 4) {
                                      modelState = 0;
                                    } else {
                                      modelState = 4;
                                    }
                                  });
                                },
                              ),
                            )
                          ],
                        )),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      itemCount: _renderList.length,
                      itemBuilder: (context, index) {
                        //如果到了表尾
                        if (index + 1 >= _renderList.length) {
                          // 不足总条数，继续获取数据
                          if (_renderList.length < count) {
                            // 获取数据
                            _retrieveData(context);
                            // loading
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 24.0,
                                height: 24.0,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2.0),
                              ),
                            );
                          } else {
                            // 已经加载完毕全部数据，不在获取数据
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              alignment: Alignment.center,
                              child: Text(
                                "没有更多了",
                                style: TextStyle(color: Colors.grey),
                              ),
                            );
                          }
                        }

                        // 显示列表项

                        return GestureDetector(
                          onTap: () {
                            widget.store.dispatch(BaseStore.ProjectDetailAction(
                                payload: _renderList[index]));
                            Navigator.pushNamed(context, "projectDetail");
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: <Widget>[
                                ImageWidget(
                                  url: _renderList[index]['ppt_file_url'],
                                  w: 150,
                                  h: 120,
                                ),
                                Container(width: 10),
                                Expanded(
                                  child: Wrap(children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // 名称
                                        Text(
                                          _renderList[index]['ppt_name']
                                                      .length <=
                                                  10
                                              ? _renderList[index]['ppt_name']
                                              : _renderList[index]['ppt_name']
                                                      .substring(0, 10) +
                                                  "...",
                                          style: TextStyle(fontSize: 18.0),
                                        ),
                                        // 地区
                                        Text(
                                          _renderList[index]['region_name'] +
                                              _renderList[index]['ar_name'],
                                          style: TextStyle(
                                              fontSize: 14, height: 2.0),
                                        ),
                                        // 特色
                                        Row(
                                          children: _renderList[index]['detail']
                                                  ['label_group']
                                              .map<Widget>((i) {
                                            return Container(
                                              margin:
                                                  EdgeInsets.only(right: 10),
                                              child: Text(
                                                i,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    background: new Paint()
                                                      ..color = Colors.blue[50],
                                                    height: 2.0),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                        // 房租
                                        Flex(
                                          mainAxisSize: MainAxisSize.max,
                                          direction: Axis.horizontal,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              _renderList[index]['detail']
                                                      ['price'] +
                                                  "/月",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.red[300],
                                                  height: 2.0),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: .0,
                      ),
                    ),
                  ),
                ],
              ),
              new StoreConnector(builder: (context, store) {
                return FilterModel(
                  locationAddr: store.state.location,
                  modelState: modelState,
                  changeFilter: changeFilter,
                  retrieveDataFilter: () => retrieveDataFilter(context),
                  sendParams: sendParams,
                  changeSendParams: changeSendParams,
                );
              }, converter: (store) {
                return store;
              })
            ],
          )),
    );
  }
}
