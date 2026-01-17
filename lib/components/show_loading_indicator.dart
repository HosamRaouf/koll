import 'package:flutter/material.dart';
import 'package:kol/styles.dart';

void showLoadingIndicator(
    BuildContext context, int duration, var onLoadingComplete) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return  Dialog(
        child: Center(
            child: CircularProgressIndicator(
          strokeWidth: 2,
          color: primaryColor,
        )),
      );
    },
  );

  Future.delayed(Duration(microseconds: duration)).then((value) {
    print(value);
    onLoadingComplete();
    Navigator.pop(context);
  });
}
