

import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/cachedAvatar.dart';
import '../../../styles.dart';

class ImageViewerImage extends StatefulWidget {

  int index;
  bool isSelected;
  String image;
  PageController controller;

  ImageViewerImage({super.key, required this.index, required this.image, required this.isSelected, required this.controller});

  @override
  State<ImageViewerImage> createState() => _ImageViewerImageState();
}

class _ImageViewerImageState extends State<ImageViewerImage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.sp),
      child: Container(
        height: 150.h,
        width: 150.h,
        decoration: cardDecoration.copyWith(color: widget.isSelected? primaryColor : warmColor),
        child: Padding(
          padding: EdgeInsets.all(6.sp),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(24.r),
              child: CachedAvatar(
                  imageUrl: widget.image)),
        ),
      ),
    );
  }
}
