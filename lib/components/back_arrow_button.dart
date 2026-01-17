import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';

import '../styles.dart';

class BackArrowButton extends StatelessWidget {
  const BackArrowButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 120.h,
        height: 120.h,
        child: ClipOval(
          child: Material(
            color: primaryColor,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Iconsax.arrow_right_14,
                  color: Colors.white, size: 72.sp),
              splashColor: backGroundColor.withOpacity(0.5),
              splashRadius: 64.sp,
            ),
          ),
        ));
  }
}
