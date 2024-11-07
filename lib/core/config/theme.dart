import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static final AppTheme _instance = AppTheme();
  AppTheme get instance => _instance;
  late ThemeMode themeMode;
  late ThemeData theme;

  static initTheme() async {
    _instance.themeMode = await _instance.getThemeMode();
    _instance.theme = _instance.getTheme();
  }

  Future<ThemeMode> getThemeMode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    late String themeMode;
    themeMode = sharedPreferences.getString('themeMode') ?? 'system';
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        bool isDarkMode = Get.isPlatformDarkMode;
        return isDarkMode ? ThemeMode.dark : ThemeMode.light;
    }
  }

  ThemeData getTheme() {
    switch (themeMode) {
      case ThemeMode.light:
        return lightTheme;
      default:
        return darkTheme;
    }
  }

  void changeThemeMode(ThemeMode themeMode,
      {GetxController? getxController}) async {
    if (themeMode == ThemeMode.system) {
      bool isDarkMode = Get.isPlatformDarkMode;
      isDarkMode
          ? _instance.themeMode = ThemeMode.dark
          : _instance.themeMode = ThemeMode.light;
    } else {
      _instance.themeMode = themeMode;
    }
    _instance.theme = getTheme();
    Get.changeTheme(_instance.theme);
    getxController?.update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'themeMode',
        _instance.themeMode == ThemeMode.light
            ? 'light'
            : _instance.themeMode == ThemeMode.dark
                ? 'dark'
                : 'system');
  }

// light Theme
  final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    appBarTheme: AppBarTheme(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
  );

  // dark Theme
  final ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.grey,
      ));
}
