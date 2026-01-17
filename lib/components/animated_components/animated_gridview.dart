import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyGridViewAnimation extends StatelessWidget {
  final int length;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double childAspectRatio;
  final int crossAxisCount;

  const MyGridViewAnimation({
    super.key,
    required this.length,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    required this.childAspectRatio,
  });

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
