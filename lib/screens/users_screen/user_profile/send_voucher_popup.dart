import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/my_alert_dialog.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_messaging/sendNotification.dart';
import 'package:kol/styles.dart';

import '../../../core/models/user_models/user_model.dart';
import '../../../core/models/voucher_model.dart';
import '../../../map.dart';

ValueNotifier<VoucherModel> chosenVoucher = ValueNotifier<VoucherModel>(
    VoucherModel(
        id: "", firestoreId: "", name: "", discount: 0, limit: 0, time: ""));

class SendVoucher extends StatelessWidget {
  UserModel user;
  SendVoucher({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
        controller: TextEditingController(),
        description: "من هنا تقدر تمسّي على الزبون بكود خصم",
        textfield: false,
        title: "إرسال إشعار",
        body: Padding(
            padding: EdgeInsets.all(24.sp),
            child: ValueListenableBuilder(
                valueListenable: chosenVoucher,
                builder: (context, chosenVoucher, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        restaurantData.vouchers.length,
                        (index) => SelectableItem(
                            voucher: restaurantData.vouchers[index]))))),
        firstButton: "إرسال",
        secondButton: "إلغاء",
        onFirstButtonPressed: () {
          if (chosenVoucher.value.id == "") {
            showSnackBar(context: context, message: "من فضلك إختار كود خصم");
          } else {
            for (var element in user.tokens) {
              sendNotification(
                  element,
                  "مطعم ${restaurantData.name} بيمسّي عليك😉",
                  "استخدم دلوقتي كود خصم ${chosenVoucher.value.name} واحصل على خصم ${chosenVoucher.value.discount}%",
                  data: "voucher");
              showSnackBar(context: context, message: "كود الخصم اتبعت بنجاح");
            }
          }
        },
        onSecondButtonPressed: () {
          chosenVoucher.value = VoucherModel(
              id: "",
              firestoreId: "",
              name: "",
              discount: 0,
              limit: 0,
              time: "");
          chosenVoucher.notifyListeners();
        },
        isFirstButtonRed: false);
  }
}

class SelectableItem extends StatefulWidget {
  final VoucherModel voucher;

  SelectableItem({
    Key? key,
    required this.voucher,
  }) : super(key: key);

  @override
  _SelectableItemState createState() => _SelectableItemState();
}

class _SelectableItemState extends State<SelectableItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.sp),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastEaseInToSlowEaseOut,
        decoration: cardDecoration.copyWith(
            gradient: chosenVoucher.value == widget.voucher
                ? myGradient
                : LinearGradient(
                    colors: [Colors.white, backGroundColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter),
            image: const DecorationImage(
                image: AssetImage(
                  "assets/images/icons2.png",
                ),
                fit: BoxFit.cover)),
        child: MyInkWell(
          radius: 28.r,
          onTap: () {
            chosenVoucher.value = widget.voucher;
            chosenVoucher.notifyListeners();
          },
          child: Padding(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  widget.voucher.name,
                  style: TextStyling.headline.copyWith(
                      color: chosenVoucher.value == widget.voucher
                          ? backGroundColor
                          : primaryColor,
                      fontSize: 42.sp),
                ),
                Text(
                  "خصم ${widget.voucher.discount}% على أي أوردر بأكتر من ${widget.voucher.limit} EGP",
                  textDirection: TextDirection.rtl,
                  style: TextStyling.subtitle.copyWith(
                      color: chosenVoucher.value == widget.voucher
                          ? backGroundColor
                          : primaryColor,
                      fontSize: 32.sp),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
