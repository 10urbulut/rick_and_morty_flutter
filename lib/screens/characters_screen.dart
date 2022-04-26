import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../business/character_manager.dart';
import '../business/episode_manager.dart';
import '../constants/constant_strings.dart';
import '../constants/named_routes/named_route_strings.dart';
import '../constants/title_strings.dart';
import '../models/character_model/character_model.dart';
import '../models/characters_model/characters_model.dart';

class CharactersScreen extends StatelessWidget {
  CharactersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(context),
      floatingActionButton: _elevatedEpisodesButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  ElevatedButton _elevatedEpisodesButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        await context.read<EpisodeManager>().getEpisode();
        Navigator.pushNamed(context, NamedRouteStrings.EPISODES);
      },
      icon: const Icon(Icons.turn_right_sharp),
      label: const Text("All\n" + TitleStrings.EPISODES),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        primary: Theme.of(context).appBarTheme.backgroundColor,
        animationDuration: const Duration(seconds: 2),
      ),
    );
  }

  FutureBuilder<CharactersModel> _body(BuildContext context) {
    return FutureBuilder<CharactersModel>(
        future: context.read<CharacterManager>().getCharacters(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                  child:
                      SizedBox(width: 200, child: LinearProgressIndicator()));

            case ConnectionState.done:
              return _consumerForCard();

            default:
              throw Exception();
          }
        });
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text(TitleStrings.CHARACTERS),
    );
  }

  _consumerForCard() {
    return Consumer<CharacterManager>(
      builder: (context, value, child) =>
          _listViewBuilderForConsumer(value.characters?.results ?? []),
    );
  }

  _listViewBuilderForConsumer(List<CharacterModel> value) {
    return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        itemCount: value.length,
        itemBuilder: (context, index) {
          var data = value[index];
          return Transform.rotate(
            angle: -0.1,
            child: GestureDetector(
              onTap: () async {
                context.read<CharacterManager>().setCharacter = data;
                Navigator.pushNamed(context, NamedRouteStrings.CHARACTER);
              },
              child: _cardWidget(data, context),
            ),
          );
        });
  }

  Card _cardWidget(CharacterModel? data, BuildContext context) {
    return Card(
      elevation: 30,
      child: Stack(
        alignment: AlignmentDirectional.centerEnd,
        children: [
          const Icon(Icons.arrow_right_rounded, color: Colors.grey, size: 45),
          Row(
            children: [
              _cardFirstColumn(data, context),
              _cardSecondColumn(data, context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _cardSecondColumn(CharacterModel? data, BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        children: [
          _nameField(context, data),
          _statusField(context, data),
          const Divider(color: Colors.transparent),
        ],
      ),
    );
  }

  Row _nameField(BuildContext context, CharacterModel? data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Text(
            data?.name ?? 'No Name',
            style: GoogleFonts.combo(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey.shade600),
          ),
        ),
      ],
    );
  }

  Row _statusField(BuildContext context, CharacterModel? data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: Stack(
            children: [
              Icon(Icons.circle,
                  color: data?.status == 'Alive'
                      ? Colors.green
                      : data?.status == 'unknown'
                          ? Colors.blue
                          : data?.status == 'Dead'
                              ? Colors.red
                              : Colors.amber,
                  size: 10),
              Text(
                data?.status ?? 'No Name',
                style: GoogleFonts.amaticSc(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: Colors.blueGrey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _cardFirstColumn(CharacterModel? data, BuildContext context) {
    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _imageWidget(data, context),
        ],
      ),
    ]);
  }

  ClipRRect _imageWidget(CharacterModel? data, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(50)),
      child: Image.network(
        data?.image.toString() ?? ConstantStrings.noImageUrl,
        scale: MediaQuery.of(context).size.width / 180,
        cacheWidth: 300,
        cacheHeight: 300,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return Center(
              heightFactor: 3,
              widthFactor: 3.5,
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ));
        },
      ),
    );
  }
}
