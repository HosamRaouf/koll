import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/loading.dart';
import '../../../components/myTextField.dart';
import '../../../components/show_snack_bar.dart';
import '../../../core/models/driver_model.dart';
import 'package:kol/map.dart';
import '../../../components/my_alert_dialog.dart';
import '../../../styles.dart';

class AddDriverDialog extends StatefulWidget {
  String imagePath;
  Widget imageWidget;
  var selectImage;
  TextEditingController nameController;
  TextEditingController phoneNumberController;
  AddDriverDialog({
    super.key,
    required this.phoneNumberController,
    required this.nameController,
    required this.imagePath,
    required this.imageWidget,
    required this.selectImage,
  });

  @override
  State<AddDriverDialog> createState() => _AddDriverDialogState();
}

class _AddDriverDialogState extends State<AddDriverDialog> {
  void addDriver(DriverModel driver) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Loading(),
    );
    restaurantDocument.collection('drivers').add(driver.toJson()).then((value) {
      restaurantData.drivers.add(DriverModel(
          id: uuid.v1(),
          firestoreId: "",
          name: widget.nameController.text,
          phoneNumber: widget.phoneNumberController.text,
          image: widget.imagePath,
          orders: [],
          rates: []));
      Navigator.pop(context);
      Navigator.pop(context);
      showSnackBar(
          context: context,
          message: 'تم إضافة ${widget.nameController.text} بنجاح');
    });
  }

  String nameError = '';
  String phoneNumberError = '';

  void validate({required Function() then}) {
    if (widget.nameController.text.isNotEmpty &&
        widget.phoneNumberController.text.isNotEmpty) {
      setState(() {
        nameError = 'من فضلك أدخل اسم الطيار';
        phoneNumberError = 'من فضلك أدخل رقم الطيار';
      });
    } else if (widget.nameController.text.isNotEmpty) {
      setState(() {
        nameError = 'من فضلك أدخل اسم الطيار';
        phoneNumberError = '';
      });
    } else if (widget.phoneNumberController.text.isNotEmpty) {
      setState(() {
        nameError = '';
        phoneNumberError = 'من فضلك أدخل رقم الطيار';
      });
    } else {
      if (!widget.phoneNumberController.text.startsWith('0', 0) ||
          widget.phoneNumberController.text.length != 11) {
        setState(() {
          phoneNumberError = "من فضلك أدخل رقم الهاتف بشكل صحيح";
        });
      } else {
        then();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
        isFirstButtonRed: false,
        controller: TextEditingController(),
        description: 'الطيار دا مش متسجل عندك، تحب تضيفه لقائمة الطيارين؟',
        textfield: false,
        title: 'لا يوجد',
        body: Column(
          children: [
            Center(
              child: SizedBox(
                height: 200.h,
                width: 200.h,
                child: Stack(
                  children: [
                    widget.imagePath == 'assets/images/user.png'
                        ? Container(
                            color: warmColor,
                            height: 200.h,
                            width: 200.h,
                            child: ClipOval(
                                child: Padding(
                              padding: EdgeInsets.all(12.sp),
                              child: Icon(
                                Icons.delivery_dining,
                                color: primaryColor,
                                size: 52,
                              ),
                            )),
                          )
                        : widget.imageWidget,
                    ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            widget.selectImage();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 24.sp,
            ),
            MyTextField(
              error: "",
              descriptionTextField: false,
              title: "",
              controller: widget.nameController,
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
              error: "",
              descriptionTextField: false,
              title: "",
              controller: widget.phoneNumberController,
              type: 'number',
              hintText: 'رقم الهاتف',
              isExpanding: false,
              isValidatable: true,
              onChanged: (text) {},
              maxLength: 11,
            ),
            SizedBox(
              height: 24.sp,
            ),
          ],
        ),
        firstButton: 'إضافة',
        secondButton: 'إلغاء',
        onFirstButtonPressed: () {
          validate(then: () {
            addDriver(DriverModel(
                id: uuid.v1(),
                firestoreId: '',
                name: widget.nameController.text,
                phoneNumber: widget.phoneNumberController.text,
                image: widget.imagePath,
                orders: [],
                rates: []));
          });
        },
        onSecondButtonPressed: () {});
  }
}
