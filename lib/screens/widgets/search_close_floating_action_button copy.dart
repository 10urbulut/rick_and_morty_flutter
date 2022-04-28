import 'package:flutter/material.dart';

import '../../constants/tool_tip_strings.dart';

class SearchCloseFloatingActionButton extends StatelessWidget {
  SearchCloseFloatingActionButton({Key? key, this.onPressed}) : super(key: key);
  void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
        heroTag: 'close',
        elevation: 15,
        tooltip: ToolTipStrings.SEARCH_OFF,
        onPressed: onPressed,
        child: const Icon(
          Icons.search_off,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).progressIndicatorTheme.color);
  }
}
