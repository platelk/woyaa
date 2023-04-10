import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';

ThemeData welcomeTheme() {
  return ThemeData(
    scaffoldBackgroundColor: kWelcomeBackgroundColor,
    fontFamily: "Muli",
    appBarTheme: welcomeAppBarTheme(),
    textTheme: welcomeTextTheme(),
    inputDecorationTheme: welcomeInputDecorationTheme(),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: welcomeColorScheme(),
  );
}

ColorScheme welcomeColorScheme() {
  return ColorScheme.fromSeed(seedColor: kWelcomeBackgroundColor, primary: kWelcomePrimaryColor);
}

InputDecorationTheme welcomeInputDecorationTheme() {
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

TextTheme welcomeTextTheme() {
  return const TextTheme(
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    displayLarge: TextStyle(color: Colors.white),
  );
}

AppBarTheme welcomeAppBarTheme() {
  return const AppBarTheme(
    color: kWelcomePrimaryColor,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}
