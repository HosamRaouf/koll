import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_alert_dialog.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/showLoading.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/home_screen/order_widget/order.dart';
import 'package:kol/screens/restaurant_screen/reviews/review.dart';
import 'package:kol/screens/users_screen/user_profile/logic.dart';
import 'package:kol/screens/users_screen/user_profile/send_voucher_popup.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../components/back_arrow_button.dart';
import '../../../components/pop_up_menu.dart';
import '../../../core/models/user_models/location_model.dart';
import '../../../core/models/user_models/user_model.dart';
import '../../../styles.dart';
import '../../no_internet_screen.dart';

ban(UserModel user) async {
  List<String> bannedUsers = [];
  for (var element in restaurantData.bannedUsers) {
    bannedUsers.add(element);
  }
  bannedUsers.add(user.firestoreId);
  print(
      "================================================ ⛔🛰️ Banning ${user.name} 🛰️⛔ ==========================================");
  try {
    await restaurantDocument.update({"bannedUsers": bannedUsers});
    await restaurantDocument
        .collection("orders")
        .where("userId", isEqualTo: user.firestoreId)
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.data()["userId"] == user.firestoreId
            ? element.reference.delete()
            : false;
        restaurantData.finishedOrders
            .removeWhere((element) => element.userId == user.firestoreId);
      }
    });
    print(
        "================================================ ⛔✅ ${user.name} Banned ✅⛔ ==========================================");
    restaurantData.bannedUsers.add(user.firestoreId);
    users.remove(user);
  } catch (e) {
    print(
        "================================================ ⛔❌ Error Banning ${user.name} ❌⛔ ==========================================");
    print(e);
  }
}

class UserProfile extends StatefulWidget {
  UserModel user;

  UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with TickerProviderStateMixin {
  @override
  void initState() {
    buildOrders(widget.user);
    super.initState();
  }

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    TabController tabBarController =
        TabController(length: 2, vsync: this, initialIndex: 1);
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) {
          restaurantData.finishedOrders.sort((a, b) => myDateTimeFormat
              .parse(b.time)
              .compareTo(myDateTimeFormat.parse(a.time)));
          reviews.sort((a, b) => myDateTimeFormat
              .parse(b.time)
              .compareTo(myDateTimeFormat.parse(a.time)));
          return SafeArea(
            child: Scaffold(
              body: InternetCheck(
                  child: Material(
                color: warmColor,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      expandedHeight: 0.25.sh,
                      backgroundColor: backGroundColor,
                      flexibleSpace: FlexibleSpaceBar(
                        background: userImage(widget.user, context),
                      ),
                    ),
                    AdaptiveHeightSliverPersistentHeader(
                        pinned: true, child: header(widget.user)),
                    SliverToBoxAdapter(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: 1.sw,
                          color: backGroundColor,
                          child: Padding(
                            padding: EdgeInsets.only(right: 40.sp),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 24.sp,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Iconsax.star1,
                                      color: primaryColor,
                                      size: 52.sp,
                                    ),
                                    SizedBox(
                                      width: 40.sp,
                                    ),
                                    Text(
                                      "التقييمات",
                                      style: TextStyling.headline
                                          .copyWith(fontSize: 52.sp),
                                    ),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: List.generate(
                                        reviews
                                            .where((element) =>
                                                element.userId ==
                                                widget.user.firestoreId)
                                            .toList()
                                            .length,
                                        (index) => Padding(
                                              padding:
                                                  EdgeInsets.only(left: 24.sp),
                                              child: Rating(
                                                  rate: reviews
                                                      .where((element) =>
                                                          element.userId ==
                                                          widget
                                                              .user.firestoreId)
                                                      .toList()[index]),
                                            )).reversed.toList(),
                                  ),
                                ),
                                SizedBox(
                                  height: 24.sp,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    AdaptiveHeightSliverPersistentHeader(
                      pinned: true,
                      child: Container(
                        color: backGroundColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 24.sp, horizontal: 40.sp),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.list_alt,
                                color: primaryColor,
                                size: 52.sp,
                              ),
                              SizedBox(
                                width: 40.sp,
                              ),
                              Text(
                                "الأوردرات (${widget.user.finishedOrders.where((element) => element.restaurantId == restaurantData.id).length})",
                                style: TextStyling.headline.copyWith(
                                    fontSize: 52.sp, color: primaryColor),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverList.list(
                        children: List.generate(
                            widget.user.finishedOrders
                                .where((element) =>
                                    element.restaurantId == restaurantData.id)
                                .length, (index) {
                      return Order(
                          order: widget.user.finishedOrders
                              .where((element) =>
                                  element.restaurantId == restaurantData.id)
                              .toList()[index],
                          onOrderAccepted: () {},
                          onOrderSubmit: (order, driver) {},
                          onOrderCompleted: () {},
                          isDriverOrder: false,
                          user: widget.user,
                          onDelete: (body) {});
                    }).reversed.toList())
                  ],
                ),
              )),
            ),
          );
        });
  }
}

