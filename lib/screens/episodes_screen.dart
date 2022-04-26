import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../business/episode_manager.dart';
import '../constants/title_strings.dart';
import '../models/episode_model/episode/episode_model.dart';

class EpisodesScreen extends StatelessWidget {
  EpisodesScreen({Key? key}) : super(key: key);
  final TextStyle _titleStyle = GoogleFonts.bubblegumSans(
    fontSize: 24,
    letterSpacing: 2,
    color: Colors.limeAccent.shade700,
    decorationStyle: TextDecorationStyle.wavy,
  );
  final TextStyle _childStyle = GoogleFonts.novaSquare(
      fontSize: 22,
      fontWeight: FontWeight.w100,
      letterSpacing: 2,
      color: Colors.limeAccent.shade700);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TitleStrings.EPISODES)),
      body: _body(),
    );
  }

  Consumer<EpisodeManager> _body() {
    return Consumer<EpisodeManager>(
      builder: (context, value, child) {
        List<EpisodeModel> episodes = value.episodes;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          itemCount: episodes.length,
          itemBuilder: (context, index) {
            return _expansionTileWithCardAndClipRRect(context, episodes, index);
          },
        );
      },
    );
  }

  Card _expansionTileWithCardAndClipRRect(
      BuildContext context, List<EpisodeModel> episodes, int index) {
    return Card(
      elevation: 20,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: ExpansionTile(
            expandedAlignment: Alignment.bottomLeft,
            textColor: Colors.grey,
            leading: Icon(
              Icons.video_library,
              color: Theme.of(context).splashColor,
            ),
            collapsedBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
            ]),
      ),
    );
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
}
