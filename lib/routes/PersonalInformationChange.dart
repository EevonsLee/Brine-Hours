import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tenement_net/routes/PersonalInformation.dart';
import 'package:toast/toast.dart';
import '../service/request.dart';

class PersonalInformationChange extends StatefulWidget {
  PersonalInformationChange({Key key, this.title, this.arg});
  final String title;
  final Map arg;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _PersonalInformationChange();
  }
}

class _PersonalInformationChange extends State<PersonalInformationChange> {
  FocusNode focusNode1 = new FocusNode();
  final TextEditingController _controller = new TextEditingController();

  // 名称
  String title = '';
  //字段
  String key = '';

  // 校验函数变量
  Function reg;
  // 默认值
  String placeHold = '';

  @override
  Widget build(BuildContext context) {
    render();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 30,
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              textDirection: TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(title),
                Container(width: 10),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.center,
                      controller: _controller,
                      focusNode: focusNode1,
                      style: TextStyle(fontSize: 14),
                      onEditingComplete: () {
                        setState(() {
                          focusNode1.unfocus();
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: placeHold,
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 14.0),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  focusNode1.unfocus();
                  Navigator.pop(context);
                },
                child: Text("取消"),
                color: Colors.grey[400],
                textColor: Colors.white,
              ),
              RaisedButton(
                onPressed: () {
                  focusNode1.unfocus();
                  sendData();
                },
                child: Text("确定"),
                color: Colors.blue[400],
                textColor: Colors.white,
              )
            ],
          )
        ],
      ),
    );
  }

  //配置函数
  void render() {
    title = widget.arg['name'];
    key = widget.arg['key'];
    _controller.text = widget.arg['val'];

    switch (widget.arg['key']) {
      case 'nickname':
        {
          placeHold = '请输入昵称';
          reg = (v) {
            if (v == "") {
              return "不能为空";
            }
            return '';
          };
        }
        break;
      case 'age':
        {
          placeHold = '请输入年龄';
          reg = (v) {
            if (RegExp(r'^\d{1,2}$').hasMatch(v)) {
              return "";
            }
            return '请输入两位数字';
          };
        }
        break;
      case 'sex':
        {
          placeHold = '请输入性别';
          reg = (v) {
            if (v == "男" || v == "女") {
              return "";
            }
            return '只能输入男或女';
          };
        }
        break;
      case 'phone':
        {
          placeHold = '请输入手机号';
          reg = (v) {
            if (RegExp(r'^1[3456789]\d{9}$').hasMatch(v)) {
              return "";
            }
            return '请输入正确手机号';
          };
        }
        break;
    }
  }

  //数据发送

  void sendData() async {
    String msg = reg(_controller.text);
    if (msg != "") {
      Toast.show(msg, context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('userId');
    if (userId == null) {
      Navigator.pushNamed(context, 'loginPage');
    } else {
      var _data = await Request(context).changeUser(queryParameters: {
        'userId': userId,
        key: _controller.text,
      });
      Navigator.pop(context);
    }
  }
}
