import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';

class MyImage extends StatefulWidget {
  String image;
  double width;
  double height;

  MyImage(
      {super.key,
      required this.width,
      required this.height,
      required this.image});

  @override
  State<MyImage> createState() => _MyImageState();
}

class _MyImageState extends State<MyImage> {
  @override
  Widget build(BuildContext context) {
    return widget.image != 'assets/images/user.png'
        ? SizedBox(
            height: widget.height,
            width: widget.width,
            child: CachedAvatar(
              imageUrl: widget.image,
              fit: BoxFit.cover,
              borderRadius: 150.sp,
            ),
          )
        : SizedBox(
            height: widget.height,
            width: widget.width,
            child: Image.asset(
              'assets/images/user.png',
              fit: BoxFit.contain,
              alignment: Alignment.topCenter,
            ));
  }
}
