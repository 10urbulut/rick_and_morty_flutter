import 'package:flutter/material.dart';
import 'package:rick_and_morty_demo/models/episode_model/episode/episode_model.dart';
import 'package:rick_and_morty_demo/services/rick_and_morty_service.dart';

class EpisodeManager extends ChangeNotifier {
  final RickAndMortyService _service = RickAndMortyService();
  bool _isLoading = false;
  List<EpisodeModel> _episodes = [];
  EpisodeResponseModel? _episodeResponse;
  bool _searchVisible = false;

  Future getEpisode({int? page}) async {
    _episodeResponse = await _service.getEpisode(page ?? 1);
    _episodes += _episodeResponse?.results ?? [];
    notifyListeners();
  }

  Future getEpisodeWithId(String id) async {
    List<EpisodeModel> responseModel = await _service.getEpisodeWithId(id);
    _episodes = responseModel;
    notifyListeners();
  }

  Future getEpisodeWithFilter(String episodeName) async {
    setIsLoading;
    List<EpisodeModel> responseModel = await _service
        .getEpisodeWithFilter(episodeName)
        .whenComplete(() => setIsLoading);
    _episodes = responseModel;
    notifyListeners();
  }

  void clearEpisodes() {
    _episodes.clear();
    notifyListeners();
  }

  List<EpisodeModel> get episodes => _episodes;
  EpisodeResponseModel? get episodeResponse => _episodeResponse;
  bool get isLoading => _isLoading;
  get setIsLoading {
    _isLoading = !_isLoading;
    notifyListeners();
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
}
