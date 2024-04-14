import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kj/SubjectCard.dart';
import 'package:kj/promo_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'YoutubeCard.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {

  bool isSearching = false;
  TextEditingController _searchController = TextEditingController();

  String? Name;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('username') ?? '';

    setState(() {
      Name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 100, right: 20, top: 35, bottom: 10),
              child: Row(
                children: [
                  SizedBox(
                    height: 120,
                  ),
                  Expanded(
                    child: Text(
                      'Hi, ${Name?.isNotEmpty == true ? Name! : " :)"}',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 60), // Add margin between text and icon
                  IconButton(
                    icon: Icon(Icons.notifications, size: 30),
                    onPressed: () {
                      // Handle notification icon press
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2), // Adjust opacity here
                  borderRadius:
                  BorderRadius.circular(20.0), // Make border circular
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white70),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: TextField(
                        cursorColor: Colors.white70,
                        controller: _searchController,
                        onSubmitted: (value) {
                          setState(() {
                            isSearching = true;
                          });
                        },
                        onChanged: (value1) {
                          if (value1.isEmpty) {
                            setState(() {
                              isSearching = false;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Find Subjects",
                          hintStyle: TextStyle(
                              color: Colors.white70, fontFamily: "crete"),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontFamily: "crete"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding:
              const EdgeInsets.only(left: 20, right: 1, top: 5, bottom: 2),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(
                      'Our top plans',
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 170,
                    ),
                    Text('see all',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        )),
                  ],
                ),
              ),
            ),
            PromoCard(),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Recommended for you',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  YouTubeVideoCard(
                    videoUrl: 'https://youtu.be/tnb8XcGbYCM?si=ucI09lYFMVlYJ2rl', // Replace with your video URL
                  ),
                  YouTubeVideoCard(
                    videoUrl: 'https://youtu.be/tnb8XcGbYCM?si=ucI09lYFMVlYJ2rl', // Replace with your video URL
                  ),
                  YouTubeVideoCard(
                    videoUrl: 'https://youtu.be/tnb8XcGbYCM?si=ucI09lYFMVlYJ2rl', // Replace with your video URL
                  ),
                  YouTubeVideoCard(
                    videoUrl: 'https://youtu.be/tnb8XcGbYCM?si=ucI09lYFMVlYJ2rl', // Replace with your video URL
                  ),
                  YouTubeVideoCard(
                    videoUrl: 'https://youtu.be/tnb8XcGbYCM?si=ucI09lYFMVlYJ2rl', // Replace with your video URL
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Subjects',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(height: 20),
            SingleChildScrollView(
              child: Column(
                children: [
                  SubjectCard(),
                  SubjectCard(),
                  SubjectCard(),
                  SubjectCard(),
                  SubjectCard(),
                ],
              ),
            ),
            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }
}
