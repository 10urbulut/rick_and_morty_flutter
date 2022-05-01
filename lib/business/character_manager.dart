// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:rick_and_morty_demo/models/character_model/character_model.dart';
import 'package:rick_and_morty_demo/models/characters_model/characters_model.dart';
import 'package:rick_and_morty_demo/services/rick_and_morty_service.dart';

class CharacterManager extends ChangeNotifier {
  final RickAndMortyService _service = RickAndMortyService();

  CharacterModel? _character;
  List<CharacterModel> _characterList = [];
  List<CharacterModel> _charactersForPagination = [];
  CharactersModel? _characters;
  bool _isLoading = false;
  bool _searchVisible = false;
  bool _imageStatus = false;

  Future<CharacterModel?> getCharacter(int id) async {
    CharacterModel result = await _service.getById(id);
    _character = result;
    notifyListeners();
    return _character;
  }

  Future<CharactersModel>? getCharacters({int? page}) async {
    CharactersModel result = await _service.getCharacters(page ?? 1);
    _characters = result;
    _characterList.addAll(_characters?.results ?? []);
    _charactersForPagination += _characters?.results ?? [];
    notifyListeners();
    return _characters!;
  }

  Future getCharacterWithFilter(String characterName) async {
    setIsloading;
    List<CharacterModel> responseModel = await _service
        .getCharacterWithFilter(characterName)
        .whenComplete(() => setIsloading);
    _charactersForPagination = responseModel;
    notifyListeners();
  }

  CharacterModel? get character => _character;
  set setCharacter(CharacterModel value) {
    _character = value;
    notifyListeners();
  }

  CharactersModel? get characters => _characters;
  List<CharacterModel> get characterList => _characterList;
  List<CharacterModel> get charactersForPagination => _charactersForPagination;
  bool get isLoading => _isLoading;
  get setIsloading {
    notifyListeners();
    return _isLoading = !_isLoading;
  }

  bool get searchVisible => _searchVisible;
  bool get setSearchVisible {
    notifyListeners();
    return _searchVisible = !_searchVisible;
  }

  bool get setSearchVisibleFalse {
    notifyListeners();
    return _searchVisible = false;
  }

  bool get imageStatus => _imageStatus;

  bool get setImageStatus {
    notifyListeners();
    return _imageStatus = !_imageStatus;
  }

  bool get setImageStatusFalse {
    notifyListeners();
    return _imageStatus = false;
  }
}
