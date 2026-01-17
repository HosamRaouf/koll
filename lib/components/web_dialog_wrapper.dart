import 'package:flutter/material.dart';

class WebDialogWrapper extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double borderRadius;

  const WebDialogWrapper({
    super.key,
    required this.child,
    this.maxWidth = 400,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: child,
          ),
        ),
      ),
    );
  }
}
