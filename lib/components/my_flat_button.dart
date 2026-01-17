import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles.dart';

class MyFlatButton extends StatefulWidget {
  var onPressed;
  String hint;
  Color backgroundColor = Colors.transparent;
  double fontSize;
  Color textColor;

  MyFlatButton(
      {super.key,
      required this.onPressed,
      required this.hint,
      required this.backgroundColor,
      required this.fontSize,
      required this.textColor});

  @override
  State<MyFlatButton> createState() => _MyFlatButtonState();
}

class _MyFlatButtonState extends State<MyFlatButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: TextButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(widget.backgroundColor),
            overlayColor:
                MaterialStateProperty.all(primaryColor.withOpacity(0.2)),
          ),
          onPressed: () {
            widget.onPressed();
          },
          child: Padding(
            padding: EdgeInsets.all(12.sp),
            child: Text(
              widget.hint,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  fontSize: widget.fontSize,
                  fontWeight: FontWeight.w700,
                  color: widget.textColor),
            ),
          )),
    );
  }
}
