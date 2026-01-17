import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles.dart';
import 'my_inkwell.dart';

class MyIconButton extends StatefulWidget {
  IconData icon;
  Function() onTap;
  double size;
  MyIconButton({super.key, required this.icon, required this.onTap, required this.size});

  @override
  State<MyIconButton> createState() => _MyIconButtonState();
}

class _MyIconButtonState extends State<MyIconButton> {
  @override
  Widget build(BuildContext context) {
    return ClipOval(child: Container(
      decoration:  BoxDecoration(
            gradient: myGradient
        ),
      child: MyInkWell(
        onTap: () {
          widget.onTap();
        },
        radius: 20.r,
        child: Padding(
            padding: EdgeInsets.all(widget.size),
            child: Icon(widget.icon, color: Colors.white, size: 2*widget.size,),
          ),
      ),
    ))
    ;
  }
}
