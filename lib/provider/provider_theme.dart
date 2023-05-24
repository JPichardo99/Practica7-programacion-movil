import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socialtec/constants.dart';

class ThemeNotifier extends ChangeNotifier {
  late ThemeData _themeData;
  late String _themeMode;

  ThemeNotifier() {
    _themeMode = "custom";
    _themeData = ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: thBackground,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: kPrimaryColor,
            shape: const StadiumBorder(),
            maximumSize: const Size(double.infinity, 56),
            minimumSize: const Size(double.infinity, 56),
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
          filled: true,
          fillColor: kPrimaryColor,
          iconColor: Colors.white,
          prefixIconColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
              horizontal: defaultPadding, vertical: defaultPadding),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            borderSide: BorderSide.none,
          ),
        ));
    loadThemeFromPrefs();
  }

  ThemeData getTheme() => _themeData;

  String getThemeMode() => _themeMode;

  void setTheme(String themeMode) async {
    _themeMode = themeMode;
    switch (_themeMode) {
      case "light":
        _themeData = ThemeData(
            brightness: Brightness.light,
            scaffoldBackgroundColor: Colors.white,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: thLightMode,
              iconColor: Colors.black,
              prefixIconColor: Colors.black,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: Colors.black),
              ),
            ));
        break;
      case "dark":
        _themeData = ThemeData(
            accentColor: Colors.red,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: thDarkMode,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              filled: true,
              fillColor: thDarkModeButtons,
              iconColor: Colors.white,
              prefixIconColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide(color: Colors.white),
              ),
            ));
        break;
      case "custom":
        _themeData = ThemeData(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: thBackground,
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: kPrimaryColor,
                shape: const StadiumBorder(),
                maximumSize: const Size(double.infinity, 56),
                minimumSize: const Size(double.infinity, 56),
              ),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.white),
              filled: true,
              fillColor: kPrimaryColor,
              iconColor: Colors.white,
              prefixIconColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(
                  horizontal: defaultPadding, vertical: defaultPadding),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                borderSide: BorderSide.none,
              ),
            ));
        break;
    }
    notifyListeners();
    saveThemeToPrefs();
  }

  Future<void> saveThemeToPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('themeMode', _themeMode);
  }

  Future<void> loadThemeFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? themeMode = prefs.getString('themeMode');
    if (themeMode == null) {
      _themeMode = "light";
      _themeData = ThemeData.light();
    } else {
      _themeMode = themeMode;
      setTheme(_themeMode);
    }
  }
}
