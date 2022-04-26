import 'package:flutter/material.dart';
import 'package:rick_and_morty_demo/models/episode_model/episode/episode_model.dart';
import 'package:rick_and_morty_demo/services/rick_and_morty_service.dart';

class EpisodeManager extends ChangeNotifier {
  final RickAndMortyService _service = RickAndMortyService();

  List<EpisodeModel> _episodes = [];

  Future getEpisode({int? page}) async {
    EpisodeResponseModel responseModel = await _service.getEpisode(page ?? 1);
    _episodes = responseModel.results ?? [];
    notifyListeners();
  }

  Future getEpisodeWithId(String id) async {
    List<EpisodeModel> responseModel = await _service.getEpisodeWithId(id);
    _episodes = responseModel;
    notifyListeners();
  }

  List<EpisodeModel> get episodes => _episodes;
}
