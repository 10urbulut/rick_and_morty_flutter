import 'package:flutter/material.dart';

import '../../constants/tool_tip_strings.dart';

// ignore: must_be_immutable
class SearchOpenFloatingActionButton extends StatelessWidget {
  SearchOpenFloatingActionButton({Key? key, this.onPressed}) : super(key: key);
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: 'open',
        elevation: 3,
        tooltip: ToolTipStrings.SEARCH_ON,
        onPressed: onPressed,
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor);
  }
}
