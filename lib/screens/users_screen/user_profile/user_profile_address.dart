import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../../components/my_icon_button.dart';
import '../../../core/models/user_models/location_model.dart';
import '../../../styles.dart';

class UserAddress extends StatefulWidget {
  UserAddress({super.key, required this.location});

  LocationModel location;

  @override
  State<UserAddress> createState() => _UserAddressState();
}

class _UserAddressState extends State<UserAddress> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment
          .spaceBetween,
      children: [
        MyIconButton(
          size: 24.sp,
            icon: Iconsax
                .location,
            onTap:
                () {
                  launchUrlString(
                      "https://maps.google.com/?q=${widget.location.long},${widget.location.lat}");              }),
        Padding(
          padding: EdgeInsets.only(right: 32.sp),
          child: Text(widget.location.name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 42.sp, color: primaryColor, fontWeight: FontWeight.w600),),
        ),
      ],
    );
  }
}
