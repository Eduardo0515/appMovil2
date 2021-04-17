import 'package:appflutterc3movil/src/models/Login.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
final Login data;
Home({this.data});
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("*PROFILE*"),
      ),
      body: Container(
        padding: EdgeInsets.all(12.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              height: 54.0,
              padding: EdgeInsets.all(12.0),
              child: Text('Datos pasados a esta interfaz: ',
               style: TextStyle(fontWeight: FontWeight.w700))),
            Text('Token user: ${data.token}'),
          ],
        ),
      ),
    );
  }
}