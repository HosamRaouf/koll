import 'package:flutter/material.dart';

import '../styles.dart';

class MyInkWell extends StatefulWidget {
  final Function() onTap;
  final double radius;
  final Widget child;
  final Color? hoverColor;

  MyInkWell({
    super.key,
    required this.onTap,
    required this.radius,
    required this.child,
    this.hoverColor,
  });

  @override
  State<MyInkWell> createState() => _MyInkWellState();
}

class _MyInkWellState extends State<MyInkWell> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.radius),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: widget.hoverColor,
          splashColor: backGroundColor.withOpacity(0.3),
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
