

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'my_icon_button.dart';

class PhoneNumber extends StatefulWidget {
  PhoneNumber({super.key, required this.phoneNumber});

  String phoneNumber;

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment
          .spaceBetween,
      children: [
        Row(
          children: [
            MyIconButton(
              size: 24.sp,
                icon: Iconsax
                    .call,
                onTap:
                    () {
                      launchUrlString("tel://${widget.phoneNumber}");
                    }),
            SizedBox(width: 36.sp,),
            MyIconButton(
              size: 24.sp,
                icon: FontAwesomeIcons.whatsapp,
                onTap:
                    () {
                      launch(
                          "https://wa.me/+02${widget.phoneNumber}?text=");
                    }),
          ],
        ),
      ],
    );
  }
}
