import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/map.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/restaurant_screen/pop_menu/color_picker/methods.dart';

import '../../../../components/loading.dart';
import '../../../../components/my_alert_dialog.dart';
import '../../../../styles.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color newColor = primaryColor;
  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
      controller: TextEditingController(),
      body: Material(
        color: Colors.transparent,
        child: ColorPicker(
          pickerColor: primaryColor,
          onColorChanged: (color) {
            setState(() {
              primaryColor = color;
              accentColor = lighten(color);
              backGroundColor = brighten(color, 0.95);
              warmColor = brighten(color, 0.87);
              myGradient = LinearGradient(colors: [primaryColor, accentColor]);
              cardDecoration = cardDecoration.copyWith(
                color: backGroundColor,
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.02),
                    spreadRadius: 0,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: accentColor.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              );

              newColor = primaryColor;
            });
          },
          displayThumbColor: true,
          enableAlpha: false,
          portraitOnly: true,
          showLabel: false,
          paletteType: PaletteType.hsv,
          pickerAreaBorderRadius: BorderRadius.circular(8.0),
        ),
      ),
      isFirstButtonRed: false,
      description: '',
      firstButton: 'تغيير اللون',
      onFirstButtonPressed: () {
        // Navigator.pop(context);
        showDialog(context: context, builder: (context) => const Loading());
        restaurantDocument.update(
            {'color': lighten(newColor).value.toRadixString(16)}).then((value) {
          restaurant['color'] = newColor.value.toRadixString(16);
          restaurantData.color = newColor.value.toRadixString(16);
          Navigator.pushAndRemoveUntil(
              context,
              ScaleTransition5(const HomeScreen(
                isKitchen: false,
              )),
              (route) => false);
          showSnackBar(context: context, message: 'تم تغيير اللون بنجاح');
        });
      },
      secondButton: 'الغاء',
      onSecondButtonPressed: () {},
      textfield: false,
      title: 'تغيير اللون',
    );
  }
}
