import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../business/character_manager.dart';
import '../models/characters_model/characters_model.dart';
import 'character_screen.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  String noImageUrl =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/1024px-No_image_available.svg.png";
  @override
  void initState() {
    context.read<CharacterManager>().getCharacters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _consumerForCard());
  }

  AppBar _appBar() {
    return AppBar(
      title: const Text('Characters'),
    );
  }

  Consumer<CharacterManager> _consumerForCard() {
    return Consumer<CharacterManager>(
      builder: (context, value, child) => _listViewBuilderForConsumer(value),
    );
  }

  ListView _listViewBuilderForConsumer(CharacterManager value) {
    return ListView.builder(
        itemCount: value.characters?.results?.length,
        itemBuilder: (context, index) {
          var data = value.characters?.results?[index];
          return GestureDetector(
            onTap: () async {
              await context
                  .read<CharacterManager>()
                  .getCharacter(data?.id ?? 1);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CharacterScreen()));
            },
            child: _cardWidget(data, context),
          );
        });
  }

  Card _cardWidget(Result? data, BuildContext context) {
    return Card(
      child: Row(
        children: [
          _cardFirstColumn(data, context),
          _cardSecondColumn(data, context),
        ],
      ),
    );
  }

  Column _cardSecondColumn(Result? data, BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Text(data?.name ?? 'No Name',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ],
        ),
        const Divider(color: Colors.transparent),
        Row(
          children: [
            data?.location?.name == null
                ? const Text("Unused Location")
                : Text("Location: " + data!.location!.name.toString(),
                    textScaleFactor: MediaQuery.of(context).size.width / 450),
          ],
        ),
        Row(
          children: [
            data?.origin?.name == null
                ? const Text("Unused Location")
                : Text("Origin: " + data!.origin!.name.toString(),
                    textScaleFactor: MediaQuery.of(context).size.width / 400),
          ],
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            data?.type == null
                ? const Text("Unknown")
                : Text("Type: " + data!.type.toString(),
                    textScaleFactor: MediaQuery.of(context).size.width / 400),
          ],
        ),
        Row(
          children: [
            data?.species == null
                ? const Text("Unknown")
                : Text("Species: " + data!.species.toString(),
                    textScaleFactor: MediaQuery.of(context).size.width / 400),
          ],
        ),
      ],
    );
  }

  Column _cardFirstColumn(Result? data, BuildContext context) {
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

  ClipRRect _imageWidget(Result? data, BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.horizontal(left: Radius.circular(50)),
      child: Image.network(
        data?.image.toString() ?? noImageUrl,
        scale: MediaQuery.of(context).size.width / 180,
        cacheWidth: 300,
        cacheHeight: 300,
      ),
    );
  }
}
