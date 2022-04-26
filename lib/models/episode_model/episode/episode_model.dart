import 'package:json_annotation/json_annotation.dart';
part 'episode_model.g.dart';

@JsonSerializable()
class EpisodeResponseModel {
  EpisodeResponseModel({
    this.info,
    this.results,
  });

  EpisodeResponseInfo? info;
  List<EpisodeModel>? results;
  factory EpisodeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeResponseModelToJson(this);
}

@JsonSerializable()
class EpisodeResponseInfo {
  EpisodeResponseInfo({
    this.count,
    this.pages,
    this.next,
    this.prev,
  });

  int? count;
  int? pages;
  String? next;
  String? prev;
  factory EpisodeResponseInfo.fromJson(Map<String, dynamic> json) =>
      _$EpisodeResponseInfoFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeResponseInfoToJson(this);
}

@JsonSerializable()
class EpisodeModel {
  EpisodeModel({
    this.id,
    this.name,
    this.airDate,
    this.episode,
    this.characters,
    this.url,
    this.created,
  });

  int? id;
  String? name;
  String? airDate;
  String? episode;
  List<String>? characters;
  String? url;
  DateTime? created;
  factory EpisodeModel.fromJson(Map<String, dynamic> json) =>
      _$EpisodeModelFromJson(json);
  Map<String, dynamic> toJson() => _$EpisodeModelToJson(this);
}
