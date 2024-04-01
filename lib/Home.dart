import 'package:kj/services/constants.dart';

import 'ChatBot.dart';
import 'Profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:kj/Screen1.dart';
import 'package:kj/Screen3.dart';
import 'Maps.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    Screen1(),
    Maps(),
    Screen3(),
    ChatBot(),
    Profile()
  ];

  void _onTabChange(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            color: main1,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            )
        ),
        padding: EdgeInsets.symmetric(horizontal: 10),
        height: 75,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0,bottom: 8),
          child: GNav(
            gap: 5,
            backgroundColor: main1,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: main3.withOpacity(0.3),
            curve: Curves.easeOutExpo,
            duration: Duration(milliseconds: 500),
            padding: EdgeInsets.all(16),
            onTabChange: _onTabChange,
            tabs: [
              GButton(
                icon: CupertinoIcons.mail_solid,
                text: "Jobs",
              ),
              GButton(
                icon: CupertinoIcons.map_fill,
                text: "Maps",
              ),
              GButton(
                icon: CupertinoIcons.link,
                text: "Connect",
              ),
              GButton(
                icon: CupertinoIcons.chat_bubble_2_fill,
                text: "ChatBot",
              ),
              GButton(
                icon: CupertinoIcons.profile_circled,
                text: "Profile",
              ),
            ],
            selectedIndex: _currentIndex,
          ),
        ),
      ),
      body: Stack(
        children: [
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          Positioned(
            top: 65,
            left: 20,
            child: FloatingActionButton(
              heroTag: "btn3",
              onPressed: () {
                ZoomDrawer.of(context)!.toggle();
              },
              child: Icon(Icons.menu, color: main1),
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
