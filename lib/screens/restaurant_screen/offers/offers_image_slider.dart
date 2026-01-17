import 'package:carousel_slider/carousel_slider.dart' as cc;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/my_flat_button.dart';
import 'package:kol/components/showLoading.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:kol/screens/restaurant_screen/restaurant_screen.dart';
import 'package:kol/styles.dart';

import '../../../components/show_snack_bar.dart';
import '../../../core/models/offer_model.dart';
import '../../../navigation_animations.dart';
import '../../offers_vouchers_screen/offers/add_offer_screen.dart';
import '../../offers_vouchers_screen/offers/offer_widget.dart'; // import this

class OffersImageSlider extends StatelessWidget {
  final cc.CarouselSliderController buttonCarouselController =
      cc.CarouselSliderController();
  List<OfferModel> offers;

  OffersImageSlider({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(
              image: AssetImage("assets/images/icons2.png"), fit: BoxFit.cover),
          gradient: myGradient),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 24.sp, bottom: 24.sp, left: 40.sp, right: 40.sp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyFlatButton(
                    textColor: Colors.white,
                    fontSize: 48.sp,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          ScaleTransition5(AddOfferScreen(
                            offer: OfferModel(
                                id: '',
                                firestoreId: '',
                                restaurantFirestoreId: "",
                                image: '',
                                title: '',
                                meals: [],
                                price: 0,
                                deliveryFee: false),
                            addOffer: (offer) {
                              restaurantData.offers.add(offer);
                              restaurant['offers'].add(offer.toJson());
                              Navigator.of(context).pushAndRemoveUntil(
                                  ScaleTransition5(const HomeScreen(
                                    isKitchen: false,
                                  )),
                                  (route) => false);
                              Navigator.push(context,
                                  ScaleTransition5(const RestaurantScreen()));
                              showSnackBar(
                                  context: context,
                                  message: 'تم إضافة ${offer.title} بنجاح');
                            },
                          )));
                    },
                    hint: 'إضافة عرض'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: backGroundColor,
                      size: 62.h,
                    ),
                    SizedBox(
                      width: 24.sp,
                    ),
                    Text(
                      "آخر العروض",
                      style: TextStyling.subtitle.copyWith(
                          fontSize: 52.sp,
                          color: backGroundColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                )
              ],
            ),
          ),
          offers.isNotEmpty
              ? cc.CarouselSlider(
                  items: List.generate(
                      offers.length,
                      (index) => OfferWidget(
                            offer: offers[index],
                            onDelete: () async {
                              print(
                                  "================================================ 📡 Deleting ${restaurantData.offers[index].title} 📡 ==========================================");
                              showLoading(context);
                              try {
                                await restaurantDocument
                                    .collection('offers')
                                    .doc(offers[index].firestoreId)
                                    .delete();
                                print(
                                    "================================================ 📡 ${restaurantData.offers[index].title} Deleted 📡 ==========================================");
                                Navigator.pop(context);
                                restaurantData.offers.remove(offers[index]);
                                restaurant['offers'].remove(restaurant['offers']
                                    [
                                    restaurant['offers'].indexWhere((element) =>
                                        element['id'] == offers[index].id)]);
                                showSnackBar(
                                    context: context,
                                    message:
                                        "تم حذف ${offers[index].title} بنجاح");
                              } catch (e) {
                                Navigator.pop(context);
                                print(
                                    "================================================ 📡 Error Deleting ${restaurantData.offers[index].title} 📡 ==========================================");
                                print(e);
                              }
                            },
                          )),
                  carouselController: buttonCarouselController,
                  options: cc.CarouselOptions(
                    aspectRatio: 16 / 8,
                    padEnds: true,
                    height: 0.15.sh,
                    initialPage: 0,
                    enableInfiniteScroll:
                        restaurantData.offers.length <= 2 ? false : true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 5),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.easeInOutCubic,
                    enlargeCenterPage: true,
                    enlargeFactor: 0.4.sp,
                    scrollDirection: Axis.horizontal,
                  ))
              : Center(
                  child: Text('لا يوجد لديك عروض في الوقت الحالي',
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 36.sp, color: primaryColor),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center)),
          offers.isNotEmpty
              ? SizedBox(
                  height: 84.sp,
                )
              : Container()
        ],
      ),
    );
  }
}
