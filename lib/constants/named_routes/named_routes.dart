import 'package:flutter/material.dart';

import '../../screens/character_screen.dart';
import '../../screens/characters_screen.dart';
import '../../screens/episodes_screen.dart';
import '../../screens/location_screen.dart';
import 'named_route_strings.dart';

class NamedRoutes {
  static Map<String, WidgetBuilder> get routes => {
        NamedRouteStrings.CHARACTER: (BuildContext context) =>
            CharacterScreen(),
        NamedRouteStrings.CHARACTERS: (BuildContext context) =>
            const CharactersScreen(),
        NamedRouteStrings.EPISODES: (BuildContext context) =>
            const EpisodesScreen(),
        NamedRouteStrings.LOCATION: (BuildContext context) => LocationScreen(),
      };
}
