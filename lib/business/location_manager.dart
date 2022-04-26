import 'package:flutter/material.dart';
import 'package:rick_and_morty_demo/services/rick_and_morty_service.dart';

import '../models/location_model/location_model.dart';

class LocationManager extends ChangeNotifier {
  RickAndMortyService _service = RickAndMortyService();
  LocationModel? _location;

  Future<LocationModel?> getLocation(String url) async {
    _location = await _service.getLocation(url);
    notifyListeners();
    return _location;
  }

  LocationModel? get location => _location;
}
