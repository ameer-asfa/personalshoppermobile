import 'package:flutter/material.dart';
import 'package:personalshopper/constants.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme(),
    inputDecorationTheme: inputDecorationTheme(),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
    centerTitle: true,
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    toolbarTextStyle: const TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ).bodyText2,
    titleTextStyle: const TextTheme(
      headline6: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
    ).headline6,
  );
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: const BorderSide(color: kPrimaryColor),
    // gapPadding: 10,
  );

  return InputDecorationTheme(
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 42,
      vertical: 20,
    ),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
  );
}
