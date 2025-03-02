import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    Color textColor = isDarkTheme ? Colors.white : Colors.black;
    Color? cardColor = isDarkTheme ? Colors.grey[900] : Colors.white;

    return ThemeData(
      primaryColor: isDarkTheme ? Colors.grey[800] : Colors.blue[700],
      scaffoldBackgroundColor:
          isDarkTheme ? Colors.grey[900] : Colors.grey[100],
      cardColor: cardColor,
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(color: textColor),
        labelLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: isDarkTheme ? Colors.blue[700] : Colors.grey[800],
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        backgroundColor: isDarkTheme ? Colors.grey[900] : Colors.grey[100],
        foregroundColor: isDarkTheme ? Colors.white : Colors.black,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: isDarkTheme ? Colors.grey[800] : Colors.blue[700],
        secondary: isDarkTheme ? Colors.blue[700] : Colors.grey[800],
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        onPrimary: isDarkTheme ? Colors.white : Colors.black,
        onSecondary: isDarkTheme ? Colors.black : Colors.white,
        onBackground: isDarkTheme ? Colors.white : Colors.black,
        surface: isDarkTheme ? Colors.grey[900]! : Colors.grey[100]!,
      ),
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: textColor),
        hintStyle: TextStyle(
          color: textColor.withOpacity(0.5),
        ),
      ),
    );
  }
}

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}
