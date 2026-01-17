import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';



class MyListViewAnimation extends StatelessWidget {

  int length;
  Widget Function(BuildContext context, int index) itemBuilder;

  MyListViewAnimation({super.key, required this.length, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return AnimationLimiter(
      child: ListView.builder(
        physics:
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        itemCount: length,
        itemBuilder: itemBuilder
      ),
    );
  }
}


class MyListViewAnimationConfigurations extends StatelessWidget {

  int index;
  Widget child;
  MyListViewAnimationConfigurations({super.key, required this.child, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: const Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: const Duration(milliseconds: 2500),
        curve: Curves.fastLinearToSlowEaseIn,
        child: FadeInAnimation(
          curve: Curves.fastLinearToSlowEaseIn,
          duration: const Duration(milliseconds: 2500),
          child: child,
        ),
      ),
    );
  }
}

