import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/request.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _RegisterPage();
  }
}

class _RegisterPage extends State<RegisterPage> {
  GlobalKey _formkey = new GlobalKey<FormState>();
  TextEditingController _pwdController = new TextEditingController();
  String _uname;
  String _password;
  FocusNode blankNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(blankNode);
            },
            child: Form(
              key: _formkey,
              autovalidate: true, //开启自动校验
              child: Column(children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '用户名',
                    hintText: '用户名或邮箱',
                    icon: Icon(
                      Icons.person,
                      color: Colors.blue[400],
                    ),
                  ),
                  // 用户名校验
                  validator: (v) {
                    return v.trim().length > 0 ? null : '用户名不能为空';
                  },
                  onSaved: (v) {
                    _uname = v;
                  },
                ),
                TextFormField(
                  controller: _pwdController,
                  decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '您的登录密码',
                    icon: Icon(
                      Icons.lock,
                      color: Colors.blue[400],
                    ),
                  ),
                  validator: (v) {
                    return v.trim().length > 5 ? null : '密码不能少于6位';
                  },
                  obscureText: true,
                  onSaved: (v) {
                    _password = v;
                  },
                ),
                // 确认密码
                TextFormField(
                  decoration: InputDecoration(
                    labelText: '确认密码',
                    hintText: '输入相同密码',
                    icon: Icon(
                      Icons.lock_outline,
                      color: Colors.blue[400],
                    ),
                  ),
                  validator: (v) {
                    return v.trim() == _pwdController.text.trim()
                        ? null
                        : '两次输入密码不一致';
                  },
                  obscureText: true,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),

                Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Builder(builder: (context) {
                            return RaisedButton(
                              onPressed: () {
                                _register(context);
                              },
                              child: Text('注册'),
                              color: Colors.blue[400],
                              textColor: Colors.white,
                              padding: EdgeInsets.all(15.0),
                            );
                          }),
                        ),
                      ],
                    ))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  _register(context) async {
    if (Form.of(context).validate()) {
      FocusScope.of(context).requestFocus(blankNode);
      Form.of(context).save();
      var _data = await Request(context).sendRegister(queryParameters: {
        'username': _uname,
        'userpwd': _password,
      });
      // 注册失败
      if (_data.msg == '用户名已存在') {
        Toast.show('用户名已存在', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
      } else {
        Toast.show('注册成功', context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        Navigator.of(context).pop();
      }
    }
  }
}
