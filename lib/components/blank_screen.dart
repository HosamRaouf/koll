import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../screens/no_internet_screen.dart';
import '../styles.dart';
import 'back_arrow_button.dart';

class BlankScreen extends StatefulWidget {
  String title;
  Widget child;
  BlankScreen({super.key, required this.title, required this.child});

  @override
  State<BlankScreen> createState() => _BlankScreenState();
}

class _BlankScreenState extends State<BlankScreen> {
  @override
  Widget build(BuildContext context) {
    return InternetCheck(
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/icons.png")),
              gradient: LinearGradient(
                colors: [primaryColor, accentColor],
              )),
          child: Stack(
            children: [
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 40.sp, vertical: 24.sp),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 62.h,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 40.sp,
                    ),
                    const BackArrowButton()
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(0, -16.sp),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.r + 25.sp)),
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                        color: backGroundColor,
                        height: 0.87.sh,
                        width: double.infinity,
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
