import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'business/character_manager.dart';
import 'business/episode_manager.dart';
import 'business/location_manager.dart';
import 'constants/named_routes/named_routes.dart';
import 'constants/project_theme.dart';
import 'screens/characters_screen.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacterManager()),
        ChangeNotifierProvider(create: (_) => LocationManager()),
        ChangeNotifierProvider(create: (_) => EpisodeManager()),
      ],
      child: MaterialApp(
        home: CharactersScreen(),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.light,
        theme: ProjectTheme.themeData,
        routes: NamedRoutes.routes,
      ),
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
