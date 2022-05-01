import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectTheme {
  static ThemeData get themeData {
    return ThemeData(
        tooltipTheme: _tooltipTheme,
        useMaterial3: true,
        splashColor: Colors.amber,
        errorColor: Colors.red,
        primaryColor: Colors.deepOrange,
        colorScheme: ColorScheme.fromSwatch(accentColor: Colors.amber.shade800),
        primaryColorLight: Colors.deepOrange,
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        }),
        dividerTheme: const DividerThemeData(
          color: Colors.black54,
          thickness: 3,
        ),
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.orange,
        ),
        scaffoldBackgroundColor: Colors.redAccent.shade100,
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
            color: Colors.deepOrange.shade100),
        appBarTheme: _appBarTheme);
  }

  static TooltipThemeData get _tooltipTheme => TooltipThemeData(
      textStyle: GoogleFonts.comicNeue(
          color: Colors.white, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
          color: Colors.deepOrange, borderRadius: BorderRadius.circular(5)));

  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      elevation: 5,
      shadowColor: Colors.transparent,
      toolbarHeight: 40,
      titleTextStyle: _appBarTitleTextStyle,
      backgroundColor: Colors.deepOrange.shade900,
      actionsIconTheme: const IconThemeData(),
      centerTitle: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(100))),
    );
  }

  static TextStyle get _appBarTitleTextStyle {
    return const TextStyle(
      letterSpacing: 1,
      fontSize: 25,
    );
  }
}
