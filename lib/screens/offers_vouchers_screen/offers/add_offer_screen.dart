import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/blank_screen.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/myTextField.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/my_scroll_configurations.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_storage/selectAndUploadImage.dart';
import 'package:kol/core/firestore_database/getDocId.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/offers_vouchers_screen/offers/menu_screen/menu_screen.dart';
import 'package:kol/screens/offers_vouchers_screen/offers_vouchers_screen.dart';
import 'package:kol/styles.dart';
import 'package:styled_divider/styled_divider.dart';

import '../../../components/loading.dart';
import '../../../components/my_flat_button.dart';
import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/offer_model.dart';
import '../../../navigation_animations.dart';
import 'menu_screen/logic.dart';
import 'offer_item_widget.dart';

class AddOfferScreen extends StatefulWidget {
  final Function(OfferModel offer) addOffer;
  final OfferModel offer;

  const AddOfferScreen(
      {super.key, required this.addOffer, required this.offer});

  @override
  State<AddOfferScreen> createState() => _AddOfferScreenState();
}

class _AddOfferScreenState extends State<AddOfferScreen> {
  bool deliveryFee = false;
  String offerNameError = "";
  String offerTotalError = "";
  String offerImagePath = "";
  String offerImageError = "";
  bool offerItemsEmpty = false;
  TextEditingController offerNameController = TextEditingController();
  TextEditingController offerPriceController = TextEditingController();

  @override
  void dispose() {
    meals = [];
    total = 0;
    offerPriceController.dispose();
    offerNameController.dispose();
    super.dispose();
  }

  addOffer() async {
    OfferModel offer = OfferModel(
        id: uuid.v1(),
        firestoreId: "",
        restaurantFirestoreId: restaurantData.id,
        image: offerImagePath,
        title: offerNameController.text,
        meals: meals,
        price: int.parse(offerPriceController.text),
        deliveryFee: !deliveryFee);

    showDialog(
        context: context,
        builder: (context) => const Loading(),
        barrierDismissible: false);

    restaurantDocument
        .collection('offers')
        .add(offer.toJson())
        .then((value) async {
      await getDocId(
              docWhere: restaurantDocument
                  .collection('offers')
                  .where('id', isEqualTo: offer.id))
          .then((id) async {
        await restaurantDocument
            .collection('offers')
            .doc(id)
            .update({'firestoreId': id}).then((value) {
          offer.firestoreId = id;
          widget.addOffer(offer);
          Navigator.pushAndRemoveUntil(
              context,
              ScaleTransition5(const HomeScreen(
                isKitchen: false,
              )),
              (route) => false);
          Navigator.push(
              context, ScaleTransition5(const OffersVouchersScreen()));
          showSnackBar(context: context, message: "تم إضافة ${offer.title}");
        });
      });
    });
  }

  updateOffer() {
    widget.offer.image = offerImagePath;
    widget.offer.meals = meals;
    widget.offer.title = offerNameController.text;
    widget.offer.price = int.parse(offerPriceController.text);
    widget.offer.deliveryFee = !deliveryFee;
    showDialog(
        context: context,
        builder: (context) => const Loading(),
        barrierDismissible: false);

    restaurantDocument
        .collection('offers')
        .doc(widget.offer.firestoreId)
        .update(widget.offer.toJson())
        .then((value) {
      widget.addOffer(widget.offer);
      Navigator.pushAndRemoveUntil(
          context,
          ScaleTransition5(const HomeScreen(
            isKitchen: false,
          )),
          (route) => false);
      Navigator.push(context, ScaleTransition5(const OffersVouchersScreen()));
      showSnackBar(context: context, message: "تم التعديل");
    });
  }

  validate({required Function() then}) {
    if (offerNameController.text.isEmpty ||
        offerPriceController.text.isEmpty ||
        offerPriceController.text.isEmpty ||
        offerImagePath.isEmpty ||
        meals.isEmpty) {
      if (offerNameController.text.isEmpty) {
        setState(() {
          offerNameError = "من فضلك أدخل اسم العرض";
        });
      } else {
        setState(() {
          offerNameError = "";
        });
      }
      if (offerPriceController.text.isEmpty) {
        setState(() {
          offerTotalError = "من فضلك أدخل إجمالي سعر العرض";
        });
      } else {
        setState(() {
          offerTotalError = "";
        });
      }
      if (offerImagePath.isEmpty) {
        setState(() {
          offerImageError = "من فضلك اختر صورة للعرض";
        });
      } else {
        setState(() {
          offerImageError = "";
        });
      }
      if (meals.isEmpty) {
        setState(() {
          offerItemsEmpty = true;
        });
      } else {
        setState(() {
          offerItemsEmpty = false;
        });
      }
    } else {
      if (int.parse(offerPriceController.text) > total) {
        setState(() {
          offerTotalError = "العرض سعره أوفر بصراحة مش هينفع والله";
        });
      } else {
        then();
      }
    }
  }

