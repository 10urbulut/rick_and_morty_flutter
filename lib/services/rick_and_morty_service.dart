import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rick_and_morty_demo/models/characters_model/characters_model.dart';

import '../environment.dart';
import '../models/character_model/character_model.dart';

class RickAndMortyService {
  static final RickAndMortyService _singleton = RickAndMortyService._internal();
  factory RickAndMortyService() => _singleton;
  RickAndMortyService._internal();

  final dio = Dio();

  Future<CharacterModel> getById(int id) async {
    Response response = await dio.get(Environment.baseUri + "character/$id");

    if (response.statusCode == HttpStatus.ok) {
      return CharacterModel.fromJson(response.data);
    } else {
      throw Exception("Bir sorun Oluştu");
    }
  }

  Future<CharactersModel> get() async {
    Response response = await dio.get(Environment.baseUri + "character");

    if (response.statusCode == HttpStatus.ok) {
      return CharactersModel.fromJson(response.data);
    } else {
      throw Exception("Bir sorun Oluştu");
    }
  }
}
