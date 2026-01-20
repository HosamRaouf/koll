import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_storage/selectAndUploadImage.dart';
import 'package:kol/core/firestore_database/getDocId.dart';
import 'package:kol/core/models/driver_model.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/screens/drivers_screen/logic.dart';

import '../../components/loading.dart';
import '../../components/myElevatedButton.dart';
import '../../components/myTextField.dart';
import 'package:kol/map.dart';
import '../../routes/app_routes.dart';
import '../../styles.dart';

class AddDriver extends StatefulWidget {
  const AddDriver(
      {super.key,
      required this.onAdd,
      required this.addOrEdit,
      required this.driver});

  final Function() onAdd;
  final bool addOrEdit;
  final DriverModel driver;

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  String imagePath = 'assets/images/user.png';
  String nameError = '';
  String phoneNumberError = '';

  addDriver() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Loading(),
    );

    widget.driver.id = uuid.v1();
    widget.driver.name = nameController.text;
    widget.driver.image = imagePath;
    widget.driver.phoneNumber = phoneNumberController.text;

    await restaurantDocument
        .collection('drivers')
        .add(widget.driver.toJson())
        .then((value) async {
      await getDocId(
              docWhere: restaurantDocument
                  .collection('drivers')
                  .where('id', isEqualTo: widget.driver.id))
          .then((id) async {
        await restaurantDocument
            .collection('drivers')
            .doc(id)
            .update({'firestoreId': id}).then((value) {
          widget.driver.firestoreId = id;
          restaurantData.drivers.add(widget.driver);
          restaurant['drivers'].add(widget.driver.toJson());
          saveMap();
          widget.onAdd();
          Navigator.pop(context);
          Navigator.pop(context);
          showSnackBar(
              context: context,
              message: 'تم إضافة ${nameController.text} بنجاح');
        });
      });
    });
  }

  void validate({required Function() then}) {
    if (nameController.text.isEmpty && phoneNumberController.text.isEmpty) {
      setState(() {
        nameError = 'من فضلك أدخل اسم الطيار';
        phoneNumberError = 'من فضلك أدخل رقم الطيار';
      });
    } else if (nameController.text.isEmpty) {
      setState(() {
        nameError = 'من فضلك أدخل اسم الطيار';
        phoneNumberError = '';
      });
    } else if (phoneNumberController.text.isEmpty) {
      setState(() {
        nameError = '';
        phoneNumberError = 'من فضلك أدخل رقم الطيار';
      });
    } else {
      if (!phoneNumberController.text.startsWith('01', 0) ||
          phoneNumberController.text.length != 11) {
        setState(() {
          phoneNumberError = "من فضلك أدخل رقم الهاتف بشكل صحيح";
        });
      } else {
        setState(() {
          phoneNumberError = "";
          nameError = "";
        });
        then();
      }
    }
  }

  updateDriver() async {
    imagePath != 'assets/images/user.png'
        ? widget.driver.image = imagePath
        : false;
    widget.driver.name = nameController.text;
    widget.driver.phoneNumber = phoneNumberController.text;

    showDialog(
        context: context,
        builder: (context) => const Loading(),
        barrierDismissible: false);

    await restaurantDocument
        .collection('drivers')
        .doc(widget.driver.firestoreId)
        .update({
      "image": widget.driver.image,
      "name": widget.driver.name,
      "phoneNumber": widget.driver.phoneNumber
    }).then((value) => {
              restaurantData.drivers[restaurantData.drivers.indexWhere(
                  (element) => element.id == widget.driver.id)] = widget.driver,
              restaurant['drivers'][restaurant['drivers'].indexWhere(
                      (element) => element['id'] == widget.driver.id)] =
                  widget.driver.toJson(),
            });
    widget.onAdd();
    buildDrivers();
    Navigator.pop(NamedNavigatorImpl.navigatorState.currentContext!);
    Navigator.pop(NamedNavigatorImpl.navigatorState.currentContext!);
    showSnackBar(
        context: NamedNavigatorImpl.navigatorState.currentContext!,
        message: 'تم التعديل بنجاح');
  }

  @override
  void initState() {
    widget.driver.name.isNotEmpty
        ? {
            nameController.text = widget.driver.name,
            phoneNumberController.text = widget.driver.phoneNumber,
            imagePath = widget.driver.image
          }
        : false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.sp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            widget.addOrEdit ? 'إضافة طيار' : "تعديل بيانات الطيار",
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 60.sp, color: primaryColor),
          ),
          SizedBox(
            height: 42.sp,
          ),
          Center(
            child: ClipOval(
              child: SizedBox(
                height: 200.h,
                width: 200.h,
                child: Stack(
                  children: [
                    imagePath != 'assets/images/user.png'
                        ? ClipOval(
                            child: SizedBox(
                                width: 200.h,
                                height: 200.h,
                                child: CachedAvatar(
                                  imageUrl: imagePath,
                                  fit: BoxFit.fitHeight,
                                )),
                          )
                        : Container(
                            width: 200.h,
                            height: 200.h,
                            decoration: BoxDecoration(
                                color: warmColor,
                                borderRadius: BorderRadius.circular(36.r)),
                            child: Padding(
                              padding: EdgeInsets.all(24.sp),
                              child: Image.asset(
                                "assets/images/delivery.png",
                                fit: BoxFit.cover,
                              ),
                            )),
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () async {
                            await selectAndUploadImage(context,
                                onUploaded: (url) {
                              setState(() {
                                imagePath = url;
                              });
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 24.sp,
          ),
          MyTextField(
            error: nameError,
            descriptionTextField: false,
            title: "اسم الطيار",
            controller: nameController,
            type: 'normal',
            hintText: 'الإسم',
            isExpanding: false,
            isValidatable: true,
            onChanged: (text) {},
            maxLength: 25,
          ),
          SizedBox(
            height: 12.sp,
          ),
          MyTextField(
            error: phoneNumberError,
            descriptionTextField: false,
            title: 'رقم الطيار',
            controller: phoneNumberController,
            type: 'number',
            hintText: '01234567890',
            isExpanding: false,
            isValidatable: true,
            onChanged: (text) {},
            maxLength: 11,
          ),
          SizedBox(
            height: 24.sp,
          ),
          MyElevatedButton(
            onPressed: () {
              validate(then: () async {
                widget.addOrEdit ? await addDriver() : await updateDriver();
              });
            },
            text: widget.addOrEdit ? 'إضافة' : 'تعديل',
            width: double.infinity,
            enabled: true,
            fontSize: 52.sp,
            textColor: Colors.white,
            color: Colors.transparent,
            gradient: true,
          )
        ],
      ),
    );
  }
}
