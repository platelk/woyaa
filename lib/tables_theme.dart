import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData tablesTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kTablesBackgroundColor,
    fontFamily: "Muli",
    appBarTheme: tablesAppBarTheme(),
    textTheme: tablesTextTheme(),
    inputDecorationTheme: tablesInputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: tablesColorScheme(),
  );
}

ThemeData trombiTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kTrombiBackgroundColor,
    fontFamily: "Muli",
    appBarTheme: tablesAppBarTheme(),
    textTheme: tablesTextTheme(),
    inputDecorationTheme: tablesInputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: trombiColorScheme(),
  );
}

ColorScheme trombiColorScheme() {
  return ColorScheme.fromSeed(seedColor: kTrombiBackgroundColor, primary: kTablesPrimaryColor);
}

ColorScheme tablesColorScheme() {
  return ColorScheme.fromSeed(seedColor: kTablesBackgroundColor, primary: kTablesPrimaryColor);
}

InputDecorationTheme tablesInputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: kTextColor),
    gapPadding: 10,

  );
  return InputDecorationTheme(
    // If  you are using latest version of flutter then lable text and hint text shown like this
    // if you r using flutter less then 1.20.* then maybe this is not working properly
    // if we are define our floatingLabelBehavior in our theme then it's not applayed
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: const EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme tablesTextTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
    headlineSmall:  TextStyle(color: Colors.white),
    headlineMedium:  TextStyle(color: Colors.white),
    headlineLarge:  TextStyle(color: Colors.white),
  );
}

AppBarTheme tablesAppBarTheme() {
  return const AppBarTheme(
    color: kTablesPrimaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
