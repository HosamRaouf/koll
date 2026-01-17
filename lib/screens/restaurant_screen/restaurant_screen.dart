import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart' as intl;
import 'package:kol/components/back_arrow_button.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_flat_button.dart';
import 'package:kol/components/pop_up_menu.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/core/firebase_storage/uploadImage.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/core/pickImage.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/login_screen/forget_password_modelsheet_body.dart';
import 'package:kol/screens/restaurant_screen/most_ordered/most_ordered.dart';
import 'package:kol/screens/restaurant_screen/offers/offers_image_slider.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/areas_screen/areas_screen.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/color_picker/color_picker.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/working_hours/working_hours_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_header.dart';
import 'package:kol/screens/restaurant_screen/restaurant_modal_bottom_sheet.dart';
import 'package:kol/screens/restaurant_screen/restaurant_web_layout.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews.dart';
import 'package:kol/styles.dart';
import 'package:persistent_header_adaptive/persistent_header_adaptive.dart';
import 'package:uuid/uuid.dart';

import '../../components/loading.dart';
import '../../core/models/restaurant_model.dart';
import '../../navigation_animations.dart';
import '../no_internet_screen.dart';
import 'logic.dart';

List<Map<String, dynamic>> getShifts(RestaurantModel restaurant) {
  List<Map<String, dynamic>> daysShifts = [];

  for (var element in restaurant.workingDays) {
    Map<String, dynamic> dayShifts = {'day': element.day, 'shifts': []};

    DateTime now = DateTime.now();

    String openTime = element.openAt;
    String closedTime = element.closeAt;

    DateTime openDate = intl.DateFormat("h:mm a").parse(openTime);
    TimeOfDay openHour = TimeOfDay.fromDateTime(openDate);
    openDate =
        DateTime(now.year, now.month, now.day, openHour.hour, openHour.minute);

    DateTime closeDate = intl.DateFormat("h:mm a").parse(closedTime);
    TimeOfDay closeHour = TimeOfDay.fromDateTime(closeDate);
    closeDate = DateTime(
        now.year, now.month, now.day, closeHour.hour, closeHour.minute);

    String day1 = element.day;

    if (closeDate.hour < 12) {
      Map<String, dynamic> firstDayShift = {
        "open": openHour,
        'close': const TimeOfDay(hour: 23, minute: 59)
      };
      dayShifts['shifts'].add(firstDayShift);

      if (daysShifts.any((element) => element['day'] == day1)) {
        daysShifts[daysShifts.indexWhere((element) => element['day'] == day1)]
                ['shifts']
            .add(firstDayShift);
      } else {
        Map<String, dynamic> dayShifts = {
          'day': element.day,
          'shifts': [firstDayShift]
        };
        daysShifts.add(dayShifts);
      }

      Map<String, dynamic> nextDayShift = {
        "open": const TimeOfDay(hour: 00, minute: 00),
        "close": closeHour
      };
      String nextDay = days.indexOf(element.day) == days.length - 1
          ? days[0]
          : days[days.indexOf(element.day) + 1];

      if (daysShifts.any((element) => element['day'] == nextDay)) {
        daysShifts[daysShifts
                .indexWhere((element) => element['day'] == nextDay)]['shifts']
            .add(nextDayShift);
      } else {
        Map<String, dynamic> dayShifts = {
          'day': nextDay,
          'shifts': [nextDayShift]
        };
        daysShifts.add(dayShifts);
      }
    } else {
      Map<String, dynamic> firstDayShift = {
        "open": openHour,
        'close': closeHour
      };
      dayShifts['shifts'].add(firstDayShift);

      if (daysShifts.any((element) => element['day'] == day1)) {
        daysShifts[daysShifts.indexWhere((element) => element['day'] == day1)]
                ['shifts']
            .add(firstDayShift);
      } else {
        Map<String, dynamic> dayShifts = {
          'day': element.day,
          'shifts': [firstDayShift]
        };
        daysShifts.add(dayShifts);
      }
    }
  }

  return daysShifts;
}

bool checkOpened(List<Map<String, dynamic>> daysShifts) {
  int todayIndex;

  todayIndex = englishDays.indexWhere(
      (element) => element == intl.DateFormat('EEEE').format(DateTime.now()));

  String todayName = days[todayIndex];

  if (daysShifts.any((element) => element['day'] == todayName)) {
    Map<String, dynamic> today = daysShifts[
        daysShifts.indexWhere((element) => element['day'] == todayName)];

    List<Map<String, dynamic>> todayShiftsTimes = today['shifts'];

    TimeOfDay now =
        TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

    return todayShiftsTimes.any((element) {
      DateTime now = DateTime.now();
      DateTime open = DateTime(now.year, now.month, now.day,
          element['open'].hour, element['open'].minute);
      DateTime close = DateTime(now.year, now.month, now.day,
          element['close'].hour, element['close'].minute);
      return open.isBefore(now) && close.isAfter(now);
    });
  } else {
    return false;
  }
}

class RestaurantScreen extends StatefulWidget {
  const RestaurantScreen({
    super.key,
  });

  static List<Widget> categoriesWidgets = [];

  @override
  State<RestaurantScreen> createState() => _RestaurantScreenState();
}

