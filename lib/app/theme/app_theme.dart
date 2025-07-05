import 'package:flutter/material.dart';
import 'package:fooddelivery_b/app/constant/theme_constant.dart';


class AppTheme {
  AppTheme._();

  static ThemeData getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      // change the theme according to the user preference
      colorScheme: isDarkMode
          ? const ColorScheme.dark(primary: ThemeConstant.darkPrimaryColor)
          : const ColorScheme.light(primary: ThemeConstant.primaryColor),
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      fontFamily: 'Montserrat',
      useMaterial3: true,
      // Change app bar color
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: ThemeConstant.appBarColor,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),
      // Scaffold theme
      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,
      // Change elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: ThemeConstant.primaryColor,
          textStyle: const TextStyle(fontSize: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      // Change text field theme
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(15),
        filled: true,
        fillColor: isDarkMode ? const Color(0xFF222222) : Colors.white,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDarkMode ? ThemeConstant.darkPrimaryColor : ThemeConstant.primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10),
        ),
        labelStyle: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.grey[200] : Colors.grey[800],
        ),
        hintStyle: TextStyle(
          fontSize: 16,
          color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
        ),
        helperStyle: TextStyle(
          color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
        ),
      ),
      // Circular progress bar theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ThemeConstant.primaryColor,
      ),
      //Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: ThemeConstant.primaryColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}