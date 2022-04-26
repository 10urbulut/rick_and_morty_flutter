import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_demo/business/episode_manager.dart';
import 'package:rick_and_morty_demo/business/location_manager.dart';
import 'package:rick_and_morty_demo/constants/named_routes/named_route_strings.dart';
import 'package:rick_and_morty_demo/constants/title_strings.dart';
import 'package:rick_and_morty_demo/models/character_model/character_model.dart';

import '-widgets/unknown_text_widget.dart';
import '../business/character_manager.dart';
import '../constants/constant_strings.dart';

class CharacterScreen extends StatelessWidget {
  CharacterScreen({Key? key}) : super(key: key);

  final TextStyle _style = GoogleFonts.aBeeZee(fontSize: 18);
  CharacterModel? character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(TitleStrings.CHARACTER)),
      body: _body(context),
      floatingActionButton: _elevatedEpisodesButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
    );
  }

  ElevatedButton _elevatedEpisodesButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () async {
        String _epeisodeList = "";
        if (character?.episode != null) {
          for (var item in character!.episode!) {
            _epeisodeList += (item.split("/")[5]) + ",";
          }
        } else {}
        await context.read<EpisodeManager>().getEpisodeWithId(_epeisodeList);
        Navigator.pushNamed(context, NamedRouteStrings.EPISODES);
      },
      icon: const Icon(Icons.trending_flat_rounded),
      label: const Text(TitleStrings.EPISODES),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 10,
        primary: Theme.of(context).appBarTheme.backgroundColor,
        animationDuration: const Duration(seconds: 2),
      ),
    );
  }

  _body(BuildContext context) {
    return Consumer<CharacterManager>(
      builder: (context, value, child) {
        character = value.character;
        return Card(
          margin: const EdgeInsets.all(8),
          elevation: 25,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              const Divider(color: Colors.transparent, height: 6),
              _characterNameTextWithSizedBox(context),
              character == null
                  ? const Text("No image")
                  : _imageField(character!),
              const Divider(color: Colors.transparent),
              _informationsField(context),
            ]),
          ),
        );
      },
    );
  }

  SizedBox _characterNameTextWithSizedBox(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        elevation: 30,
        color: Colors.transparent,
        child: Text(
          character?.name ?? 'No Name',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.combo(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey.shade600),
        ),
      ),
    );
  }

  SizedBox _informationsField(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height / 3.88,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          children: [
            character?.location?.name == null
                ? UnknownTextWidget(value: 'Location')
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _locationField,
                      GestureDetector(
                        child: const Icon(Icons.info_outline),
                        onTap: () async {
                          await context
                              .read<LocationManager>()
                              .getLocation(character!.location!.url.toString());
                          Navigator.pushNamed(
                              context, NamedRouteStrings.LOCATION);
                        },
                      )
                    ],
                  ),
            _divider,
            character?.status == null
                ? UnknownTextWidget(value: character?.status)
                : _statusField,
            _divider,
            character?.gender == null
                ? UnknownTextWidget(
                    value: character?.gender,
                  )
                : _genderField,
            _divider,
            _originField(context),
            _divider,
            character?.type.toString() == ""
                ? UnknownTextWidget(value: "Type")
                : _typeField,
            _divider,
            character?.species == null ? const Text("Unknown") : _speciesField,
            _divider,
          ],
        ));
  }

  Row _originField(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _originText,
        GestureDetector(
          child: Icon(
            Icons.info_outline,
            color: character?.origin?.url == "" ? Colors.grey : null,
          ),
          onTap: character?.origin?.url == ""
              ? null
              : () async {
                  await context
                      .read<LocationManager>()
                      .getLocation(character!.origin!.url.toString());
                  Navigator.pushNamed(context, NamedRouteStrings.LOCATION);
                },
        )
      ],
    );
  }

  Text get _typeField =>
      Text("Type: " + character!.type.toString(), style: _style);

  Text get _speciesField =>
      Text("Species: " + character!.species.toString(), style: _style);

  Expanded get _originText => Expanded(
      child:
          Text("Origin: " + character!.origin!.name.toString(), style: _style));

  Text get _genderField =>
      Text("Gender: " + character!.gender.toString(), style: _style);

  Text get _statusField =>
      Text("Status: " + character!.status.toString(), style: _style);

  Expanded get _locationField => Expanded(
        child: Text("Location: " + character!.location!.name.toString(),
            style: _style),
      );

  Divider get _divider => const Divider(height: 5);

  Center _imageField(CharacterModel character) {
    return Center(
      child: character.image == null
          ? const Text("Doesen't Exist")
          : ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                  character.image ?? ConstantStrings.noImageUrl,
                  width: 250,
                  height: 250,
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
                            : null));
              }),
            ),
    );
  }
}
