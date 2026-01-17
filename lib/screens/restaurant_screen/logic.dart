import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firestore_database/getDocId.dart';
import 'package:kol/core/models/area_model.dart';
import 'package:kol/core/models/day_model.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/screens/restaurant_screen/restaurant_modal_bottom_sheet.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';

import '../../components/loading.dart';
import '../../core/firestore_database/add/addToCollection.dart';
import '../../core/models/menu_models/category_model.dart';
import '../../map.dart';
import '../../styles.dart';
import 'category_widget.dart';
import 'most_ordered/most_ordered.dart';

void getUserLocation({required LatLng currentPosition}) async {
  var position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings:
          const LocationSettings(accuracy: LocationAccuracy.best));

  currentPosition = LatLng(position.latitude, position.longitude);
}

List<DayModel> daysModels = List.generate(
    days.length,
    (index) =>
        DayModel(day: days[index], openAt: '12:00PM', closeAt: '9:00PM'));

List<String> days = [
  "السبت",
  "الاحد",
  "الاثنين",
  "الثلاثاء",
  "الاربعاء",
  "الخميس",
  "الجمعة",
];
List<String> englishDays = [
  "Saturday",
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
];

bool checkRestaurentStatus(
    String openTime, String closedTime, BuildContext context) {
  DateTime now = DateTime.now();

  DateTime openDate = DateFormat("h:mm a").parse(openTime);
  TimeOfDay openHour = TimeOfDay.fromDateTime(openDate);
  openDate =
      DateTime(now.year, now.month, now.day, openHour.hour, openHour.minute);

  DateTime closeDate = DateFormat("h:mm a").parse(closedTime);
  TimeOfDay closeHour = TimeOfDay.fromDateTime(closeDate);

  int day = now.day + 1;

  if (closeHour.period == DayPeriod.am) {
    closeDate =
        DateTime(now.year, now.month, day, closeHour.hour, closeHour.minute);
  } else {
    closeDate = DateTime(
        now.year, now.month, now.day, closeHour.hour, closeHour.minute);
  }

  if (openDate.isBefore(now) && closeDate.isAfter(now)) {
    return true;
  } else {
    return false;
  }
}

updateArea(TextEditingController feeController, AreaModel area,
    BuildContext context, FocusNode feeFocus, int index) {
  {
    area.fee = double.parse(feeController.text).round();

    showDialog(context: context, builder: (context) => const Loading());

    restaurantData.areas[index] = area;

    restaurant['areas'].clear();

    for (var element in restaurantData.areas) {
      restaurant['areas'].add(element.toJson());
    }

    restaurantDocument.update({'areas': restaurant['areas']}).then((value) => {
          saveMap(),
          feeFocus.unfocus(),
          showSnackBar(
              context: context,
              message:
                  'تم تعديل ضريبة توصيل منطقة ${restaurantData.areas.indexOf(area) + 1} إلى ${feeController.text}'),
          Navigator.pop(context),
        });
  }
}

rebuildCategoriesWidgets(BuildContext context) {
  RestaurantScreen.categoriesWidgets.clear();
  restaurantData.menu
      .sort((a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));
  for (var category in restaurantData.menu) {
    RestaurantScreen.categoriesWidgets.add(CategoryWidget(
      category: category,
      onDelete: () async {
        showDialog(context: context, builder: (context) => const Loading());
        await restaurantDocument
            .collection('menu')
            .doc(category.firestoreId)
            .delete()
            .then((value) {
          restaurant['menu'].remove(restaurant['menu'][restaurant['menu']
              .indexWhere((element) => element['id'] == category.id)]);
          restaurantData.menu.remove(restaurantData.menu[restaurantData.menu
              .indexWhere((element) => element.id == category.id)]);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(context: context, message: 'تم الحذف بنجاح');
        }).catchError((e) {
          showSnackBar(
              context: context, message: 'خطأ في الشبكة، حاول مرة أخرى');
          Navigator.pop(context);
        });
      },
      onEditSubmit: () {
        showDialog(
            context: context,
            builder: (context) => const Loading(),
            barrierDismissible: false);
        restaurantDocument.collection('menu').doc(category.firestoreId).update({
          'name': category.name,
          'image': category.image,
          'type': category.type
        }).then((value) {
          saveMap();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(context: context, message: 'تم التعديل بنجاح');
        });
      },
    ));
  }
  MostOrdered.rebuildMostOrdered();
}

addCategory(BuildContext context, {required Function() onFinish}) async {
  int i = 0;
  for (var element in restaurantData.menu) {
    element.name == RestaurantModalBottomSheet.controller1.text ? i++ : false;
  }

  if (i != 0) {
    Navigator.of(context).pop();
    showSnackBar(context: context, message: 'لا يمكن إضافة صنفين بنفس الإسم');
  } else {
    CategoryModel newCategory = CategoryModel(
        id: uuid.v1(),
        firestoreId: "",
        name: RestaurantModalBottomSheet.controller1.text,
        time: DateTime.now().toString(),
        image:
            'assets/images/${RestaurantModalBottomSheet.type}/${RestaurantModalBottomSheet.index++}.png',
        type: RestaurantModalBottomSheet.type,
        items: []);

    await addDocumentToCollection(
            doc: restaurantDocument.collection('menu'),
            data: newCategory.toJson())
        .then((value) async {
      await getDocId(
              docWhere: restaurantDocument
                  .collection('menu')
                  .where('id', isEqualTo: newCategory.id))
          .then((id) {
        restaurantDocument
            .collection('menu')
            .doc(id)
            .update({'firestoreId': id}).then((value) {
          newCategory.firestoreId = id;
          restaurant['menu']
              .insert(restaurant['menu'].length, newCategory.toJson());
          restaurantData.menu.insert(restaurantData.menu.length, newCategory);
          saveMap();

          RestaurantModalBottomSheet.type = 'food';
          RestaurantModalBottomSheet.index = 1;

          rebuildCategoriesWidgets(context);
          onFinish();

          showSnackBar(
            context: context,
            message:
                'تم إضافة ${RestaurantModalBottomSheet.controller1.text} بنجاح',
          );
          RestaurantModalBottomSheet.controller1.clear();
        });
      });
    });
  }
}

List<String> workingDays = [];
