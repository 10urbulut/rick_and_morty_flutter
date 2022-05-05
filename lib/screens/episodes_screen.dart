// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_demo/constants/tool_tip_strings.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_close_floating_action_button.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_field_text_field.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_open_floating_action_button.dart';

import '../business/episode_manager.dart';
import '../constants/constant_strings.dart';
import '../constants/enums.dart';
import '../constants/title_strings.dart';
import '../models/episode_model/episode/episode_model.dart';

class EpisodesScreen extends StatefulWidget {
  const EpisodesScreen({Key? key}) : super(key: key);

  @override
  State<EpisodesScreen> createState() => _EpisodesScreenState();
}

class _EpisodesScreenState extends State<EpisodesScreen> {
  ValueNotifier<PageStatus> pageStatus =
      ValueNotifier<PageStatus>(PageStatus.idle);

  String _searchValue = "";
  int page = 2;
  ScrollController? _scroll;

  @override
  void initState() {
    _createScroll();
    super.initState();
  }

  void _createScroll() {
    _scroll = ScrollController();
    _scroll?.addListener(loadMoreEpisode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar,
      body: _body,
      floatingActionButton: Consumer<EpisodeManager>(
        builder: (context, value, child) => AnimatedCrossFade(
            firstChild: _searchOpenFloatinActionButton(context),
            secondChild: _searchCloseFloatinActionButton(context),
            crossFadeState: !value.searchVisible
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: searchFieldDuration)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  AppBar get _appbar {
    return AppBar(
      title: Consumer<EpisodeManager>(
        builder: (context, value, child) => AnimatedCrossFade(
            firstChild: SearchFieldTextField(
                onSubmitted: (_) => value.getEpisodeWithFilter(_searchValue),
                startSearchOnTap: () =>
                    value.getEpisodeWithFilter(_searchValue),
                isLoading: value.isLoading,
                hintText: TitleStrings.SEARCH_BY_EPISODE_NAME,
                onChanged: (value) => _searchValue = value),
            secondChild: _appBarTitle,
            crossFadeState: value.searchVisible
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: searchFieldDuration)),
      ),
    );
  }

  Text get _appBarTitle => const Text(TitleStrings.EPISODES);

  SearchOpenFloatingActionButton _searchOpenFloatinActionButton(
      BuildContext context) {
    return SearchOpenFloatingActionButton(
      onPressed: () {
        context.read<EpisodeManager>().getEpisodeWithFilter("");
        context.read<EpisodeManager>().setSearchVisible;
      },
    );
  }

  SearchCloseFloatingActionButton _searchCloseFloatinActionButton(
      BuildContext context) {
    return SearchCloseFloatingActionButton(onPressed: () async {
      context.read<EpisodeManager>().getEpisodeWithFilter("");
      page = 2;
      context.read<EpisodeManager>().setSearchVisible;
    });
  }

  Consumer<EpisodeManager> get _body {
    return Consumer<EpisodeManager>(
      builder: (context, value, child) {
        List<EpisodeModel> episodes = value.episodes;
        return ListView.builder(
          controller: _scroll,
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 25,
              vertical: MediaQuery.of(context).size.width / 20),
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            return _expansionTileWithCardAndClipRRect(context, episodes, index);
          },
        );
      },
    );
  }

  _expansionTileWithCardAndClipRRect(
      BuildContext context, List<EpisodeModel> episodes, int index) {
    return Tooltip(
      message: ToolTipStrings.SEASON_EPISODE_AND_EPISODE_NAME,
      child: Card(
        elevation: 20,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: _expansionTile(context, episodes, index),
        ),
      ),
    );
  }

  ExpansionTile _expansionTile(
      BuildContext context, List<EpisodeModel> episodes, int index) {
    return ExpansionTile(
        expandedAlignment: Alignment.bottomLeft,
        leading: Icon(
          Icons.video_library,
          color: Theme.of(context).splashColor,
        ),
        collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
        iconColor: Theme.of(context).scaffoldBackgroundColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        controlAffinity: ListTileControlAffinity.platform,
        title: Column(
          children: [
            _seasonField(episodes, index),
            _episodeField(episodes, index),
          ],
        ),
        children: [
          const Divider(thickness: 1),
          _episodeNameField(episodes, index),
          const Divider(color: Colors.transparent)
        ]);
  }

  Row _seasonField(List<EpisodeModel> episodes, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Card(
          elevation: 15,
          color: Colors.transparent,
          child: Text(
              "Season " +
                  int.parse(episodes[index].episode!.split("S")[1][0] +
                          episodes[index].episode!.split("S")[1][1])
                      .toString(),
              style: _titleStyle),
        ),
      ],
    );
  }

  Row _episodeField(List<EpisodeModel> episodes, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          elevation: 15,
          color: Colors.transparent,
          child: Text(
              "Episode " +
                  int.parse(episodes[index].episode!.split("E")[1]).toString(),
              style: _titleStyle),
        ),
      ],
    );
  }

  SizedBox _episodeNameField(List<EpisodeModel> episodes, int index) {
    return SizedBox(
      child: Text(episodes[index].name.toString(),
          textAlign: TextAlign.center, style: _childStyle),
    );
  }

  Future<void> loadMoreEpisode() async {
    if (_scroll!.position.pixels >= _scroll!.position.maxScrollExtent &&
        pageStatus.value != PageStatus.newPageLoading &&
        page <= context.read<EpisodeManager>().episodeResponse!.info!.pages! &&
        !context.read<EpisodeManager>().searchVisible) {
      debugPrint(page.toString());
      pageStatus.value = PageStatus.newPageLoading;
      await context.read<EpisodeManager>().getEpisode(page: (page++));
      pageStatus.value = PageStatus.newPageLoaded;
    } else {}
  }

  TextStyle get _titleStyle => GoogleFonts.bubblegumSans(
        fontSize: 24,
        letterSpacing: 2,
        color: Colors.limeAccent.shade700,
        decorationStyle: TextDecorationStyle.wavy,
      );

  TextStyle get _childStyle => GoogleFonts.novaSquare(
      fontSize: 22,
      fontWeight: FontWeight.w100,
      letterSpacing: 2,
      color: Colors.limeAccent.shade700);
}
