

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../styles.dart';

class MyCheckBox extends StatefulWidget {
  bool checkBox;
  Function() onChanged;
  MyCheckBox({super.key, required this.checkBox, required this.onChanged});

  @override
  State<MyCheckBox> createState() => _MyCheckBoxState();
}

class _MyCheckBoxState extends State<MyCheckBox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75.sp,
      width: 75.sp,
      child: Checkbox(
          shape:
          RoundedRectangleBorder(
              borderRadius:
              BorderRadius
                  .circular(
                  4)),
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.all(primaryColor),
          value: widget.checkBox,
          onChanged: (value) {
            setState(() {
              widget.checkBox = value!;
              print(value);
              widget.onChanged();
            });
          }),
    );
  }
}
