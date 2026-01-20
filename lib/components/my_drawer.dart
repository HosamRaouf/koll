import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_messaging/getToken.dart';
import 'package:kol/core/models/area_poly_marker_model.dart';
import 'package:kol/core/models/restaurant_model.dart';
import 'package:kol/core/shared_preferences/removePreference.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/drivers_screen/drivers_screen.dart';
import 'package:kol/screens/finished_orderes_screen/finished_orderes_screen.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/home_screen/logic.dart';
import 'package:kol/screens/login_screen/login_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';
import 'package:kol/screens/users_screen/logic.dart';
import 'package:kol/screens/users_screen/users_screen.dart';

import '../core/firebase_auth/signOut.dart';
import '../navigation_animations.dart';
import '../screens/offers_vouchers_screen/offers_vouchers_screen.dart';
import '../styles.dart';
import 'drawer_screen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isDesktop = MediaQuery.of(context).size.width >= 1100;
    // We can also pass 'isDesktop' as 'isWeb' if that matches the web trigger,
    // or use kIsWeb if we want strict platform check.
    // Given the context, isDesktop seems to be the trigger for "Web Layout".
    return Container(
      width: isDesktop
          ? double.infinity
          : (kIsWeb
              ? (MediaQuery.of(context).size.width * 0.9).clamp(0.0, 400.0)
              : 0.9.sw),
      color: primaryColor, // Changed to primaryColor
      child: isDesktop
          ? DrawerContent(isWeb: isDesktop)
          : DrawerContent(isWeb: isDesktop),
    );
  }
}

