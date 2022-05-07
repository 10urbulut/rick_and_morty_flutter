import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/tool_tip_strings.dart';

// ignore: must_be_immutable
class SearchFieldTextField extends StatelessWidget {
  SearchFieldTextField({
    Key? key,
    this.onChanged,
    required this.isLoading,
    required this.hintText,
    this.startSearchOnTap,
    this.onSubmitted,
  }) : super(key: key);
  String hintText;
  void Function(String value)? onSubmitted;
  void Function(String value)? onChanged;
  bool isLoading;
  void Function()? startSearchOnTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.6,
        height: 35,
        child: TextField(
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.search,
          onChanged: onChanged,
          cursorColor: Theme.of(context).appBarTheme.backgroundColor,
          toolbarOptions: const ToolbarOptions(paste: true),
          decoration: _searchFieldDecoration(context),
        ),
      ),
    );
  }

  InputDecoration _searchFieldDecoration(BuildContext context) {
    return InputDecoration(
      contentPadding: const EdgeInsets.only(bottom: 8, top: 8, left: 14),
      hintStyle: GoogleFonts.combo(),
      hintText: hintText,
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
