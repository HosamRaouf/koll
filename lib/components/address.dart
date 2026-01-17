import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../styles.dart';

class Address extends StatelessWidget {
  String address;
  Address({Key? key, required this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(right: 40.sp),
          child: SizedBox(
            width: 0.55.sw,
            child: Text(
              address,
              maxLines: 2,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 30.sp,
                  color: primaryColor,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
        Icon(
          FontAwesomeIcons.locationDot,
          size: 40.sp,
          color: primaryColor,
        ),
      ],
    );
  }
}
