


import 'package:flutter/material.dart';

import '../styles.dart';

void showDialogTimePicker(
    BuildContext context, Function(TimeOfDay value) onChanged) {
  Future<TimeOfDay?> selectedTime = showTimePicker(
    confirmText: 'تعديل',
    cancelText: 'إلغاء',
    hourLabelText: 'اختر الساعة',
    minuteLabelText: 'ختر الدقيقة',
    errorInvalidText: 'برجاء استخدام الأرقام فقط',
    context: context,
    initialTime: TimeOfDay.now(),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          textTheme: Theme.of(context).textTheme,
          colorScheme:  ColorScheme.light(
            // primary: MyColors.primary,
            primary: primaryColor,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          //.dialogBackgroundColor:Colors.blue[900],
        ),
        child: child!,
      );
    },
  );
  selectedTime.then((value) {
    if (value == null) return;
    onChanged(value);
  }, onError: (error) {
    print(error);

  });
}