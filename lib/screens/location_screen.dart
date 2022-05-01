import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_demo/screens/widgets/card_widget.dart';
import 'package:rick_and_morty_demo/screens/widgets/container_shadow_widget.dart';

import '../business/location_manager.dart';
import '../constants/title_strings.dart';
import '../models/location_model/location_model.dart';

class LocationScreen extends StatelessWidget {
  LocationScreen({Key? key}) : super(key: key);
  final TextStyle _style = GoogleFonts.aBeeZee(fontSize: 20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(TitleStrings.LOCATION),
      ),
      body: Consumer<LocationManager>(
        builder: (context, value, child) {
          var data = value.location;
          return CardWidget(
            child: ContainerShadowWidget(
              child: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  children: [
                    CircleAvatar(
                        backgroundColor: Theme.of(context).backgroundColor,
                        radius: 40,
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 50,
                          color: Theme.of(context).dialogBackgroundColor,
                        )),
                    const Divider(color: Colors.transparent),
                    _nameField(data),
                    _divider,
                    _dimensionField(data),
                    _divider,
                    _typeField(data),
                    _divider,
                  ]),
            ),
          );
        },
      ),
    );
  }

  Row _typeField(LocationModel? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: Text("Type: ", style: _style)),
        Expanded(child: Text(data?.type.toString() ?? "", style: _style)),
      ],
    );
  }

  Row _dimensionField(LocationModel? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: Text("Dimension: ", style: _style)),
        Expanded(child: Text(data?.dimension.toString() ?? "", style: _style)),
      ],
    );
  }

  Row _nameField(LocationModel? data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(child: Text('Name: ', style: _style)),
        Expanded(child: Text(data?.name.toString() ?? "", style: _style)),
      ],
    );
  }

  Divider get _divider => const Divider();
}
//TODO:Pagination,characters