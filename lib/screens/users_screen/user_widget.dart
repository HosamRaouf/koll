import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/core/models/user_models/user_model.dart';
import 'package:kol/screens/users_screen/user_profile/user_profile_screen.dart';

import '../../components/my_inkwell.dart';
import '../../navigation_animations.dart';
import '../../styles.dart';

class UserWidget extends StatelessWidget {
  final UserModel user;

  const UserWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.sp),
      child: FittedBox(
        child: Container(
          decoration: cardDecoration,
          child: MyInkWell(
            onTap: () {
              FocusScope.of(context).unfocus();
              Navigator.push(
                  context,
                  ScaleTransition5(UserProfile(
                    user: user,
                  )));
            },
            radius: 24.r,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                user.imageUrl != 'assets/images/user.png'
                    ? SizedBox(
                        height: 200.h,
                        width: 0.375.sw,
                        child: Padding(
                          padding: EdgeInsets.all(12.sp),
                          child: CachedAvatar(
                            imageUrl: user.imageUrl,
                            fit: BoxFit.cover,
                            borderRadius: 18.r,
                          ),
                        ))
                    : Container(
                        color: primaryColor.withOpacity(0.2),
                        child: SizedBox(
                            height: 200.h,
                            width: 0.375.sw,
                            child: Image.asset('assets/images/user.png')),
                      ),
                Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: SizedBox(
                    width: 0.32.sw,
                    child: Text(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontSize: 36.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
