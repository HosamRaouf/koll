import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/styles.dart';

Future primaryBottomSheet(
    {bool showLeadingContainer = true,
      required Widget child,
      bool isDismissible = true,
      bool enableDrag = true,
      bool isTransparentBarrierColor = false,
      required BuildContext context
    }) async {
  return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,

      barrierColor: isTransparentBarrierColor
          ? Colors.transparent
          : const Color(0xff000000).withOpacity(.34),
      builder: (context) {
        return ScreenUtilInit(
          designSize: const Size(1080, 1920),
          builder: (context, widget) => GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: AnimatedContainer(
              width: 100.sw,
              duration: 100.milliseconds,
              margin: MediaQuery.of(context).viewInsets,
              decoration: BoxDecoration(
                color:backGroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.sp),
                  topRight: Radius.circular(32.sp),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    // height: 0.8.sh,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 12.r),
                            alignment: Alignment.center,
                            child: Container(
                              width: 26.sp,
                              height: 3.sp,
                              decoration: BoxDecoration(
                                color: smallFontColor,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            ),
                          ),
                          child
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        },
      );
}