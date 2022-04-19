import 'package:flutter/material.dart';
import 'package:rick_and_morty_demo/models/character_model/character_model.dart';
import 'package:rick_and_morty_demo/models/characters_model/characters_model.dart';
import 'package:rick_and_morty_demo/services/rick_and_morty_service.dart';

class CharacterManager extends ChangeNotifier {
  final RickAndMortyService _service = RickAndMortyService();

  CharacterModel? _character;
  CharactersModel? _characters;

  Future getCharacter(int id) async {
    CharacterModel result = await _service.getById(id);
    _character = result;
    notifyListeners();
  }

  Future getCharacters() async {
    CharactersModel result = await _service.get();
    _characters = result;
    notifyListeners();
  }

  CharacterModel? get character => _character;
  set setCharacter(CharacterModel value) => _character = value;
  CharactersModel? get characters => _characters;
}
