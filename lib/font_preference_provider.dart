import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontPreferenceProvider with ChangeNotifier {
  bool _isDyslexiaFont = false;

  bool get isDyslexiaFont => _isDyslexiaFont;

  Future<void> loadFontPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDyslexiaFont = prefs.getBool('isDyslexiaFont') ?? false;
    notifyListeners();
  }

  Future<void> saveFontPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDyslexiaFont = value;
    await prefs.setBool('isDyslexiaFont', value);
    notifyListeners();
  }
}
