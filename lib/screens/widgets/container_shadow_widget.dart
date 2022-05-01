import 'package:flutter/material.dart';

class ContainerShadowWidget extends StatelessWidget {
  ContainerShadowWidget({
    Key? key,
    this.child,
    this.margin,
  }) : super(key: key);
  Widget? child;
  EdgeInsetsGeometry? margin;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: margin,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Colors.deepOrange.shade200,
          boxShadow: [
            BoxShadow(
                color: Colors.deepOrange.shade400,
                spreadRadius: 6,
                offset: const Offset(0, 0)),
          ]),
    );
  }
}
