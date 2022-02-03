import 'package:ahia_vendor/Auth/Login_Screen.dart';
import 'package:ahia_vendor/Auth/Register_Screen.dart';
import 'package:ahia_vendor/Pages/DashBoard.dart';
import 'package:ahia_vendor/Services/Drawer_services.dart';
import 'package:ahia_vendor/Widgets/DrawerMenu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DrawerServices _drawerServices = DrawerServices();
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          appBarColor: Colors.white,
          appBarHeight: 80,
          key: _key,
          sliderMenuOpenSize: 200,
          title: Text(
            '',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
          trailing: Row(
            children: [
              IconButton(
                icon: Icon(CupertinoIcons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(CupertinoIcons.bell),
                onPressed: () {},
              )
            ],
          ),
          sliderMenu: MenuWidget(
            onItemClick: (title) {
              _key.currentState.closeDrawer();
              setState(() {
                this.title = title;
              });
            },
          ),
          sliderMain: _drawerServices.drawerScreen(title)),
    );
  }
}
