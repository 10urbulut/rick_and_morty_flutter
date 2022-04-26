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
    _charactersForPagination.addAll(_characters?.results ?? []);
    notifyListeners();
    return _characters!; //TODO:nullcheck kalkacak
  }

  CharacterModel? get character => _character;
  set setCharacter(CharacterModel value) {
    _character = value;
    notifyListeners();
  }

  CharactersModel? get characters => _characters;
  List<CharacterModel> get characterList => _characterList;
  List<CharacterModel> get charactersForPagination => _charactersForPagination;
}
