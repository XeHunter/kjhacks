import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kj/services/constants.dart';
import 'Home.dart';
import 'Menu.dart';


class DrawerMain extends StatefulWidget {

  @override
  State<DrawerMain> createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: Menu(),
      mainScreen: Home(),
      borderRadius: 24,
      angle: 0,
      showShadow: true,
      mainScreenScale: 0.1,
      menuBackgroundColor: main1,
    );
  }
}
