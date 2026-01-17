import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/animated_components/animated_listview.dart';
import 'package:kol/components/back_arrow_button.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/phone_number.dart';
import 'package:kol/components/pop_up_menu.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/core/models/driver_model.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/drivers_screen/add_driver_modal_bottom_sheet.dart';
import 'package:kol/screens/drivers_screen/driver_profile/driver_rating.dart';
import 'package:kol/screens/drivers_screen/driver_profile/driver_tab_bar.dart';
import 'package:kol/screens/drivers_screen/drivers_screen.dart';
import 'package:kol/screens/drivers_screen/logic.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/home_screen/order_widget/order.dart';
import 'package:kol/styles.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';

import '../../../components/show_snack_bar.dart';
import '../../../map.dart';
import '../../no_internet_screen.dart';

class DriverProfile extends StatefulWidget {
  final DriverModel driver;
  static double containerHeight = 0.72.sh;

  const DriverProfile({
    super.key,
    required this.driver,
  });

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile>
    with TickerProviderStateMixin {
  @override
  void initState() {
    widget.driver.orders.clear();
    for (var element in restaurantData.finishedOrders) {
      if (element.driverId == widget.driver.firestoreId) {
        widget.driver.orders.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabBarController =
        TabController(length: 2, vsync: this, initialIndex: 1);

    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) {
          return SafeArea(
              child: Scaffold(
            body: InternetCheck(
                child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 0.25.sh,
                  flexibleSpace: FlexibleSpaceBar(
                    background:
                        appBar(context, widget.driver, () => setState(() {})),
                  ),
                ),
                AdaptiveHeightSliverPersistentHeader(
                    child: header(context, widget.driver)),
                AdaptiveHeightSliverPersistentHeader(
                    child: DriverTabBar(
                        tabBarController: tabBarController,
                        driver: widget.driver)),
                SliverList.list(children: [
                  tabBarView(tabBarController, widget.driver, context),
                ])
              ],
            )),
          ));
        });
  }
}

Widget appBar(BuildContext context, DriverModel driver, Function onAddDriver) {
  return Stack(
    children: [
      driver.image != 'assets/images/user.png'
          ? SizedBox(
              height: 0.25.sh,
              width: double.infinity,
              child: CachedAvatar(
                imageUrl: driver.image,
                borderRadius: 0,
                fit: BoxFit.fitHeight,
              ),
            )
          : Container(
              color: warmColor,
              height: 0.25.sh,
              width: double.infinity,
              child: Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Image.asset("assets/images/delivery.png"))),
      Padding(
        padding: EdgeInsets.all(40.sp),
        child: const Align(
            alignment: Alignment.topRight, child: BackArrowButton()),
      ),
      Padding(
        padding: EdgeInsets.all(40.sp),
        child: MyPopUpMenu(
          options: [
            {
              'option': 'تعديل',
              'icon': Iconsax.edit,
              'textColor': backGroundColor,
              'onPressed': () {
                primaryBottomSheet(
                    child: AddDriver(
                        onAdd: () {
                          onAddDriver();
                        },
                        addOrEdit: false,
                        driver: driver),
                    context: context);
              },
            },
            {
              'option': 'حذف',
              'icon': Iconsax.trash,
              'textColor': Colors.red,
              'onPressed': () {
                showDeleteDriverDialog(context, driver, (driver) async {
                  Navigator.pushAndRemoveUntil(
                      context,
                      ScaleTransition5(const HomeScreen(
                        isKitchen: false,
                      )),
                      (route) => false);
                  Navigator.push(
                      context, ScaleTransition5(const DriversScreen()));
                  showSnackBar(
                      context: context, message: 'تم حذف ${driver.name} بنجاح');
                });
              },
            },
          ],
          iconColor: Colors.white,
          color: primaryColor,
        ),
      ),
    ],
  );
}

Widget header(
  BuildContext context,
  DriverModel driver,
) {
  return Container(
    color: backGroundColor,
    child: Padding(
      padding: EdgeInsets.all(40.sp),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PhoneNumber(
            phoneNumber: driver.phoneNumber,
          ).animate().moveX(
              duration: const Duration(milliseconds: 500), curve: Curves.ease),
          SizedBox(
            width: 0.65.sw,
            child: Text(
              textDirection: TextDirection.rtl,
              driver.name,
              style: Theme.of(context)
                  .textTheme
                  .displayLarge!
                  .copyWith(fontSize: 72.sp, color: primaryColor),
            ),
          ).animate().moveX(
              duration: const Duration(milliseconds: 500), curve: Curves.ease),
        ],
      ),
    ),
  );
}

Widget tabBarView(
    TabController tabBarController, DriverModel driver, BuildContext context) {
  driver.rates.sort((a, b) =>
      myDateTimeFormat.parse(b.time).compareTo(myDateTimeFormat.parse(a.time)));
  driver.orders.sort((a, b) =>
      myDateTimeFormat.parse(b.time).compareTo(myDateTimeFormat.parse(a.time)));
  return Container(
    color: warmColor,
    height: 0.75.sh,
    child: TabBarView(controller: tabBarController, children: [
      driver.rates.isEmpty
          ? Center(
              child: Text(
                'لا يوجد تقييمات',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: primaryColor, fontSize: 40.sp),
              )
                  .animate()
                  .scale(
                      delay: const Duration(milliseconds: 250),
                      duration: const Duration(milliseconds: 250))
                  .shake(
                      delay: const Duration(milliseconds: 1000),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.bounceOut),
            )
          : MyListViewAnimation(
              length: driver.rates.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 24.sp, bottom: 24.sp, left: 40.sp, right: 40.sp),
                  child: DriverRating(rating: driver.rates[index]),
                );
              }),
      driver.orders.isEmpty
          ? Center(
              child: Text(
                'لا يوجد أوردرات',
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: primaryColor, fontSize: 40.sp),
              )
                  .animate()
                  .scale(
                      delay: const Duration(milliseconds: 750),
                      duration: const Duration(milliseconds: 250))
                  .shake(
                      delay: const Duration(milliseconds: 1250),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.bounceOut),
            )
          : MyListViewAnimation(
              length: driver.orders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                      top: 24.sp, bottom: 24.sp, left: 40.sp, right: 40.sp),
                  child: FutureBuilder(
                      future: fetchUser(driver.orders[index].userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Padding(
                            padding: EdgeInsets.all(24.sp),
                            child: Container(
                              width: double.infinity,
                              height: 0.2.sh,
                              decoration: cardDecoration,
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: 100.h,
                                      width: 100.h,
                                      child: CircularProgressIndicator(
                                        color: primaryColor,
                                      )),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  Text(
                                    "جاري التحميل",
                                    style: TextStyling.headline.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 42.sp),
                                  ).animate(onComplete: (controller) {
                                    controller.animateBack(0).then(
                                        (value) => controller.animateBack(1));
                                  }).fade(
                                      duration:
                                          const Duration(milliseconds: 400),
                                      curve: Curves.fastEaseInToSlowEaseOut),
                                ],
                              )),
                            ),
                          );
                        } else {
                          return Order(
                              user: snapshot.data!,
                              order: driver.orders[index],
                              onOrderAccepted: () {},
                              onOrderSubmit: (order, driver) {},
                              onOrderCompleted: () {},
                              isDriverOrder: true,
                              onDelete: (body) {});
                        }
                      }),
                );
              }),
    ]),
  );
}
