import 'dart:io';

import 'package:dio/dio.dart';

import '../environment.dart';
import '../models/character_model/character_model.dart';
import '../models/characters_model/characters_model.dart';
import '../models/episode_model/episode/episode_model.dart';
import '../models/location_model/location_model.dart';

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

  Future<CharactersModel> getCharacters(int page) async {
    Response response =
        await dio.get(Environment.baseUri + "character/?page=$page");

    if (response.statusCode == HttpStatus.ok) {
      return CharactersModel.fromJson(response.data);
    } else {
      throw Exception("Bir sorun Oluştu");
    }
  }

  Future<LocationModel> getLocation(String url) async {
    Response response = await dio.get(url);

    if (response.statusCode == HttpStatus.ok) {
      return LocationModel.fromJson(response.data);
    } else {
      throw Exception("Bir sorun Oluştu");
    }
  }

  Future<EpisodeResponseModel> getEpisode(int page) async {
    Response response =
        await dio.get(Environment.baseUri + "episode/?page=$page");

    if (response.statusCode == HttpStatus.ok) {
      return EpisodeResponseModel.fromJson(response.data);
    } else {
      throw Exception("Bir sorun Oluştu");
    }
  }

  Future<List<EpisodeModel>> getEpisodeWithId(String id) async {
    Response response = await dio.get(Environment.baseUri + "episode/$id");

    if (response.statusCode == HttpStatus.ok) {
      List<EpisodeModel> episodes = [];
      for (var item in response.data) {
        episodes.add(EpisodeModel.fromJson(item));
      }
      return episodes;
    } else {
      return [];
    }
  }

  Future<List<EpisodeModel>> getEpisodeWithFilter(String episodeName) async {
    Response response =
        await dio.get(Environment.baseUri + "episode/?name=$episodeName");

    if (response.statusCode == HttpStatus.ok) {
      List<EpisodeModel> episodes = [];

      for (var item in EpisodeResponseModel.fromJson(response.data).results!) {
        episodes.add(item);
      }
      return episodes;
    } else {
      return [];
    }
  }

  Future<List<CharacterModel>> getCharacterWithFilter(
      String characterName) async {
    Response response =
        await dio.get(Environment.baseUri + "character/?name=$characterName");

    if (response.statusCode == HttpStatus.ok) {
      List<CharacterModel> characters = [];

      for (var item in CharactersModel.fromJson(response.data).results!) {
        characters.add(item);
      }
      return characters;
    } else {
      return [];
    }
  }
}
