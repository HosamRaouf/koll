import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../styles.dart';
import 'back_arrow_button.dart';

class PoppableScreen extends StatelessWidget {
  PoppableScreen({super.key, required this.child});

  Widget child;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) {
          return SafeArea(
            child: Container(
              decoration:   BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, accentColor],
                  )),
              child: Stack(
                children: [
                  Transform.translate(
                    offset: Offset(0, -16.sp),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(50.r)),
                            child: Container(color: backGroundColor, height: 0.86.sh, width: double.infinity, child: child,))),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'بيتزا',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 75.h,
                            color: Colors.white),
                      ),
                      const BackArrowButton()
                    ],
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}
