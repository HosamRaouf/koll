import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_inkwell.dart';

import '../../../core/models/menu_models/item_model.dart';

class ImageWidget extends StatelessWidget {
  String url;
  ItemModel item;
  ImageWidget({super.key, required this.url, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 24.sp),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: SizedBox(
              width: 200.h,
              height: 200.h,
              child: Stack(
                children: [
                  SizedBox(
                      width: 200.h,
                      height: 200.h,
                      child: CachedAvatar(
                        imageUrl: url,
                      )),
                  MyInkWell(
                    radius: 24.sp,
                    onTap: () {
                      // ImageViewer.showImageSlider(
                      //   images: item.images,
                      // );
                      // Navigator.of(context).push(ScaleTransition5(MyImageViewer(images: images, index: index)));
                    },
                    child: SizedBox(
                      width: 200.h,
                      height: 200.h,
                    ),
                  ),
                ],
              ))),
    );
  }
}
