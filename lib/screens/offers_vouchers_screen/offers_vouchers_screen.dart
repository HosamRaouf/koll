import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/blank_screen.dart';
import 'package:kol/components/my_scroll_configurations.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/core/firestore_database/fetch/fetchAll.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/offers_vouchers_screen/offers/add_offer_screen.dart';
import 'package:kol/screens/offers_vouchers_screen/offers/offer_widget.dart';
import 'package:kol/screens/offers_vouchers_screen/vouchers/add_voucher_modal.dart';
import 'package:kol/screens/offers_vouchers_screen/vouchers/voucher_widget.dart';
import 'package:rive/rive.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../components/loading.dart';
import '../../components/my_flat_button.dart';
import '../../components/show_snack_bar.dart';
import '../../core/models/offer_model.dart';
import '../../core/models/voucher_model.dart';
import '../../navigation_animations.dart';
import '../../styles.dart';
import '../home_screen/home_screen.dart';
import 'logic.dart';

class OffersVouchersScreen extends StatefulWidget {
  const OffersVouchersScreen({super.key});

  @override
  State<OffersVouchersScreen> createState() => _OffersVouchersScreenState();
}

class _OffersVouchersScreenState extends State<OffersVouchersScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController limitController = TextEditingController();

  @override
  void initState() {
    super.initState();
    rebuildVouchers();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (BuildContext context, Widget? child) => BlankScreen(
            title: "العروض والكوبونات",
            child: Padding(
              padding: EdgeInsets.only(right: 42.sp, top: 12.sp, bottom: 12.sp),
              child: Column(
                children: [
                  SizedBox(
                    height: 24.sp,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyFlatButton(
                                textColor: primaryColor,
                                fontSize: 48.sp,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      ScaleTransition5(AddOfferScreen(
                                        offer: OfferModel(
                                            restaurantFirestoreId: "",
                                            id: '',
                                            firestoreId: '',
                                            image: '',
                                            title: '',
                                            meals: [],
                                            price: 0,
                                            deliveryFee: false),
                                        addOffer: (offer) {
                                          setState(() {
                                            restaurantData.offers.add(offer);
                                            restaurant['offers']
                                                .add(offer.toJson());
                                            Navigator.of(context).pop();
                                            showSnackBar(
                                                context: context,
                                                message:
                                                    'تم إضافة ${offer.title} بنجاح');
                                          });
                                        },
                                      )));
                                },
                                hint: 'إضافة عرض'),
                            Text(
                              'العروض',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: 40.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24.sp,
                        ),
                        restaurantData.offers.isNotEmpty
                            ? Padding(
                                padding: EdgeInsets.only(left: 42.sp),
                                child: SizedBox(
                                  height: 0.45.sh,
                                  child: MyScrollConfigurations(
                                    horizontal: false,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                            restaurantData.offers.length,
                                            (index) {
                                          OfferModel offer =
                                              restaurantData.offers[index];

                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 18.sp),
                                            child: OfferWidget(
                                                onDelete: () async {
                                                  print(
                                                      "================================================ 📡 Deleting ${restaurantData.offers[index].title} 📡 ==========================================");
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          const Loading(),
                                                      barrierDismissible:
                                                          false);
                                                  try {
                                                    await restaurantDocument
                                                        .collection('offers')
                                                        .doc(offer.firestoreId)
                                                        .delete();
                                                    print(
                                                        "================================================ 📡 ${restaurantData.offers[index].title} Deleted 📡 ==========================================");
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      restaurantData.offers
                                                          .remove(offer);
                                                      restaurant['offers']
                                                          .remove(restaurant[
                                                              'offers'][restaurant[
                                                                  'offers']
                                                              .indexWhere(
                                                                  (element) =>
                                                                      element[
                                                                          'id'] ==
                                                                      offer
                                                                          .id)]);
                                                      showSnackBar(
                                                          context: context,
                                                          message:
                                                              "تم حذف ${offer.title} بنجاح");
                                                    });
                                                  } catch (e) {
                                                    Navigator.pop(context);
                                                    print(
                                                        "================================================ 📡 Error Deleting ${restaurantData.offers[index].title} 📡 ==========================================");
                                                    print(e);
                                                  }
                                                },
                                                offer: restaurantData
                                                    .offers[index]),
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 0.38.sh,
                                child: Center(
                                    child: Text(
                                  "لا يوجد لديك عروض",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: primaryColor,
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w500),
                                )),
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  const StyledDivider(
                    thickness: 1,
                    lineStyle: DividerLineStyle.solid,
                  ),
                  SizedBox(
                    height: 24.sp,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MyFlatButton(
                                textColor: primaryColor,
                                fontSize: 48.sp,
                                backgroundColor: Colors.transparent,
                                onPressed: () {
                                  primaryBottomSheet(
                                      child: AddVoucher(
                                          isEdit: false,
                                          voucher: VoucherModel(
                                              id: '',
                                              firestoreId: '',
                                              limit: 0,
                                              time: '',
                                              name: '',
                                              discount: 0),
                                          onAdd: () {
                                            setState(() {
                                              rebuildVouchers();
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  ScaleTransition5(
                                                      const HomeScreen(
                                                    isKitchen: false,
                                                  )),
                                                  (route) => false);
                                              Navigator.push(
                                                  context,
                                                  ScaleTransition5(
                                                      const OffersVouchersScreen()));
                                            });
                                          },
                                          discountController:
                                              discountController,
                                          nameController: nameController,
                                          limitController: limitController),
                                      context: context);
                                },
                                hint: 'إضافة كوبون'),
                            Text(
                              'كوبونات الخصم',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(fontSize: 40.sp),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24.sp,
                        ),
                        restaurantData.vouchers.isNotEmpty ||
                                mainVouchers.isNotEmpty
                            ? Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 28.sp),
                                  child: MyScrollConfigurations(
                                    horizontal: true,
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            ...List.generate(vouchers.length,
                                                (index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 18.sp),
                                                child: VoucherWidget(
                                                    onDelete: () {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        rebuildVouchers();
                                                      });
                                                    },
                                                    onEdit: () {
                                                      setState(() {
                                                        discountController
                                                                .text =
                                                            vouchers[index]
                                                                .discount
                                                                .toString();
                                                        limitController.text =
                                                            vouchers[index]
                                                                .limit
                                                                .toString();
                                                        nameController.text =
                                                            vouchers[index]
                                                                .name
                                                                .toString();
                                                        primaryBottomSheet(
                                                            child: AddVoucher(
                                                                isEdit: true,
                                                                voucher:
                                                                    vouchers[
                                                                        index],
                                                                discountController:
                                                                    discountController,
                                                                nameController:
                                                                    nameController,
                                                                limitController:
                                                                    limitController,
                                                                onAdd: () {
                                                                  setState(() {
                                                                    rebuildVouchers();
                                                                    Navigator.pushAndRemoveUntil(
                                                                        context,
                                                                        ScaleTransition5(const HomeScreen(
                                                                          isKitchen:
                                                                              false,
                                                                        )),
                                                                        (route) => false);
                                                                    Navigator.push(
                                                                        context,
                                                                        ScaleTransition5(
                                                                            const OffersVouchersScreen()));
                                                                  });
                                                                }),
                                                            context: context);
                                                      });
                                                    },
                                                    voucher: vouchers[index]),
                                              );
                                            }),
                                            ...List.generate(
                                                mainVouchers.length,
                                                (index) => mainVoucherWidget(
                                                    mainVouchers[index],
                                                    context)),
                                          ]),
                                    ),
                                  ),
                                ),
                              )
                            : Expanded(
                                child: Center(
                                    child: Text(
                                  "لا يوجد لديك كوبونات خصم",
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium!
                                      .copyWith(
                                          color: primaryColor,
                                          fontSize: 36.sp,
                                          fontWeight: FontWeight.w500),
                                )),
                              )
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}

Widget mainVoucherWidget(VoucherModel voucher, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 24.sp),
    child: Container(
      decoration: cardDecoration.copyWith(
        color: Colors.black87,
        image: const DecorationImage(
            fit: BoxFit.cover, image: AssetImage("assets/images/icons.png")),
      ),
      height: double.infinity,
      width: 0.4.sw,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.r),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  height: 0.05.sh,
                  width: 0.05.sh,
                  child: const RiveAnimation.asset(
                    "assets/riv/logo.riv",
                    artboard: "New Artboard",
                    alignment: Alignment.topCenter,
                  ),
                )),
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
          ],
        ),
      ),
    ),
  );
}