class DrawerContent extends StatelessWidget {
  final bool isWeb;
  const DrawerContent({Key? key, this.isWeb = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          children: [
            SizedBox(
                height: isWeb ? 200 : 0.25.sh,
                width: double.infinity,
                child: Container(
                  color: Colors.white, // White background for the image
                  child: CachedAvatar(
                    imageUrl: restaurantData.image,
                    fit: BoxFit.cover,
                    borderRadius: 0,
                  ),
                )),
            SizedBox(
                height: isWeb ? 200 : 0.25.sh,
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  )),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: isWeb ? 16 : 40.0.sp, vertical: 12.sp),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: isWeb ? 60 : 120.h,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(
                                        restaurantData.specials.length,
                                        (index) => Padding(
                                              padding: EdgeInsets.only(
                                                  left: isWeb ? 8 : 18.sp),
                                              child: SizedBox(
                                                  height: isWeb ? 25 : 50.sp,
                                                  width: isWeb ? 25 : 50.sp,
                                                  child: Image.asset(
                                                      restaurantData
                                                          .specials[index])),
                                            )),
                                  ),
                                  SizedBox(
                                    width: isWeb ? 12 : 24.sp,
                                  ),
                                  Flexible(
                                    // Use Flexible to prevent overflow
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        restaurantData.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                                textBaseline:
                                                    TextBaseline.ideographic,
                                                color: Colors.white,
                                                fontSize: isWeb ? 24 : 96.sp),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )),
                  ),
                )),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Styling DrawerScreen items might be needed too, but they use 'DrawerScreen' widget.
                // Assuming DrawerScreen inherits styles or we need to wrap it/modify it.
                // Since I can't modify DrawerScreen easily without seeing it (it's imported),
                // I'll assume I should modify the DrawerScreen generic component or wrap these.
                // But wait, the user said "change ... texts and icons to be in white".
                // I'll verify DrawerScreen code if I can, but I don't have it open.
                // Proceeding with what I have and potentially editing DrawerScreen later if needed.
                // For now, I will modify MyDrawer to pass white color context or rely on Theme?
                // Actually, I can wrap the Column in a Theme or IconTheme.
                Theme(
                  data: Theme.of(context).copyWith(
                    iconTheme: const IconThemeData(color: Colors.white),
                    textTheme: Theme.of(context).textTheme.apply(
                        bodyColor: Colors.white, displayColor: Colors.white),
                  ),
                  child: Column(
                    children: [
                      DrawerScreen(
                          icon: Iconsax.user,
                          label: 'الملف الشخصي',
                          onTap: () {
                            Navigator.of(context).push(
                                SlideTransition1(const RestaurantScreen()));
                          }),
                      DrawerScreen(
                          icon: Icons.delivery_dining_rounded,
                          label: 'الطيارين',
                          onTap: () {
                            Navigator.of(context)
                                .push(SlideTransition1(const DriversScreen()));
                          }),
                      DrawerScreen(
                          icon: Iconsax.profile_2user,
                          label: 'العملاء',
                          onTap: () {
                            Navigator.of(context)
                                .push(SlideTransition1(const UsersScreen()));
                          }),
                      DrawerScreen(
                          icon: Iconsax.discount_shape,
                          label: 'العروض والكوبونات',
                          onTap: () {
                            Navigator.of(context).push(
                                SlideTransition1(const OffersVouchersScreen()));
                          }),
                      DrawerScreen(
                          icon: Iconsax.tick_square,
                          label: 'الأوردرات المنتهية',
                          onTap: () {
                            Navigator.of(context).push(
                                SlideTransition1(const FinishedOrdersScreen()));
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: isWeb ? 20 : 0.05.sh),
            child: Material(
              color: Colors.transparent, // Transparent to show primaryColor bg
              child: InkWell(
                onTap: () {
                  signOut(
                    onError: (e) {
                      print(e.code);
                      showSnackBar(context: context, message: e.code);
                      Navigator.of(context).pop();
                    },
                    onComplete: () async {
                      removePreference(key: "email");
                      removePreference(key: "password");
                      removePreference(key: "restaurant");
                      List<String> tokens = [];
                      for (var element in restaurantData.tokens) {
                        tokens.add(element);
                      }

                      getToken().then((value) =>
                          {print(value), tokens.remove(value), print(tokens)});
                      try {
                        print(
                            "================================================ 🔐📡 Removing token 📡🔐 ==========================================");
                        await restaurantDocument.update({"tokens": tokens});
                        print(
                            "================================================ 🔐✅ Token Removed ✅🔐 ==========================================");
                      } catch (E) {
                        print(
                            "================================================ 🔐❌ Error removing token ❌🔐 ==========================================");
                        print(E);
                      }
                      reviews = [];
                      allUsers = [];
                      users = [];
                      orders = [];
                      ordersUsers = [];
                      userWidgets = [];
                      streamValueNotifier.value = [];
                      streamValueNotifier.notifyListeners();
                      restaurant = {};
                      restaurantData = RestaurantModel(
                          id: "",
                          name: "",
                          email: "",
                          image: "",
                          address: "",
                          number: "",
                          workingDays: [],
                          location: AreaPolyMarkerModel(long: 0, lat: 0),
                          bannedUsers: [],
                          tokens: [],
                          areas: [],
                          specials: [],
                          rating: "",
                          menu: [],
                          drivers: [],
                          offers: [],
                          waitingOrders: [],
                          finishedOrders: [],
                          vouchers: [],
                          rates: [],
                          color: "");
                      Navigator.of(context).pushAndRemoveUntil(
                        SizeRTLNavigationTransition(const LoginScreen()),
                        (route) => false,
                      );
                      Future.delayed(const Duration(milliseconds: 100))
                          .then((value) => SystemNavigator.pop());
                    },
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 20.sp, horizontal: 0.05.sw),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        FontAwesomeIcons.arrowRightFromBracket,
                        color: Colors.white, // White icon
                        size: isWeb ? 24 : 85.sp,
                      ),
                      Text(
                        'تسجيل الخروج',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayLarge?.copyWith(
                                fontSize: isWeb ? 16 : 55.sp,
                                color: Colors.white, // White text
                                fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