class _RestaurantScreenState extends State<RestaurantScreen>
    with TickerProviderStateMixin {
  var uuid = const Uuid();
  List<Widget> specialsImages = [];
  bool checkTime = false;

  @override
  void initState() {
    rebuildCategoriesWidgets(context);
    for (var element in restaurantData.specials.reversed) {
      specialsImages.add(
        Padding(
          padding: EdgeInsets.all(8.0.sp),
          child:
              SizedBox(height: 40.h, width: 40.h, child: Image.asset(element)),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabBarController =
        TabController(length: 2, vsync: this, initialIndex: 1);
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (BuildContext context, Widget? child) => SafeArea(
              child: Scaffold(
                body: InternetCheck(
                  child: Container(
                      color: backGroundColor,
                      child: kIsWeb
                          ? RestaurantWebLayout(
                              restaurant: restaurantData,
                            )
                          : CustomScrollView(
                              slivers: [
                                SliverAppBar(
                                  automaticallyImplyLeading: false,
                                  expandedHeight: 0.25.sh,
                                  backgroundColor: backGroundColor,
                                  flexibleSpace: FlexibleSpaceBar(
                                    background: restaurantImage(
                                        context,
                                        specialsImages,
                                        (url) => setState(() {
                                              restaurantData.image = url;
                                              restaurant['image'] = url;
                                            })),
                                  ),
                                ),
                                AdaptiveHeightSliverPersistentHeader(
                                    pinned: true,
                                    child: RestaurantHeader(
                                        isWeb: kIsWeb,
                                        restaurant: restaurantData,
                                        opened: checkOpened(
                                            getShifts(restaurantData)))),
                                SliverToBoxAdapter(
                                    child: Container(
                                        color: primaryColor.withOpacity(0.1),
                                        child: Reviews(
                                          restaurant: restaurantData,
                                        ))),
                                restaurantData.offers.isNotEmpty
                                    ? SliverToBoxAdapter(
                                        child: OffersImageSlider(
                                            offers: restaurantData.offers),
                                      )
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      ),
                                const SliverToBoxAdapter(
                                  child: MostOrdered(),
                                ),
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 42.sp),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            MyFlatButton(
                                                onPressed: () {
                                                  primaryBottomSheet(
                                                      child:
                                                          RestaurantModalBottomSheet(
                                                              onAdd: () {
                                                                addCategory(
                                                                    context,
                                                                    onFinish:
                                                                        () {
                                                                  Navigator.pop(
                                                                      context);
                                                                });
                                                              },
                                                              edit: false,
                                                              map: CategoryModel(
                                                                  id: "",
                                                                  firestoreId:
                                                                      "",
                                                                  name: "",
                                                                  image: "",
                                                                  time: "",
                                                                  type: "",
                                                                  items: [])),
                                                      context: context);
                                                },
                                                hint: "إضافة صنف",
                                                backgroundColor:
                                                    Colors.transparent,
                                                fontSize: 42.sp,
                                                textColor: primaryColor),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons
                                                      .local_fire_department_rounded,
                                                  color: primaryColor,
                                                  size: 62.h,
                                                ),
                                                SizedBox(
                                                  width: 24.sp,
                                                ),
                                                Text(
                                                  "المنيو",
                                                  style: TextStyling.subtitle
                                                      .copyWith(
                                                          fontSize: 52.sp,
                                                          color: primaryColor,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                restaurantData.menu.isNotEmpty
                                    ? SliverList.list(
                                        children:
                                            RestaurantScreen.categoriesWidgets)
                                    : SliverToBoxAdapter(
                                        child: Container(),
                                      )
                              ],
                            )),
                ),
              ),
            ));
  }
}

Widget restaurantImage(BuildContext context, List<Widget> specialsImages,
    Function(String) onImageChanged) {
  return Stack(
    children: [
      SizedBox(
        height: 0.25.sh,
        width: double.infinity,
        child: CachedAvatar(
          imageUrl: restaurantData.image,
          fit: BoxFit.cover,
          borderRadius: 0,
        ),
      ),
      SizedBox(
          height: 0.25.sh,
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
          )),
      Padding(
        padding: EdgeInsets.symmetric(vertical: 40.sp, horizontal: 24.sp),
        child: Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.sp),
                  child: MyPopUpMenu(
                    options: [
                      {
                        'option': 'مواعيد العمل',
                        'icon': Iconsax.clock,
                        'onPressed': () {
                          Navigator.of(context).push(
                              ScaleTransition5(const WorkingHoursScreen()));
                        },
                        'textColor': backGroundColor,
                      },
                      {
                        'option': 'تغيير اللون',
                        'icon': Iconsax.color_swatch,
                        'onPressed': () {
                          showDialog(
                              context: context,
                              builder: (context) => const ColorPickerDialog());
                        },
                        'textColor': backGroundColor,
                      },
                      {
                        'option': 'تغيير الصورة',
                        'icon': Iconsax.image,
                        'onPressed': () {
                          selectImage(onSelected: (pickedFile) async {
                            await uploadImage(
                                File(pickedFile.path), pickedFile.name,
                                context: context, onUploaded: (url) {
                              showDialog(
                                  context: context,
                                  builder: (context) => const Loading());
                              restaurantDocument
                                  .update({'image': url}).then((value) {
                                onImageChanged(url);
                                saveMap();
                                Navigator.of(context).pop();
                              });
                            });
                          });
                        },
                        'textColor': backGroundColor,
                      },
                      {
                        'option': 'مناطق التوصيل',
                        'icon': Iconsax.location,
                        'onPressed': () {
                          Navigator.push(
                              context, ScaleTransition5(const AreasScreen()));
                        },
                        'textColor': backGroundColor,
                      },
                      {
                        'option': 'تغيير كلمة المرور',
                        'icon': Iconsax.key,
                        'onPressed': () {
                          primaryBottomSheet(
                              child: const ForgetPasswordModelSheet(),
                              context: context);
                        },
                        'textColor': backGroundColor,
                      },
                    ],
                    iconColor: Colors.white,
                    color: primaryColor,
                  ),
                ),
                const BackArrowButton(),
              ],
            )),
      ),
    ],
  );
}
