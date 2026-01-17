import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/my_alert_dialog.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/core/models/voucher_model.dart';
import 'package:kol/map.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../../components/loading.dart';
import '../../../styles.dart';

class VoucherWidget extends StatelessWidget {
  const VoucherWidget(
      {super.key,
      required this.voucher,
      required this.onDelete,
      required this.onEdit});

  final VoucherModel voucher;
  final Function() onDelete;
  final Function() onEdit;

  deleteVoucher() async {
    await restaurantDocument
        .collection('vouchers')
        .doc(voucher.firestoreId)
        .delete()
        .then((value) {
      restaurant['vouchers'].remove(restaurant['vouchers'][
          restaurant['vouchers']
              .indexWhere((element) => element['id'] == voucher.id)]);
      restaurantData.vouchers.remove(restaurantData.vouchers[restaurantData
          .vouchers
          .indexWhere((element) => element.id == voucher.id)]);
      onDelete();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: cardDecoration.copyWith(
          image: const DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/icons.png")),
          gradient: myGradient),
      height: double.infinity,
      width: 0.4.sw,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomLeft,
              child: Transform.translate(
                  offset: Offset(-45.sp, 45.sp),
                  child: Icon(
                    Iconsax.discount_shape,
                    color: Colors.white.withOpacity(0.12),
                    size: 300.sp,
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 24.sp, horizontal: 24.sp),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(voucher.name,
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge!
                            .copyWith(
                                fontSize: 52.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                        textDirection: TextDirection.rtl),
                    SizedBox(
                      height: 24.sp,
                    ),
                    Text(
                      'خصم ${voucher.discount}%',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 36.sp,
                              color: smallFontColor,
                              fontWeight: FontWeight.w400),
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(
                      height: 12.sp,
                    ),
                    Text(
                      'حد أدنى ${voucher.limit}EGP',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(
                              fontSize: 36.sp,
                              color: smallFontColor,
                              fontWeight: FontWeight.w400),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ),
            MyInkWell(
                onTap: () {
                  onEdit();
                },
                radius: 36.sp,
                child: Container()),
            Padding(
              padding: EdgeInsets.all(12.sp),
              child: Align(
                alignment: Alignment.topLeft,
                child: ClipOval(
                  child: Container(
                    width: 120.sp,
                    height: 120.sp,
                    color: warmColor.withOpacity(0.5),
                    child: IconButton(
                      padding: EdgeInsets.all(0.sp),
                      color: Colors.red,
                      splashRadius: 60.sp,
                      splashColor: Colors.red.withOpacity(0.5),
                      highlightColor: Colors.red.withOpacity(0.2),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return MyAlertDialog(
                                  controller: TextEditingController(),
                                  description: '',
                                  textfield: false,
                                  title: "حذف كود الخصم؟",
                                  body: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        voucher.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .copyWith(
                                                color: primaryColor,
                                                fontSize: 60.sp,
                                                fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 36.sp,
                                      ),
                                      const StyledDivider(
                                        thickness: 1,
                                        lineStyle: DividerLineStyle.solid,
                                      ),
                                      SizedBox(
                                        height: 36.sp,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${voucher.discount.toString()}%',
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    color: primaryColor,
                                                    fontSize: 40.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Text(
                                            "نسبة الخصم",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    color: primaryColor,
                                                    fontSize: 40.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${voucher.limit.toString()}EGP",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    color: primaryColor,
                                                    fontSize: 42.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                          Text(
                                            "الحد الأدنى",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    color: primaryColor,
                                                    fontSize: 42.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 24.sp,
                                      ),
                                      Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            voucher.time,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                    color: smallFontColor,
                                                    fontSize: 28.sp,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                    ],
                                  ),
                                  firstButton: 'حذف',
                                  secondButton: 'إلغاء',
                                  onFirstButtonPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => const Loading());
                                    deleteVoucher();
                                  },
                                  onSecondButtonPressed: () {},
                                  isFirstButtonRed: true);
                            });
                      },
                      icon: Icon(Iconsax.trash, color: Colors.red, size: 60.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
