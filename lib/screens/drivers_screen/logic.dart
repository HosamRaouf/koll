import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/screens/drivers_screen/driver_widget.dart';
import 'package:kol/map.dart';
import 'package:kol/styles.dart';
import 'dart:io' as io;

import '../../components/loading.dart';
import '../../core/models/driver_model.dart';
import '../../components/my_alert_dialog.dart';

List<Widget> driverWidgets = [];
List<Widget> searchedDriverWidgets = [];

buildDrivers() {
  driverWidgets.clear();
  for (var driver in restaurantData.drivers) {
    driverWidgets.add(DriverWidget(
      driver: driver,
      deleteIcon: true,
    ));
  }
}

checkFile(String path) async {
  await io.File(path).exists();
  return io.File(path).existsSync();
}

Future<void> removeDriver(DriverModel driver) async {

  await restaurantDocument.collection('drivers').doc(driver.firestoreId).delete().then((value) {

    restaurantData.drivers.remove(restaurantData.drivers[
    restaurantData.drivers.indexWhere((element) => element.id == driver.id)]);

    restaurant['drivers'].remove(restaurant['drivers'][restaurant['drivers'].indexWhere((element) => element['id'] == driver.id)]);
    saveMap();
  }

  );


}

showDeleteDriverDialog(BuildContext context, DriverModel driver, Function(DriverModel driver) onDeleted) {
  showDialog(
      context: context,
      builder: (context) {
        return MyAlertDialog(
            isFirstButtonRed: true,
            controller: TextEditingController(),
            description: '',
            textfield: false,
            title: 'حذف الطيار؟',
            body: SizedBox(
              width: double.maxFinite,
              child: Column(
                children: [
                  Container(
                      height: 0.2.sh,
                      decoration: BoxDecoration(
                          color: warmColor,
                          borderRadius: BorderRadius.circular(36.sp)
                      ),
                      child: driver.image == 'assets/images/user.png'?  Padding(
                        padding:  EdgeInsets.all(12.sp),
                        child: Icon(Icons.delivery_dining, color: primaryColor, size: 52,),) : CachedAvatar(imageUrl: driver.image, fit: BoxFit.cover,)),
                  const Divider(color: fontColor,),
                  Text(driver.name, style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 60.sp),),
                  Text(driver.phoneNumber, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 40.sp),)
                ],
              )
            ),
            firstButton: 'حذف الطيار',
            secondButton: 'إلغاء',
            onFirstButtonPressed: () {
              showDialog(context: context, builder: (context)=>const Loading(), barrierDismissible: false );
              removeDriver(driver).then((value) => {
             onDeleted(driver)
              });
            },
            onSecondButtonPressed: () {});
      });
}

searchDrivers(String text) {
  driverWidgets.clear();
  searchedDriverWidgets.clear();
  for (var element in restaurantData.drivers) {
    element.name.startsWith(text)
        ? searchedDriverWidgets
            .add(DriverWidget(driver: element, deleteIcon: true))
        : false;
  }
}
