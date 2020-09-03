import 'package:flutter/material.dart';

class StartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Colors.white),
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Image.asset('assets/images/01.png'),
            Text(
              '租房网',
              style: TextStyle(color: Colors.blue, fontSize: 24.0),
              textDirection: TextDirection.ltr,
            )
          ],
        ));
  }
}
