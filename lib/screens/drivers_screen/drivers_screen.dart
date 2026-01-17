import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kol/components/blank_screen.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/myTextField.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/drivers_screen/add_driver_modal_bottom_sheet.dart';
import 'package:kol/screens/drivers_screen/driver_widget.dart';
import 'package:kol/screens/drivers_screen/logic.dart';
import 'package:kol/styles.dart';

import '../../core/models/driver_model.dart';

class DriversScreen extends StatefulWidget {
  const DriversScreen({super.key});

  @override
  State<DriversScreen> createState() => _DriversScreenState();
}

class _DriversScreenState extends State<DriversScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    buildDrivers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: BlankScreen(
                title: 'الطيارين',
                child: Padding(
                  padding: EdgeInsets.all(40.sp),
                  child: Stack(
                    children: [
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: MyElevatedButton(
                            onPressed: () {
                              primaryBottomSheet(
                                  child: AddDriver(
                                    onAdd: () {
                                      setState(() {
                                        buildDrivers();
                                      });
                                    },
                                    addOrEdit: true,
                                    driver: DriverModel(
                                        name: '',
                                        image: '',
                                        firestoreId: '',
                                        phoneNumber: '',
                                        id: '',
                                        orders: [],
                                        rates: []),
                                  ),
                                  context: context);
                            },
                            text: 'إضافة',
                            width: double.infinity,
                            enabled: true,
                            fontSize: 52.sp,
                            color: Colors.transparent,
                            textColor: Colors.white,
                            gradient: true,
                          )),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.sp),
                            child: MyTextField(
                              error: "",
                              descriptionTextField: false,
                              title: "",
                              controller: searchController,
                              type: 'normal',
                              hintText: 'بحث',
                              isExpanding: false,
                              isValidatable: false,
                              onChanged: (text) {
                                setState(() {
                                  searchDrivers(searchController.text);
                                });
                              },
                              maxLength: 100,
                            ),
                          ),
                          searchController.text.isNotEmpty
                              ? searchedDriverWidgets.isNotEmpty
                                  ? SizedBox(
                                      height: 0.7.sh,
                                      child: AnimationLimiter(
                                        child: GridView.count(
                                          crossAxisSpacing: 10.sp,
                                          physics: const BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          crossAxisCount: 2,
                                          children: List.generate(
                                            searchedDriverWidgets.length,
                                            (int index) {
                                              return AnimationConfiguration
                                                  .staggeredGrid(
                                                position: index,
                                                duration: const Duration(
                                                    milliseconds: 600),
                                                columnCount: 2,
                                                child: ScaleAnimation(
                                                    duration: const Duration(
                                                        milliseconds: 1000),
                                                    curve: Curves
                                                        .fastLinearToSlowEaseIn,
                                                    child:
                                                        searchedDriverWidgets[
                                                            index]),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0.7.sh,
                                      child: Center(
                                          child: Text(
                                        'لا يوجد طيارين',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize: 40.sp,
                                                color: primaryColor),
                                      )))
                              : driverWidgets.isNotEmpty
                                  ? SizedBox(
                                      height: 0.7.sh,
                                      child: AnimationLimiter(
                                        child: GridView.count(
                                          childAspectRatio:
                                              MediaQuery.of(context)
                                                      .size
                                                      .aspectRatio *
                                                  2.5,
                                          crossAxisSpacing: 20.sp,
                                          mainAxisSpacing: 10.sp,
                                          physics: const BouncingScrollPhysics(
                                              parent:
                                                  AlwaysScrollableScrollPhysics()),
                                          crossAxisCount: 2,
                                          children: List.generate(
                                            restaurantData.drivers.length,
                                            (int index) {
                                              DriverModel driver =
                                                  restaurantData.drivers[index];
                                              return AnimationConfiguration
                                                  .staggeredGrid(
                                                position: index,
                                                duration: const Duration(
                                                    milliseconds: 600),
                                                columnCount: 2,
                                                child: ScaleAnimation(
                                                  duration: const Duration(
                                                      milliseconds: 1000),
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  child: FadeInAnimation(
                                                    child: DriverWidget(
                                                        driver: driver,
                                                        deleteIcon: true),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  : SizedBox(
                                      height: 0.7.sh,
                                      child: Center(
                                          child: Text(
                                        'لا يوجد طيارين',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium!
                                            .copyWith(
                                                fontSize: 40.sp,
                                                color: primaryColor),
                                      ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
