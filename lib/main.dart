import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kj/DrawerMain.dart';
import 'package:kj/Login.dart';
import 'package:kj/Register.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'font_preference_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (context) => FontPreferenceProvider(),
      child: Builder(
        builder: (context) {
          // Access the provider here
          final fontPreferenceProvider = Provider.of<FontPreferenceProvider>(context, listen: false);
          // Load the font preference
          fontPreferenceProvider.loadFontPreference();
          // Return the MaterialApp with the theme based on the provider's state
          return MaterialApp(
            theme: ThemeData(
              fontFamily: fontPreferenceProvider.isDyslexiaFont ? 'Dys' : 'Belanosima',
            ),
            debugShowCheckedModeBanner: false,
            home: Splash(),
          );
        },
      ),
    ),
  );
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  Future<void> checkLoggedIn() async {
    // Add a delay of 3 seconds before navigating to the home screen
    await Future.delayed(Duration(seconds: 3));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isLoggedIn ? DrawerMain() : Login(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/random.json',
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}


