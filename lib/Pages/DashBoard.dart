import 'package:ahia_vendor/Pages/HomeScreen.dart';
import 'package:ahia_vendor/Widgets/DrawerMenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class MainDashBoard extends StatefulWidget {
  @override
  _MainDashBoardState createState() => _MainDashBoardState();
}

class _MainDashBoardState extends State<MainDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('DashBoard'),
    ));
  }
}