  @override
  void initState() {
    if (widget.offer.id != "") {
      deliveryFee = !widget.offer.deliveryFee;
      offerPriceController.text = widget.offer.price.toString();
      offerNameController.text = widget.offer.title;
      meals = widget.offer.meals;
      offerImagePath = widget.offer.image;
      for (var element in widget.offer.meals) {
        total = total + element.size.price;
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        useInheritedMediaQuery: true,
        builder: ((BuildContext context, Widget? child) => Scaffold(
              body: BlankScreen(
                title: "إضافة عرض",
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: 1.sp, horizontal: 40.sp),
                  child: Stack(
                    children: [
                      MyScrollConfigurations(
                        horizontal: false,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    height: 40.sp,
                                  ),
                                  MyTextField(
                                      descriptionTextField: false,
                                      error: offerNameError,
                                      controller: offerNameController,
                                      type: "normal",
                                      hintText: "عرض العيلة",
                                      isExpanding: false,
                                      title: "اسم العرض",
                                      isValidatable: true,
                                      maxLength: 25),
                                  SizedBox(
                                    height: 36.sp,
                                  ),
                                  offerImagePath.isEmpty
                                      ? Stack(
                                          children: [
                                            Container(
                                              decoration:
                                                  cardDecoration.copyWith(
                                                      gradient: myGradient),
                                              height: 0.15.sh,
                                              width: double.infinity,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "اختر صورة العرض",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayLarge!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 40.sp),
                                                    ),
                                                    Text(
                                                      "يفضّل مساحة 790*200",
                                                      textDirection:
                                                          TextDirection.rtl,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .displayMedium!
                                                          .copyWith(
                                                              color:
                                                                  smallFontColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 28.sp),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Material(
                                                color: Colors.transparent,
                                                child: MyInkWell(
                                                    onTap: () {
                                                      selectAndUploadImage(
                                                          context,
                                                          onUploaded: (url) {
                                                        setState(() {
                                                          offerImagePath = url;
                                                          offerImageError = "";
                                                        });
                                                      });
                                                    },
                                                    radius: 28.sp,
                                                    child: SizedBox(
                                                      height: 0.15.sh,
                                                      width: double.infinity,
                                                    ))),
                                          ],
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(24.r),
                                          child: Stack(
                                            children: [
                                              SizedBox(
                                                  height: 0.15.sh,
                                                  width: double.infinity,
                                                  child: Stack(
                                                    children: [
                                                      SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: CachedAvatar(
                                                            imageUrl:
                                                                offerImagePath,
                                                            fit: BoxFit.cover,
                                                            borderRadius: 24.r,
                                                          )),
                                                      MyInkWell(
                                                          onTap: () {
                                                            selectAndUploadImage(
                                                                context,
                                                                onUploaded:
                                                                    (url) {
                                                              setState(() {
                                                                offerImagePath =
                                                                    url;
                                                                offerImageError =
                                                                    "";
                                                              });
                                                            });
                                                          },
                                                          radius: 24.r,
                                                          child: Container(
                                                            height: 0.15.sh,
                                                          ))
                                                    ],
                                                  )),
                                              Padding(
                                                padding:
                                                    EdgeInsets.all(12.0.sp),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.sp),
                                                  child: Container(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    width: 250.w,
                                                    child: Material(
                                                      color: Colors.white
                                                          .withOpacity(0.3),
                                                      child: MyInkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            offerImageError =
                                                                "";
                                                            offerImagePath = "";
                                                          });
                                                        },
                                                        radius: 16.r,
                                                        child: Center(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    12.0.sp),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  "حذف الصورة",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .displayMedium!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize: 32
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                ),
                                                                Icon(
                                                                  Iconsax.trash,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 40.sp,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  offerImageError.isNotEmpty
                                      ? Text(
                                          offerImageError,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!
                                              .copyWith(
                                                  color: Colors.red,
                                                  fontSize: 32.sp),
                                        )
                                      : Container(),
                                  SizedBox(
                                    height: 36.sp,
                                  ),
                                  const StyledDivider(
                                    thickness: 1,
                                    lineStyle: DividerLineStyle.solid,
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          MyFlatButton(
                                              textColor: primaryColor,
                                              fontSize: 48.sp,
                                              backgroundColor:
                                                  Colors.transparent,
                                              onPressed: () {
                                                setState(() {
                                                  getItems(0);
                                                });
                                                restaurantData.menu.isNotEmpty
                                                    ? Navigator.push(context,
                                                        SizeRTLNavigationTransition(
                                                            MenuScreen(
                                                                onAddMeal: () {
                                                        setState(() {
                                                          meals.add(OrderItemModel(
                                                              id: thisItem.id,
                                                              quantity: 1,
                                                              firestoreItemId:
                                                                  thisItem
                                                                      .firestoreId,
                                                              categoryId:
                                                                  firstCategory
                                                                      .id,
                                                              firestoreCategoryId:
                                                                  firstCategory
                                                                      .firestoreId,
                                                              size:
                                                                  choosenSize));
                                                          total = total +
                                                              choosenSize.price;
                                                          offerItemsEmpty =
                                                              false;
                                                        });
                                                      })))
                                                    : showSnackBar(
                                                        context: context,
                                                        message:
                                                            'المنيو بتاعتك فاضية، اختر أصناف المنيو من الملف الشخصي');
                                              },
                                              hint: 'إضافة صنف'),
                                          SizedBox(
                                            height: 36.sp,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Text(
                                                'الأصناف (${meals.length})',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(fontSize: 40.sp),
                                              ),
                                              SizedBox(
                                                width: 24.sp,
                                              ),
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                width: 0.4.sw,
                                                child: MyScrollConfigurations(
                                                  horizontal: true,
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: List.generate(
                                                          meals.length,
                                                          (index) {
                                                        CategoryModel category =
                                                            restaurantData.menu[restaurantData
                                                                .menu
                                                                .indexWhere((element) =>
                                                                    element
                                                                        .id ==
                                                                    meals[index]
                                                                        .categoryId)];

                                                        return Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0.sp),
                                                          child: SizedBox(
                                                            width: 50.sp,
                                                            height: 50.sp,
                                                            child: Image.asset(
                                                                category.image),
                                                          ),
                                                        );
                                                      }).reversed.toList(),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ].reversed.toList(),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 24.sp,
                                      ),
                                      offerItemsEmpty
                                          ? Center(
                                              child: Text(
                                                "من فضلك اختر أصناف العرض",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        color: Colors.red,
                                                        fontSize: 32.sp),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 0.22.sh,
                                        width: double.infinity,
                                        child: MyScrollConfigurations(
                                          horizontal: false,
                                          child: SingleChildScrollView(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: List.generate(
                                                    meals.length,
                                                    (index) => OfferItem(
                                                          onDelete: () {
                                                            setState(() {
                                                              total = total -
                                                                  meals[index]
                                                                      .size
                                                                      .price;
                                                              meals.remove(
                                                                  meals[index]);
                                                              if (meals
                                                                  .isEmpty) {
                                                                offerItemsEmpty =
                                                                    true;
                                                              }
                                                            });
                                                          },
                                                          size:
                                                              meals[index].size,
                                                          categoryId:
                                                              meals[index]
                                                                  .categoryId,
                                                          id: meals[index].id,
                                                        ))),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              color: WidgetsBinding
                                          .instance.window.viewInsets.bottom >
                                      0.0
                                  ? backGroundColor
                                  : Colors.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 36.sp,
                                  ),
                                  const StyledDivider(
                                    thickness: 1,
                                    lineStyle: DividerLineStyle.solid,
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  MyTextField(
                                    descriptionTextField: false,
                                    error: offerTotalError,
                                    controller: offerPriceController,
                                    type: 'number',
                                    hintText: 'إجمالي سعر العرض',
                                    isExpanding: false,
                                    title: "إجمالي سعر العرض",
                                    isValidatable: true,
                                    maxLength: 4,
                                    onChanged: (text) {},
                                    onSubmit: () {},
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      total.round() != 0
                                          ? Text(
                                              'بدلاً من $total EGP',
                                              textDirection: TextDirection.rtl,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      color: primaryColor,
                                                      fontSize: 36.sp,
                                                      decoration: TextDecoration
                                                          .lineThrough),
                                            )
                                          : Container(),
                                      MyInkWell(
                                        radius: 24.sp,
                                        onTap: () {
                                          setState(() {
                                            deliveryFee = !deliveryFee;
                                          });
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 24.sp,
                                              horizontal: 24.sp),
                                          child: Row(
                                            children: [
                                              Text(
                                                "التوصيل مجاناً",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium!
                                                    .copyWith(
                                                        fontWeight: deliveryFee
                                                            ? FontWeight.w700
                                                            : FontWeight.w400,
                                                        color: deliveryFee
                                                            ? primaryColor
                                                            : smallFontColor,
                                                        fontSize: 40.sp),
                                              ),
                                              SizedBox(
                                                width: 24.sp,
                                              ),
                                              Container(
                                                width: 60.sp,
                                                height: 60.sp,
                                                decoration:
                                                    cardDecoration.copyWith(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16.r),
                                                        color: deliveryFee
                                                            ? primaryColor
                                                            : smallFontColor),
                                                child: deliveryFee
                                                    ? Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 48.sp,
                                                      )
                                                    : Container(),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 24.sp,
                                  ),
                                  MyElevatedButton(
                                    onPressed: () {
                                      validate(then: () {
                                        widget.offer.firestoreId != ""
                                            ? updateOffer()
                                            : addOffer();
                                      });
                                    },
                                    text: widget.offer.firestoreId == ""
                                        ? "إضافة العرض"
                                        : "تعديل العرض",
                                    width: double.infinity,
                                    enabled: true,
                                    fontSize: 40.sp,
                                    color: Colors.transparent,
                                    gradient: true,
                                    textColor: Colors.white,
                                  ),
                                  SizedBox(
                                    height: 40.sp,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )));
  }
}
