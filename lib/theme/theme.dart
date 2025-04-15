import 'package:flutter/material.dart';

final standTheme = ThemeData(
  scaffoldBackgroundColor: const Color.fromARGB(255, 252, 254, 243),
  primarySwatch: Colors.pink,
  dividerTheme: const DividerThemeData(thickness: 2.0, color: Colors.pink),
  listTileTheme: const ListTileThemeData(iconColor: Colors.white),
  bottomAppBarTheme: const BottomAppBarTheme(color: Colors.pink),
  appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 252, 254, 243),
      centerTitle: true,
      titleTextStyle: TextStyle(
          color: Colors.black, fontSize: 30, fontWeight: FontWeight.w900)),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w900,
      fontSize: 20,
    ),
    labelSmall: TextStyle(
        color: Colors.black, fontWeight: FontWeight.w900, fontSize: 16),
  ),
);
