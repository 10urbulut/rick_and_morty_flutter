import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class UnknownTextWidget extends StatelessWidget {
  UnknownTextWidget({Key? key, this.value}) : super(key: key);
  String? value;
  @override
  Widget build(BuildContext context) {
    return Text('$value:  Unknown', style: GoogleFonts.aBeeZee(fontSize: 18));
  }
}
