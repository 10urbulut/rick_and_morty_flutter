// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  CardWidget({Key? key, required this.child}) : super(key: key);
  Widget child;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width / 32),
      elevation: 15,
      child: child,
    );
  }
}
