
import 'package:flutter/cupertino.dart';

import '../styles.dart';

class MyScrollConfigurations extends StatelessWidget {
  Widget child;
  bool horizontal;
  MyScrollConfigurations({super.key, required this.child, required this.horizontal});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: horizontal? AxisDirection.left : AxisDirection.down,
          color: primaryColor,
          child: child,
        ));
  }
}
