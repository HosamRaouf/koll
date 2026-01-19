import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/myTextField.dart';
import 'package:kol/core/models/driver_model.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/map.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../../components/dropdown_textfield.dart';
import '../../../components/myElevatedButton.dart';
import '../../../components/my_image.dart';
import '../../../styles.dart';

class ChooseDriver extends StatefulWidget {
  static SingleValueDropDownController controller =
      SingleValueDropDownController();
  final OrderModel order;
  final Function(OrderModel order, DriverModel driver) onSubmit;

  ChooseDriver({super.key, required this.order, required this.onSubmit});

  @override
  State<ChooseDriver> createState() => _ChooseDriverState();
}

class _ChooseDriverState extends State<ChooseDriver> {
  Color hintColor = const Color.fromRGBO(108, 108, 108, 1.0);
  FontWeight hintWeight = FontWeight.w500;
  Widget userImage = const SizedBox();

  String driverState = 'driver';

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  late DriverModel driver;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: kIsWeb ? 12.sp : 35.sp,
          right: kIsWeb ? 12.sp : 35.sp,
          bottom: 15.sp),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const StyledDivider(
            thickness: 1,
            lineStyle: DividerLineStyle.solid,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: RadioListTile(
                  activeColor: primaryColor,
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    "طيار عشوائي",
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: kIsWeb ? 18.sp : 36.sp,
                        fontWeight: driverState == 'custom'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: primaryColor),
                  ),
                  value: "custom",
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: driverState,
                  onChanged: (value) {
                    setState(() {
                      driverState = value.toString();
                    });
                  },
                ),
              ),
              Expanded(
                child: RadioListTile(
                  activeColor: primaryColor,
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(
                    "طيار من عندي",
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                        fontSize: kIsWeb ? 18.sp : 36.sp,
                        fontWeight: driverState == 'driver'
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: primaryColor),
                  ),
                  value: "driver",
                  controlAffinity: ListTileControlAffinity.trailing,
                  groupValue: driverState,
                  onChanged: (value) {
                    setState(() {
                      driverState = value.toString();
                    });
                  },
                ),
              ),
            ],
          ),
          driverState == 'driver'
              ? Container(
                  constraints: BoxConstraints(minHeight: kIsWeb ? 60.h : 120.h),
                  decoration: BoxDecoration(
                      color: backGroundColor,
                      borderRadius: BorderRadius.circular(20.r)),
                  child: DropDownTextField(
                    dropDownList: List.generate(
                      restaurantData.drivers.length,
                      (index) => DropDownValueModel(
                        id: restaurantData.drivers[index].id,
                        name: restaurantData.drivers[index].name,
                        phoneNumber: restaurantData.drivers[index].phoneNumber,
                        image: restaurantData.drivers[index].image,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        driver = restaurantData.drivers.firstWhere(
                            (driver) => driver.phoneNumber == val.phoneNumber);
                        hintColor = primaryColor;
                        hintWeight = FontWeight.w600;
                        userImage = Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: ClipOval(
                              child: MyImage(
                                image: val.image,
                                height: kIsWeb ? 40.h : 100.h,
                                width: kIsWeb ? 40.h : 100.h,
                              ),
                            ));
                      });
                    },
                  ))
              : Flexible(
                  child: CustomeDriver(
                      nameController: nameController,
                      numberController: numberController),
                ),
          SizedBox(
            height: 24.sp,
          ),
          MyElevatedButton(
            fontSize: kIsWeb ? 22.sp : 40.h,
            enabled: driverState == 'driver'
                ? ChooseDriver.controller.dropDownValue != null
                : nameController.text.isNotEmpty &&
                    numberController.text.length == 11,
            onPressed: () {
              if (driverState == 'driver' &&
                      ChooseDriver.controller.dropDownValue == null ||
                  driverState == 'custom' &&
                      (nameController.text.isEmpty &&
                          numberController.text.isEmpty)) {
                var snackBar = SnackBar(
                    content: Text(
                      'من فضلك اختار طيار',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium
                          ?.copyWith(
                              fontSize: kIsWeb ? 20.sp : 40.sp,
                              color: Colors.white),
                    ),
                    backgroundColor: primaryColor.withOpacity(0.85));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                driverState == 'driver'
                    ? widget.onSubmit(widget.order, driver)
                    : widget.onSubmit(
                        widget.order,
                        DriverModel(
                            id: '',
                            firestoreId: "",
                            name: nameController.text,
                            phoneNumber: numberController.text,
                            image: 'assets/images/user.png',
                            orders: [],
                            rates: []));
              }
            },
            text: 'تعيين',
            width: double.infinity,
            color: Colors.transparent,
            gradient: true,
            textColor: Colors.white,
          )
        ],
      ),
    );
  }
}

class CustomeDriver extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController numberController;
  CustomeDriver(
      {super.key,
      required this.nameController,
      required this.numberController});
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode numberFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyTextField(
          error: "",
          descriptionTextField: false,
          title: "",
          focusScopeNode: nameFocusNode,
          controller: nameController,
          type: 'normal',
          hintText: 'الإسم',
          isExpanding: false,
          isValidatable: true,
          maxLength: 25,
        ),
        SizedBox(
          height: 12.sp,
        ),
        MyTextField(
          error: "",
          descriptionTextField: false,
          title: "",
          controller: numberController,
          focusScopeNode: numberFocusNode,
          type: 'number',
          hintText: 'رقم التليفون',
          isExpanding: false,
          isValidatable: true,
          maxLength: 11,
        ),
      ],
    );
  }
}
