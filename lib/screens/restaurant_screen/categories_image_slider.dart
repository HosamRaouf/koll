import 'package:carousel_slider/carousel_slider.dart' as cc;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/my_flat_button.dart';
import 'package:kol/screens/restaurant_screen/restaurant_modal_bottom_sheet.dart';
import 'package:kol/styles.dart';

import '../../core/models/menu_models/category_model.dart';

class CategoriesImageSlider extends StatefulWidget {
  CategoriesImageSlider({super.key, required this.map, required this.isEdit});

  CategoryModel map;
  bool isEdit;
  @override
  State<CategoriesImageSlider> createState() => _CategoriesImageSliderState();
}

class _CategoriesImageSliderState extends State<CategoriesImageSlider> {
  final cc.CarouselSliderController buttonCarouselController =
      cc.CarouselSliderController();

  List<Widget> offersWidgets = [];

  List<Widget> food = [];
  List<Widget> dessert = [];
  List<Widget> drinks = [];

  List<String> foodAssets = [];
  List<String> dessertAssets = [];
  List<String> drinksAssets = [];

  Color color1 = primaryColor.withOpacity(0.2);
  Color color2 = Colors.transparent;
  Color color3 = Colors.transparent;

  @override
  void initState() {
    for (var i = 1; i < 24; i++) {
      foodAssets.add(
        'assets/images/food/$i.png',
      );
      food.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: SizedBox(
              height: 0.15.sh,
              width: double.infinity,
              child: Image.asset(
                'assets/images/food/$i.png',
                fit: BoxFit.fitHeight,
              )),
        ),
      );
    }
    for (var i = 1; i < 14; i++) {
      dessertAssets.add(
        'assets/images/dessert/$i.png',
      );
      dessert.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: SizedBox(
              height: 0.15.sh,
              width: double.infinity,
              child: Image.asset(
                'assets/images/dessert/$i.png',
                fit: BoxFit.fitHeight,
              )),
        ),
      );
    }
    for (var i = 1; i < 8; i++) {
      drinksAssets.add(
        'assets/images/drinks/$i.png',
      );
      drinks.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: SizedBox(
              height: 0.15.sh,
              width: double.infinity,
              child: Image.asset(
                'assets/images/drinks/$i.png',
                fit: BoxFit.fitHeight,
              )),
        ),
      );
    }

    String image;

    widget.map.id.isNotEmpty
        ? {
            image = widget.map.image,
            if (widget.map.type == 'food')
              {
                color1 = primaryColor.withOpacity(0.2),
                color2 = Colors.transparent,
                color3 = Colors.transparent,
                RestaurantModalBottomSheet.type = 'food',
                RestaurantModalBottomSheet.index = foodAssets
                    .indexWhere((element) => element == widget.map.image),
              }
            else if (widget.map.type == 'dessert')
              {
                color1 = Colors.transparent,
                color2 = primaryColor.withOpacity(0.2),
                color3 = Colors.transparent,
                RestaurantModalBottomSheet.type = 'dessert',
                RestaurantModalBottomSheet.index = dessertAssets
                    .indexWhere((element) => element == widget.map.image),
              }
            else if (widget.map.type == 'drinks')
              {
                color1 = Colors.transparent,
                color2 = Colors.transparent,
                color3 = primaryColor.withOpacity(0.2),
                RestaurantModalBottomSheet.type = 'drinks',
                RestaurantModalBottomSheet.index = drinksAssets
                    .indexWhere((element) => element == widget.map.image),
              }
            else
              {print(widget.map)}
          }
        : {print('naaah')};

    if (widget.isEdit) {
      if (RestaurantModalBottomSheet.type == 'food') {
        RestaurantModalBottomSheet.index =
            foodAssets.indexWhere((element) => element == widget.map.image) + 1;
      } else if (RestaurantModalBottomSheet.type == 'dessert') {
        RestaurantModalBottomSheet.index =
            dessertAssets.indexWhere((element) => element == widget.map.image) +
                1;
      } else if (RestaurantModalBottomSheet.type == 'drinks') {
        RestaurantModalBottomSheet.index =
            drinksAssets.indexWhere((element) => element == widget.map.image) +
                1;
      }
    } else {
      RestaurantModalBottomSheet.index = 1;
      RestaurantModalBottomSheet.type = 'food';
    }

