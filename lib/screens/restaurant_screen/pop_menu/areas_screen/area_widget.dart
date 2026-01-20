import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/models/area_model.dart';

import '../../../../components/myTextField.dart';
import '../../../../components/my_flat_button.dart';
import '../../../../components/show_snack_bar.dart';
import 'package:kol/map.dart';
import '../../../../styles.dart';
import '../../logic.dart';

class AreaWidget extends StatelessWidget {
  AreaModel area;
  int polygonId;
  List colors;
  int areaIndex;

  AreaWidget(
      {super.key,
      required this.area,
      required this.colors,
      required this.polygonId,
      required this.areaIndex});

  @override
  Widget build(BuildContext context) {
    TextEditingController feeController =
        TextEditingController(text: area.fee.toString());
    String error = '';
    FocusNode feeFocus = FocusNode();

    return Padding(
      padding: EdgeInsets.only(
          right: 24.sp,
          left: restaurantData.areas.indexOf(area) ==
                  restaurantData.areas.length - 1
              ? 24.sp
              : 0),
      child: Container(
        width: 0.175.sh,
        height: 0.3.sh,
        decoration: cardDecoration.copyWith(
            color: colors[polygonId].withOpacity(0.3),
            borderRadius: BorderRadius.circular(42.r),
            border: Border.all(color: colors[polygonId])),
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                children: [
                  Text(
                    'منطقة ${polygonId + 1}',
                    style: ArabicTextStyle(
                        arabicFont: ArabicFont.avenirArabic,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 42.sp),
                  ),
                  Text(
                    'ضريبة التوصيل',
                    style: ArabicTextStyle(
                        arabicFont: ArabicFont.cairo,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                        fontSize: 32.sp),
                  ),
                ],
              ),
              SizedBox(
                height: 12.sp,
              ),
              Center(
                child: MyTextField(
                  descriptionTextField: false,
                  error: error,
                  title: "خدمة التوصيل",
                  maxLength: 3,
                  onSubmit: () {
                    feeController.text.isNotEmpty
                        ? area.fee == double.parse(feeController.text).round()
                            ? feeFocus.unfocus()
                            : updateArea(feeController, area, context, feeFocus,
                                areaIndex)
                        : {
                            FocusScope.of(context).unfocus(),
                            showSnackBar(
                                context: context,
                                message: 'من فضلك أدخل ضريبة التوصيل')
                          };
                  },
                  focusScopeNode: feeFocus,
                  controller: feeController,
                  type: 'number',
                  hintText: 'e.g: 10EGP',
                  isExpanding: false,
                  isValidatable: false,
                ),
              ),
              SizedBox(
                height: 12.sp,
              ),
              Align(
                  alignment: Alignment.bottomLeft,
                  child: MyFlatButton(
                    onPressed: () {
                      if (feeController.text.isEmpty) {
                        feeFocus.requestFocus();
                        showSnackBar(
                            context: context,
                            message: 'من فضلك أدخل ضريبة التوصيل');
                      } else if (area.fee ==
                          double.parse(feeController.text).round()) {
                        feeFocus.requestFocus();
                      } else {
                        updateArea(
                            feeController, area, context, feeFocus, areaIndex);
                        feeFocus.unfocus();
                      }
                    },
                    hint: 'تعديل',
                    backgroundColor: Colors.transparent,
                    fontSize: 36.sp,
                    textColor: Colors.white,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
