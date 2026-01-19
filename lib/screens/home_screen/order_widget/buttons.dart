import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../components/myElevatedButton.dart';
import '../../../components/my_alert_dialog.dart';
import '../../../core/models/order_model.dart';

class OrderButtons extends StatefulWidget {
  OrderModel order;
  Function() onOrderAccepted;
  Function(String) onDelete;
  OrderButtons(
      {super.key,
      required this.order,
      required this.onOrderAccepted,
      required this.onDelete});

  @override
  State<OrderButtons> createState() => _OrderButtonsState();
}

class _OrderButtonsState extends State<OrderButtons> {
  TextEditingController areYouSureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.sp,
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: kIsWeb ? 12.sp : 30.sp,
          ),
          child: MyElevatedButton(
              fontSize: kIsWeb ? 22.sp : 40.h,
              width: double.infinity,
              enabled: true,
              onPressed: () async {
                widget.onOrderAccepted();
              },
              text: 'قبول',
              gradient: true,
              color: Colors.transparent,
              textColor: Colors.white),
        ),
        SizedBox(
          height: 0.sp,
        ),
        Padding(
          padding: EdgeInsets.only(
              top: 12.sp,
              left: kIsWeb ? 12.sp : 30.sp,
              right: kIsWeb ? 12.sp : 30.sp),
          child: MyElevatedButton(
              enabled: true,
              fontSize: kIsWeb ? 22.sp : 40.h,
              width: double.infinity,
              onPressed: () async {
                await showDialog(
                    context: context,
                    builder: (context) => MyAlertDialog(
                          isFirstButtonRed: true,
                          onFirstButtonPressed: () {
                            widget.onDelete(areYouSureController.text);
                          },
                          onSecondButtonPressed: () {},
                          firstButton: 'رفض',
                          secondButton: 'إلغاء',
                          body: Container(
                            height: 1.sp,
                            color: Colors.red,
                          ),
                          title: 'رفض الطلب؟',
                          description: 'من فضلك وضّح للعميل ليه طلبه اترفض',
                          textfield: true,
                          controller: areYouSureController,
                        )).then((val) {
                  areYouSureController.clear();
                });
              },
              text: 'رفض',
              gradient: false,
              color: const Color(0xffFFCCCC),
              textColor: Colors.red),
        ),
        SizedBox(
          height: 12.sp,
        ),
      ],
    );
  }
}