// buttonCarouselController.jumpToPage(RestaurantModalBottomSheet.index);

    // buttonCarouselController.animateToPage(RestaurantModalBottomSheet.index);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(RestaurantModalBottomSheet.index);

    return Column(
      children: [
        SizedBox(
          height: 24.sp,
        ),
        Text(
          'اختر شكل الصنف',
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontSize: 40.sp),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MyFlatButton(
                textColor: primaryColor,
                fontSize: 48.sp,
                backgroundColor: color3,
                onPressed: () {
                  setState(() {
                    buttonCarouselController.animateToPage(0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutCubic);
                    RestaurantModalBottomSheet.index = 1;
                    color1 = Colors.transparent;
                    color2 = Colors.transparent;
                    color3 = primaryColor.withOpacity(0.2);
                    RestaurantModalBottomSheet.type = 'drinks';
                  });
                },
                hint: 'مشروبات'),
            MyFlatButton(
                textColor: primaryColor,
                backgroundColor: color2,
                fontSize: 48.sp,
                onPressed: () {
                  setState(() {
                    buttonCarouselController.animateToPage(0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutCubic);
                    RestaurantModalBottomSheet.index = 1;
                    color1 = Colors.transparent;
                    color3 = Colors.transparent;
                    color2 = primaryColor.withOpacity(0.2);
                    RestaurantModalBottomSheet.type = 'dessert';
                  });
                },
                hint: 'حلو'),
            MyFlatButton(
                textColor: primaryColor,
                fontSize: 48.sp,
                backgroundColor: color1,
                onPressed: () {
                  setState(() {
                    buttonCarouselController.animateToPage(0,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOutCubic);
                    RestaurantModalBottomSheet.index = 1;
                    RestaurantModalBottomSheet.type = 'food';
                    color3 = Colors.transparent;
                    color2 = Colors.transparent;
                    color1 = primaryColor.withOpacity(0.2);
                  });
                },
                hint: 'حادق'),
          ],
        ),
        SizedBox(
          height: 24.sp,
        ),
        Padding(
          padding: EdgeInsets.only(top: 24.sp),
          child: cc.CarouselSlider(
              items: RestaurantModalBottomSheet.type == 'food'
                  ? food
                  : RestaurantModalBottomSheet.type == 'dessert'
                      ? dessert
                      : drinks,
              carouselController: buttonCarouselController,
              options: cc.CarouselOptions(
                onPageChanged: (index, r) {
                  setState(() {
                    RestaurantModalBottomSheet.index = index + 1;
                  });
                },
                aspectRatio: 16 / 8,
                height: 300.h,
                viewportFraction: 2.sp,
                initialPage: widget.isEdit
                    ? RestaurantModalBottomSheet.index - 1
                    : RestaurantModalBottomSheet.index - 1,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 500),
                autoPlayCurve: Curves.easeInOutCubic,
                enlargeCenterPage: true,
                enlargeFactor: 0.5,
                scrollDirection: Axis.horizontal,
              )),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 64.sp,
                onPressed: () {
                  buttonCarouselController.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);
                },
                icon: Icon(
                  Icons.arrow_left_rounded,
                  size: 96.sp,
                  color: primaryColor,
                )),
            Text(
              '${RestaurantModalBottomSheet.index.toString()} / ${RestaurantModalBottomSheet.type == 'food' ? '23' : RestaurantModalBottomSheet.type == 'dessert' ? '13' : '7'}',
              style: Theme.of(context)
                  .textTheme
                  .displayMedium!
                  .copyWith(fontSize: 36.sp, color: smallFontColor),
            ),
            IconButton(
                padding: EdgeInsets.zero,
                splashRadius: 64.sp,
                onPressed: () {
                  buttonCarouselController.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic);
                },
                icon: Icon(
                  Icons.arrow_right_rounded,
                  size: 96.sp,
                  color: primaryColor,
                )),
          ],
        ),
      ],
    );
  }
}
