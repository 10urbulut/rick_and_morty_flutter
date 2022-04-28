// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_demo/constants/tool_tip_strings.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_close_floating_action_button%20copy.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_open_floating_action_button.dart';

import '../business/episode_manager.dart';
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
  ValueNotifier<bool> _searchVisible = ValueNotifier<bool>(true);

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
      appBar: AppBar(
        title: AnimatedCrossFade(
            firstChild: _searcField,
            secondChild: _appBarTitle,
            crossFadeState: !_searchVisible.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500)),
      ),
      body: _body,
      floatingActionButton: AnimatedCrossFade(
          firstChild: _searchOpenFloatinActionButton(context),
          secondChild: _searchCloseFloatinActionButton(context),
          crossFadeState: _searchVisible.value
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 500)),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Text get _appBarTitle => const Text(TitleStrings.EPISODES);

  SearchOpenFloatingActionButton _searchOpenFloatinActionButton(
      BuildContext context) {
    return SearchOpenFloatingActionButton(
      onPressed: () {
        setState(() => _searchVisible.value = !_searchVisible.value);
      },
    );
  }

  SearchCloseFloatingActionButton _searchCloseFloatinActionButton(
      BuildContext context) {
    return SearchCloseFloatingActionButton(onPressed: () async {
      context.read<EpisodeManager>().getEpisodeWithFilter("");
      setState(() => _searchVisible.value = !_searchVisible.value);
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
      width: 300,
      child: Expanded(
          child: Text(episodes[index].name.toString(),
              textAlign: TextAlign.center, style: _childStyle)),
    );
  }

  Future<void> loadMoreEpisode() async {
    if (_scroll!.position.pixels >= _scroll!.position.maxScrollExtent &&
        pageStatus.value != PageStatus.newPageLoading &&
        page <= context.read<EpisodeManager>().episodeResponse!.info!.pages!) {
      debugPrint(page.toString());
      pageStatus.value = PageStatus.newPageLoading;
      await context.read<EpisodeManager>().getEpisode(page: (page++));
      pageStatus.value = PageStatus.newPageLoaded;
    } else {}
  }

  Widget get _searcField {
    return Card(
      child: SizedBox(
        width: 250,
        height: 35,
        child: TextField(
          onChanged: (value) => _searchValue = value,
          cursorColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarOptions: const ToolbarOptions(paste: true),
          decoration: _searchFieldDecoration(),
        ),
      ),
    );
  }

  InputDecoration _searchFieldDecoration() {
    return InputDecoration(
      label:
          Text(TitleStrings.SEARCH_BY_EPISODE_NAME, style: GoogleFonts.combo()),
      labelStyle: const TextStyle(color: Colors.black),
      suffixIcon: GestureDetector(
        onTap: () async {
          await context
              .read<EpisodeManager>()
              .getEpisodeWithFilter(_searchValue);
        },
        child: Tooltip(
          message: ToolTipStrings.START_SEARCH,
          child: context.watch<EpisodeManager>().isLoading
              ? Icon(Icons.circle_outlined, color: Colors.amber.shade900)
              : const Icon(Icons.search, color: Colors.black),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(style: BorderStyle.none),
      ),
      enabledBorder: _searchFieldEnabledBorder,
      border: _searchFieldBorder,
    );
  }

  OutlineInputBorder get _searchFieldBorder {
    return const OutlineInputBorder(
      borderSide: BorderSide(style: BorderStyle.none),
      borderRadius: BorderRadius.only(
        bottomRight: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
  }

  OutlineInputBorder get _searchFieldEnabledBorder =>
      const OutlineInputBorder(borderSide: BorderSide.none);
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
