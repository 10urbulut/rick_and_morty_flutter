// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_demo/constants/enums.dart';
import 'package:rick_and_morty_demo/constants/tool_tip_strings.dart';
import 'package:rick_and_morty_demo/screens/widgets/container_shadow_widget.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_close_floating_action_button.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_field_text_field.dart';
import 'package:rick_and_morty_demo/screens/widgets/search_open_floating_action_button.dart';
import 'package:url_launcher/url_launcher.dart' as ul;

import '../business/character_manager.dart';
import '../business/episode_manager.dart';
import '../constants/constant_strings.dart';
import '../constants/named_routes/named_route_strings.dart';
import '../constants/title_strings.dart';
import '../models/character_model/character_model.dart';
import '../models/characters_model/characters_model.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  ScrollController? _scroll;
  int page = 2;

  ValueNotifier<PageStatus> pageStatus =
      ValueNotifier<PageStatus>(PageStatus.idle);

  String _searchValue = "";

  @override
  void initState() {
    _createScroll();
    super.initState();
  }

  void _createScroll() {
    _scroll = ScrollController();
    _scroll?.addListener(loadMoreCharacter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body(context),
      floatingActionButton: Consumer<CharacterManager>(
        builder: (context, value, child) => AnimatedCrossFade(
            firstChild: _searchOpenFloatinActionButton(context),
            secondChild: _searchCloseFloatinActionButton(context),
            crossFadeState: value.searchVisible
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: searchFieldDuration)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Stack _body(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.topStart, children: [
      _bodyFutureBuilder(context),
      _elevatedEpisodesButton(context),
    ]);
  }

  SearchOpenFloatingActionButton _searchOpenFloatinActionButton(
      BuildContext context) {
    return SearchOpenFloatingActionButton(
      onPressed: () {
        context.read<CharacterManager>().setSearchVisible;
      },
    );
  }

  SearchCloseFloatingActionButton _searchCloseFloatinActionButton(
      BuildContext context) {
    return SearchCloseFloatingActionButton(
      onPressed: () async {
        context.read<CharacterManager>().getCharacterWithFilter("");
        page = 2;
        context.read<CharacterManager>().setSearchVisible;
      },
    );
  }

  Widget _elevatedEpisodesButton(BuildContext context) {
    return Consumer<CharacterManager>(
      builder: (context, value, child) => AnimatedCrossFade(
        firstChild: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Tooltip(
            message: ToolTipStrings.TAP_FOR_ALL_EPISODES,
            child: ElevatedButton.icon(
              onPressed: () async =>
                  await _elevatedEpisodesButtonOnPressed(context),
              icon: const Icon(Icons.turn_right_sharp),
              label: const Text("All\n" + TitleStrings.EPISODES),
              style: _elevatedEpisodesButtonStyle(context),
            ),
          ),
        ),
        duration: const Duration(milliseconds: searchFieldDuration),
        secondChild: const Divider(color: Colors.transparent),
        crossFadeState: !value.searchVisible
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
      ),
    );
  }

  ButtonStyle _elevatedEpisodesButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      primary: Theme.of(context).appBarTheme.backgroundColor,
      animationDuration: const Duration(seconds: 2),
    );
  }

  Future<void> _elevatedEpisodesButtonOnPressed(BuildContext context) async {
    context.read<EpisodeManager>().setSearchVisibleFalse;
    context.read<EpisodeManager>().clearEpisodes();
    await context.read<EpisodeManager>().getEpisode();
    Navigator.pushNamed(context, NamedRouteStrings.EPISODES);
  }

  FutureBuilder<CharactersModel> _bodyFutureBuilder(BuildContext context) {
    return FutureBuilder<CharactersModel>(
        future: context.read<CharacterManager>().getCharacters(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return _connectionStateProgressWidget();

            case ConnectionState.done:
              return snapshot.data == null
                  ? _ifDataNullField
                  : _consumerForCard;

            default:
              throw Exception();
          }
        });
  }

  Center _connectionStateProgressWidget() {
    return Center(
        child: SizedBox(
            width: 200,
            child: Transform.rotate(
                angle: -0.1, child: const LinearProgressIndicator())));
  }

  Center get _ifDataNullField => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Is your internet working? Please check! ',
              style: GoogleFonts.combo(fontSize: 20),
            ),
            _refreshCharactersIsEmptyIconButton,
          ],
        ),
      );

  IconButton get _refreshCharactersIsEmptyIconButton {
    return IconButton(
      //If set to state again, the future builder run again.
      //That means service will send new request to api then refresh was worked!
      onPressed: () => setState(() {}),
      icon: const Icon(
        Icons.refresh,
      ),
    );
  }

  AppBar get _appBar => AppBar(
        title: Consumer<CharacterManager>(
          builder: (context, value, child) => AnimatedCrossFade(
              firstChild: SearchFieldTextField(
                  onSubmitted: (_) =>
                      value.getCharacterWithFilter(_searchValue),
                  startSearchOnTap: () =>
                      value.getCharacterWithFilter(_searchValue),
                  isLoading: value.isLoading,
                  hintText: TitleStrings.SEARCH_BY_CHARACTER_NAME,
                  onChanged: (value) => _searchValue = value),
              secondChild: const Text(TitleStrings.CHARACTERS),
              crossFadeState: value.searchVisible
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: searchFieldDuration)),
        ),
        actions: [
          IconButton(
            onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Column(
                      children: [
                        const Text("About me"),
                        Row(
                          children: const [
                            Expanded(
                              child: Text(aboutMe),
                            ),
                          ],
                        ),
                        _aboutMeMailField,
                        const Divider(color: Colors.transparent),
                        _buyMeACoffeeButton,
                        const Divider(color: Colors.transparent),
                      ],
                    ),
                  );
                }),
            icon: const Icon(
              Icons.adjust_sharp,
              color: Colors.white70,
              size: 10,
            ),
          ),
          const VerticalDivider(
            color: Colors.transparent,
            width: 20,
          ),
        ],
      );

  Widget get _aboutMeMailField {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(const ClipboardData(text: onurBulutGMail)).then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            _aboutMeMailCoppiedSnackBarMessage,
          ),
        );
      },
      child: Text(
        onurBulutGMail,
        style: GoogleFonts.sansita(fontSize: 14, color: Colors.indigo),
      ),
    );
  }

  SnackBar get _aboutMeMailCoppiedSnackBarMessage {
    return SnackBar(
      content: const Text(
        "Coppied!",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );
  }

  TextButton get _buyMeACoffeeButton {
    return TextButton.icon(
      onPressed: () async {
        if (!await ul.launch(buyMeACoffeeUrl)) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: _errorMessageForBuyMeACoffee,
            backgroundColor: Theme.of(context).primaryColor,
          ));
        }
      },
      icon: Image.asset(
        "assets/images/bmc.png",
        height: 25,
        width: 25,
      ),
      label: const Text("Buy me a coffee  "),
    );
  }

  Text get _errorMessageForBuyMeACoffee {
    return const Text(
      "Ups! You should have went to;\n" + buyMeACoffeeUrl,
      textAlign: TextAlign.center,
    );
  }

  Widget get _consumerForCard => Consumer<CharacterManager>(
        builder: (context, value, child) => _listViewBuilderForConsumer(
            value.charactersForPagination, context, value),
      );

  _listViewBuilderForConsumer(List<CharacterModel> value, BuildContext context,
      CharacterManager manager) {
    return ListView.builder(
        controller: _scroll,
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width / 35,
            right: MediaQuery.of(context).size.width / 35,
            top: MediaQuery.of(context).size.width / 12.5,
            bottom: MediaQuery.of(context).size.width / 12.5),
        itemCount: value.length,
        itemBuilder: (context, index) {
          CharacterModel data = value[index];
          return Transform.rotate(
            angle: -0.1,
            child: GestureDetector(
              onTap: () async {
                manager.setSearchVisibleFalse;
                manager.setImageStatusFalse;
                manager.setCharacter = data;
                Navigator.pushNamed(context, NamedRouteStrings.CHARACTER);
              },
              child: _cardWidget(data, context),
            ),
          );
        });
  }

  Widget _cardWidget(CharacterModel? data, BuildContext context) {
    return Tooltip(
      message: ToolTipStrings.TAP_FOR_THE_CHARACTER_DETAILS,
      child: ContainerShadowWidget(
        margin: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.height / 50),
        child: Stack(
          alignment: AlignmentDirectional.centerEnd,
          children: [
            const Icon(Icons.arrow_right_rounded, color: Colors.grey, size: 45),
            Row(
              children: [
                _cardFirstColumn(data, context),
                const VerticalDivider(),
                _cardSecondColumn(data, context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardSecondColumn(CharacterModel? data, BuildContext context) {
    return Column(
      children: [
        _nameField(context, data),
        _statusField(context, data),
        const Divider(color: Colors.transparent),
      ],
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

  Future<void> loadMoreCharacter() async {
    if (_scroll!.position.pixels >= _scroll!.position.maxScrollExtent - 10 &&
        pageStatus.value != PageStatus.newPageLoading &&
        page <= context.read<CharacterManager>().characters!.info!.pages! &&
        !context.read<CharacterManager>().searchVisible) {
      debugPrint(page.toString());
      pageStatus.value = PageStatus.newPageLoading;
      await context.read<CharacterManager>().getCharacters(page: (page++));
      pageStatus.value = PageStatus.newPageLoaded;
      // _scroll?.jumpTo(_scroll!.position.maxScrollExtent-5);
    } else {}
  }
}
