import 'package:flutter/material.dart';
import 'Pages/serie_list_design.dart';
import 'package:get/get.dart';

void main() => runApp(SeriesApp());

class SeriesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primaryColor: Colors.red,
        accentColor: Colors.blue,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}
