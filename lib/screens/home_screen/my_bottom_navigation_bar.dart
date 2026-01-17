import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:iconsax/iconsax.dart';

import '../../styles.dart';
import 'home_screen.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final int index;
  final PageController pageController;
  final bool isWeb;
  final bool isKitchen;

  const MyBottomNavigationBar(
      {Key? key,
      required this.index,
      required this.pageController,
      this.isWeb = false,
      this.isKitchen = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showReadyState = !isKitchen;

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: GNav(
          onTabChange: (newIndex) {
            HomeScreen.index.value = newIndex;
            pageController.jumpToPage(newIndex);
          },
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          selectedIndex: index,
          tabMargin: EdgeInsets.symmetric(horizontal: isWeb ? 16 : 8.sp),
          textStyle: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontSize: isWeb ? 16 : 50.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white),
          rippleColor: Colors.white.withOpacity(0.3),
          hoverColor: Colors.white.withOpacity(0.5),
          haptic: true,
          tabBorderRadius: isWeb ? 12 : 30.sp,
          curve: Curves.easeInCubic,
          duration: const Duration(milliseconds: 400),
          gap: isWeb ? 8 : 15.sp,
          color: Colors.white.withOpacity(0.5),
          activeColor: Colors.white,
          iconSize: isWeb ? 24 : 80.sp,
          tabBackgroundColor: Colors.white.withOpacity(0.2),
          padding: EdgeInsets.symmetric(
              horizontal: isWeb ? 20 : 42.sp, vertical: isWeb ? 12 : 20.sp),
          tabs: [
            GButton(
                haptic: true,
                text: 'في الطريق',
                textStyle: TextStyling.headline.copyWith(
                    color: Colors.white, fontSize: isWeb ? 18 : 50.sp),
                icon: Icons.delivery_dining_outlined,
                leading: _buildBadge(context, "في الطريق",
                    Icons.delivery_dining_outlined, isWeb)),
            if (showReadyState)
              GButton(
                haptic: true,
                icon: Icons.restaurant_menu_rounded,
                text: 'جاهز',
                textStyle: TextStyling.headline.copyWith(
                    color: Colors.white, fontSize: isWeb ? 18 : 50.sp),
                leading: _buildBadge(
                    context, "جاهز", Icons.restaurant_menu_rounded, isWeb),
              ),
            GButton(
              haptic: true,
              icon: Iconsax.clock,
              text: 'عالنار',
              textStyle: TextStyling.headline
                  .copyWith(color: Colors.white, fontSize: isWeb ? 18 : 50.sp),
              leading: _buildBadge(context, "عالنار",
                  Icons.local_fire_department_outlined, isWeb),
            ),
            GButton(
              haptic: true,
              icon: Iconsax.receipt_2_1,
              text: 'الأوردرات',
              textStyle: TextStyling.headline
                  .copyWith(color: Colors.white, fontSize: isWeb ? 18 : 50.sp),
              leading: _buildBadge(
                  context, "عند الكاشير", Iconsax.receipt_2_1, isWeb),
            ),
          ]),
    );
  }

  Widget _buildBadge(
      BuildContext context, String state, IconData icon, bool isWeb) {
    return ValueListenableBuilder(
      valueListenable: streamValueNotifier,
      builder: (context, streamValue, child) => Badge(
        smallSize: isWeb ? 12 : 35.sp,
        largeSize: isWeb ? 12 : 35.sp,
        alignment: Alignment.topRight,
        backgroundColor: streamValue.any((element) => element.state == state)
            ? Colors.white
            : Colors.transparent,
        padding: EdgeInsets.symmetric(horizontal: isWeb ? 4 : 10.sp),
        label: FittedBox(
          child: Text(
            "${streamValue.where((element) => element.state == state).length}",
            style: TextStyling.subtitle.copyWith(
                fontSize: isWeb ? 12 : 32.sp,
                color: streamValue.any((element) => element.state == state)
                    ? primaryColor
                    : Colors.transparent,
                fontWeight: FontWeight.w500),
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: isWeb ? 24 : 80.sp,
        ),
      ),
    );
  }
}
