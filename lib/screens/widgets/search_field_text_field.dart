import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/title_strings.dart';
import '../../constants/tool_tip_strings.dart';

class SearchFieldTextField extends StatelessWidget {
  SearchFieldTextField({
    Key? key,
    this.onChanged,
    required this.isLoading,this.startSearchOnTap
  }) : super(key: key);

  void Function(String)? onChanged;
  bool isLoading;
  void Function()? startSearchOnTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 250,
        height: 35,
        child: TextField(
          onChanged: (value) => onChanged,
          cursorColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarOptions: const ToolbarOptions(paste: true),
          decoration: _searchFieldDecoration(context),
        ),
      ),
    );
  }

  InputDecoration _searchFieldDecoration(BuildContext context) {
    return InputDecoration(
      label:
          Text(TitleStrings.SEARCH_BY_EPISODE_NAME, style: GoogleFonts.combo()),
      labelStyle: const TextStyle(color: Colors.black),
      suffixIcon: GestureDetector(
        onTap: startSearchOnTap,
        child: Tooltip(
          message: ToolTipStrings.START_SEARCH,
          child: isLoading
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
}
