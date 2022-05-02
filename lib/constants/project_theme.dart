import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProjectTheme {
  static ThemeData get themeData {
    return ThemeData(
      tooltipTheme: _tooltipTheme,
      useMaterial3: true,
      splashColor: Colors.amber,
      errorColor: Colors.red,
      primaryColor: Colors.deepOrange,
      colorScheme: _colorScheme,
      primaryColorLight: Colors.deepOrange,
      pageTransitionsTheme: _pageTransitionTheme,
      dividerTheme: _dividerTheme,
      progressIndicatorTheme: _progressIndicatorTheme,
      scaffoldBackgroundColor: Colors.redAccent.shade100,
      textButtonTheme: _textButtonTheme,
      cardTheme: _cardTheme,
      dialogTheme: _dialogTheme,
      appBarTheme: _appBarTheme,
    );
  }

  static DialogTheme get _dialogTheme {
    return DialogTheme(
      titleTextStyle: GoogleFonts.combo(
        color: Colors.black,
        fontSize: 17,
      ),
      backgroundColor: Colors.deepOrange.shade100,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  static DividerThemeData get _dividerTheme {
    return const DividerThemeData(
      color: Colors.black54,
      thickness: 3,
    );
  }

  static PageTransitionsTheme get _pageTransitionTheme {
    return const PageTransitionsTheme(builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    });
  }

  static ColorScheme get _colorScheme =>
      ColorScheme.fromSwatch(accentColor: Colors.amber.shade800);

  static ProgressIndicatorThemeData get _progressIndicatorTheme {
    return const ProgressIndicatorThemeData(
      color: Colors.orange,
    );
  }

  static CardTheme get _cardTheme {
    return CardTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        color: Colors.deepOrange.shade100);
  }

  static TextButtonThemeData get _textButtonTheme {
    return TextButtonThemeData(
      style: TextButton.styleFrom(textStyle: GoogleFonts.sansita(),
        backgroundColor: Colors.amber.shade50,primary: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    );
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
