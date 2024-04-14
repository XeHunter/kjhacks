import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:kj/Login.dart';
import 'package:kj/services/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'font_preference_provider.dart';
import 'main.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  String? Name;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    Provider.of<FontPreferenceProvider>(context, listen: false).loadFontPreference();
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
      backgroundColor: main1,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  ZoomDrawer.of(context)!.toggle();
                },
                child: const Icon(Icons.close,color: main1,), // Replace with your desired icon
                backgroundColor: Colors.white, // Change the background color as needed
              ),
            ),
            SizedBox(height: 30,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    Name?.isNotEmpty == true ? Name! : 'Welcome User',
                    style: TextStyle(fontFamily: "Belanosima", fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30,),
            ListTile(
              leading: Icon(
                Icons.home,color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Belanosima"
                ),
              ),
              onTap: (){
                ZoomDrawer.of(context)!.toggle();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,color: Colors.white,
              ),
              title: Text(
                "Account",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Belanosima"
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(
                Icons.star,color: Colors.white,
              ),
              title: Text(
                "Rating",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Belanosima"
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,color: Colors.white,
              ),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Belanosima"
                ),
              ),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(
                Icons.privacy_tip, color: Colors.white,
              ),
              title: Text(
                "Privacy Policy",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Belanosima"
                ),
              ),
              onTap: ()  {

              },
            ),
            SwitchListTile(
              activeColor: Colors.grey,
              activeTrackColor: Colors.white,
              title: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text('Use Dyslexia-Friendly Font',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                  fontFamily: Provider.of<FontPreferenceProvider>(context).isDyslexiaFont ? 'Dys' : 'Belanosima',
                ),),
              ),
              value: Provider.of<FontPreferenceProvider>(context).isDyslexiaFont,
              onChanged: (bool value) {
                Provider.of<FontPreferenceProvider>(context, listen: false).saveFontPreference(value);
              },
            ),

            SizedBox(height: 100,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0),
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text(
                        "Confirm Logout",
                        style: TextStyle(
                            fontFamily: "Belanosima"
                        ),
                      ),
                      content: const Text("Are you sure you want to log out?",
                        style: TextStyle(
                            fontFamily: "Belanosima"
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: const Text("Cancel",
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Belanosima"
                            ),),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: main1,
                          ),
                          onPressed: () async {

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                            await FirebaseAuth.instance.signOut();

                            Navigator.of(context).pop();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(fontFamily: "Belanosima",color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  minimumSize: const Size(50.0, 50.0),  // Set the width and height to the same value
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38.0),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      color: main1,
                      fontFamily: "Belanosima",
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
