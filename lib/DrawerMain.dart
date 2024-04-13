import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kj/services/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Home.dart';
import 'Menu.dart';


class DrawerMain extends StatefulWidget {

  @override
  State<DrawerMain> createState() => _DrawerMainState();
}

class _DrawerMainState extends State<DrawerMain> {

  Future<void> printSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? username = prefs.getString('username');
    String? email = prefs.getString('email');
    String? firstName = prefs.getString('first_name');
    String? lastName = prefs.getString('last_name');
    String? standard = prefs.getString('standard');

    print('Username: $username');
    print('Email: $email');
    print('First Name: $firstName');
    print('Last Name: $lastName');
    print('Standard: $standard');
  }

  @override
  void initState() {
    super.initState();
    printSharedPreferences();
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