Widget userImage(UserModel user, BuildContext context) {
  return SizedBox(
    height: 25.sh,
    child: Stack(
      children: [
        Container(
          color: primaryColor.withOpacity(0.2),
          child: SizedBox(
            height: 0.25.sh,
            child: Stack(
              children: [
                user.imageUrl != 'assets/images/user.png'
                    ? SizedBox(
                        height: 0.25.sh,
                        width: double.infinity,
                        child: CachedAvatar(
                          imageUrl: user.imageUrl,
                          fit: BoxFit.cover,
                          borderRadius: 0,
                        ))
                    : SizedBox(
                        height: 0.25.sh,
                        width: double.infinity,
                        child: Image.asset(
                          'assets/images/user.png',
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        )),
                Padding(
                  padding: EdgeInsets.all(40.sp),
                  child: MyPopUpMenu(
                    options: [
                      {
                        "option": "إرسال إشعار",
                        "onPressed": () {
                          showDialog(
                              context: context,
                              builder: (context) => SendVoucher(
                                    user: user,
                                  ));
                        },
                        "icon": Iconsax.notification,
                        "textColor": backGroundColor
                      },
                      {
                        "option": "حظر",
                        "onPressed": () {
                          showDialog(
                              context: context,
                              builder: (context) => MyAlertDialog(
                                  controller: TextEditingController(),
                                  description:
                                      "مطعمك مش هيبان لـ  ${user.name}",
                                  textfield: false,
                                  title: "حظر",
                                  body: Container(),
                                  firstButton: "حظر",
                                  secondButton: "إلغاء",
                                  onFirstButtonPressed: () async {
                                    showLoading(context);
                                    await ban(user);
                                    Navigator.pushReplacement(
                                        context,
                                        SizeRTLNavigationTransition(
                                            const HomeScreen(
                                          isKitchen: false,
                                        )));
                                    showSnackBar(
                                        context: context,
                                        message:
                                            "⛔ ${user.name} خد الحظر المتين ⛔");
                                  },
                                  onSecondButtonPressed: () {},
                                  isFirstButtonRed: true));
                        },
                        "icon": Iconsax.danger,
                        "textColor": Colors.red
                      }
                    ],
                    iconColor: Colors.white,
                    color: primaryColor,
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(24.sp),
          child: const Align(
              alignment: Alignment.topRight, child: BackArrowButton()),
        ),
      ],
    ),
  );
}

Widget phoneNumber(String phoneNumber) {
  return Padding(
    padding: EdgeInsets.only(left: 12.sp),
    child: Container(
      decoration: cardDecoration.copyWith(
          gradient: myGradient,
          image: const DecorationImage(
              image: AssetImage("assets/images/icons2.png"),
              fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp),
        child: Row(
          children: [
            SizedBox(
              width: 12.sp,
            ),
            Text(
              phoneNumber,
              style: TextStyling.subtitle.copyWith(
                  color: backGroundColor,
                  fontSize: 42.sp,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              width: 24.sp,
            ),
            MyInkWell(
              radius: 100.h,
              onTap: () {
                launch("https://wa.me/+02$phoneNumber?text=");
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 24.sp),
                child: Icon(
                  FontAwesomeIcons.whatsapp,
                  color: backGroundColor,
                  size: 52.sp,
                ),
              ),
            ),
            SizedBox(
              width: 24.sp,
            ),
            MyInkWell(
              radius: 100.h,
              onTap: () {
                launchUrlString("tel://$phoneNumber");
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 24.sp),
                child: Icon(
                  FontAwesomeIcons.phone,
                  color: backGroundColor,
                  size: 42.sp,
                ),
              ),
            ),
            SizedBox(
              width: 12.sp,
            )
          ].reversed.toList(),
        ),
      ),
    ),
  );
}

Widget location(LocationModel location) {
  return Padding(
    padding: EdgeInsets.only(left: 12.sp),
    child: Container(
      decoration: cardDecoration.copyWith(
          gradient: myGradient,
          image: const DecorationImage(
              image: AssetImage("assets/images/icons2.png"),
              fit: BoxFit.cover)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 6.sp),
        child: Row(
          children: [
            SizedBox(
              width: 12.sp,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  location.name,
                  style: TextStyling.subtitle.copyWith(
                      color: backGroundColor,
                      fontSize: 42.sp,
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  width: 0.3.sw,
                  child: Text(
                    location.address,
                    overflow: TextOverflow.ellipsis,
                    textDirection: TextDirection.rtl,
                    style: TextStyling.smallFont.copyWith(
                      fontSize: 36.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 24.sp,
            ),
            MyInkWell(
              radius: 100.h,
              onTap: () {
                launchUrlString(
                    "https://maps.google.com/?q=${location.lat},${location.long}");
              },
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.sp, vertical: 24.sp),
                child: Icon(
                  FontAwesomeIcons.locationDot,
                  color: backGroundColor,
                  size: 52.sp,
                ),
              ),
            ),
            SizedBox(
              width: 12.sp,
            )
          ].reversed.toList(),
        ),
      ),
    ),
  );
}

Widget header(UserModel user) {
  return Container(
    color: backGroundColor,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.all(40.sp),
          child: Text(
            user.name,
            style: TextStyling.headline.copyWith(fontSize: 62.sp),
          ),
        ),
        SizedBox(
          height: 24.sp,
        ),
        Padding(
          padding: EdgeInsets.only(right: 40.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.phone,
                color: primaryColor,
                size: 72.sp,
              ),
              SizedBox(
                width: 24.sp,
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(user.phoneNumbers.length,
                        (index) => phoneNumber(user.phoneNumbers[index])),
                  ),
                ),
              )
            ].reversed.toList(),
          ),
        ),
        SizedBox(
          height: 24.sp,
        ),
        Padding(
          padding: EdgeInsets.only(right: 40.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.location_on,
                color: primaryColor,
                size: 72.sp,
              ),
              SizedBox(
                width: 24.sp,
              ),
              Expanded(
                child: SingleChildScrollView(
                  reverse: true,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(user.locations.length,
                        (index) => location(user.locations[index])),
                  ),
                ),
              )
            ].reversed.toList(),
          ),
        ),
        SizedBox(
          height: 40.sp,
        ),
      ],
    ),
  );
}
