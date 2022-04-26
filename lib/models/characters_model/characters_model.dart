// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import '../character_model/character_model.dart';
part 'characters_model.g.dart';

@JsonSerializable()
class CharactersModel {
  factory CharactersModel.fromJson(Map<String, dynamic> json) =>
      _$CharactersModelFromJson(json);
  Map<String, dynamic> toJson() => _$CharactersModelToJson(this);

  CharactersModel({
    this.info,
    this.results,
  });

  Info? info;
  List<CharacterModel>? results;
}

@JsonSerializable()
class Info {
  Info({
    this.count,
    this.pages,
    this.next,
    this.prev,
  });

  int? count;
  int? pages;
  String? next;
  String? prev;
  factory Info.fromJson(Map<String, dynamic> json) => _$InfoFromJson(json);
  Map<String, dynamic> toJson() => _$InfoToJson(this);
}

@JsonSerializable()
class Location {
  Location({
    this.name,
    this.url,
  });

  String? name;
  String? url;

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}
