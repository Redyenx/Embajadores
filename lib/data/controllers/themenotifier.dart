import 'package:embajadores/ui/config/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.red,
    accentColor: Colors.redAccent,
    scaffoldBackgroundColor: const Color(0xfff1f1f1));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.cyan,
  accentColor: Colors.deepPurpleAccent,
);

class ThemeNotifier with ChangeNotifier {
  final String key = "theme";
  SharedPreferences? _pref;
  bool? _darkTheme;

  bool get darkTheme => _darkTheme!;

  ThemeNotifier() {
    _darkTheme = true;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme!;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref!.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _pref!.setBool(key, _darkTheme!);
  }
}

class CounterProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  int _opened = 0;
  int get opened => _opened;
  int _closed = 0;
  int get closed => _closed;
  void onChange(value) {
    _counter = value;
    notifyListeners();
  }

  void onOpenedChange(value) {
    _opened = value;
    notifyListeners();
  }

  void onClosedChange(value) {
    _closed = value;
    notifyListeners();
  }
}
