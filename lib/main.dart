import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'business/character_manager.dart';
import 'screens/characters_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterManager()),
      ],
      child: MaterialApp(
        home: const CharactersScreen(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        theme: _themeData,
      ),
    );
  }

  ThemeData get _themeData {
    return ThemeData(
        textTheme: const TextTheme(),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                // backgroundColor: Colors.indigo,
                elevation: 0,
                primary: Colors.black87,
                textStyle: const TextStyle(
                  fontSize: 18,
                ))),
        cardTheme: CardTheme(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            color: Colors.deepOrange.shade50),
        appBarTheme: _appBarTheme);
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      elevation: 5,
      shadowColor: Colors.deepOrange,
      toolbarHeight: 40,
      titleTextStyle: _appBarTitleTextStyle,
      backgroundColor: Colors.deepOrange,
      actionsIconTheme: const IconThemeData(),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(100))),
    );
  }

  TextStyle get _appBarTitleTextStyle {
    return const TextStyle(
      letterSpacing: 1,
      fontSize: 25,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
