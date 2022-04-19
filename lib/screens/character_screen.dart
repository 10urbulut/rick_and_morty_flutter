import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_demo/business/character_manager.dart';
import 'package:url_launcher/url_launcher.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({Key? key}) : super(key: key);

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            context.watch<CharacterManager>().character?.name ?? "Gelmedi"),
      ),
      body: Consumer<CharacterManager>(
        builder: (context, value, child) {
          return Card(
            elevation: 5,
            child: Column(
              children: [
                    // Text(
                    //   value.character?.name.toString() ?? "Unknown",
                    //   style: Theme.of(context).textTheme.displaySmall,
                    // ),
                    const Divider(color: Colors.transparent),
                    Center(
                      child: value.character?.image == null
                          ? const Text("Doesen't Exist")
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                  value.character!.image.toString())),
                    ),
                    const Divider(color: Colors.transparent),

                    Text(
                      value.character?.location?.name.toString() ?? "Unknown",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          value.character?.status ?? "Unknown",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(
                          ", ",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(
                          value.character?.gender ?? "Unknown",
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  ] +
                  value.character!.episode!
                      .map((e) => GestureDetector(
                          onTap: () async {
                            if (!await launch(e)) throw 'Could not launch $e';
                          },
                          child: Text(e)))
                      .toList(),
            ),
          );
        },
      ),
    );
  }
}
