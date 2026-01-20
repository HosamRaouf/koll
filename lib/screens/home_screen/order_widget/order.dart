import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_image.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/phone_number.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_storage/selectAndUploadImage.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/core/models/menu_models/item_model.dart';
import 'package:kol/core/models/order_model.dart';
import 'package:kol/core/models/user_models/user_model.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/drivers_screen/driver_profile/driver_profile.dart';
import 'package:kol/screens/home_screen/logic.dart';
import 'package:kol/screens/home_screen/order_widget/add_driver_dialog.dart';
import 'package:kol/screens/home_screen/order_widget/buttons.dart';
import 'package:kol/screens/home_screen/order_widget/choose_driver.dart';
import 'package:styled_divider/styled_divider.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../components/myElevatedButton.dart';
import '../../../components/pop_up_menu.dart';
import '../../../core/models/driver_model.dart';
import '../../../navigation_animations.dart';
import '../../../styles.dart';
import '../../restaurant_screen/category_screen/category_screen.dart';
import '../../users_screen/user_profile/user_profile_screen.dart';
import 'rate.dart';

Future fetchUser(String userId) async {
  late UserModel user;
  if (users.any((element) => element.firestoreId == userId)) {
    user = users[users.indexWhere((element) => element.firestoreId == userId)];
    return user;
  } else {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .get()
        .then((value) {
      user = UserModel.fromJson(value.data()!);
      if (!users.any((element) => element.firestoreId == userId)) {
        users.insert(users.length, user);
      }
      print(
          "================================================ ✅👤 ${user.name} Fetched 👤✅ ==========================================");
    });
    return user;
  }
}

class Order extends StatefulWidget {
  final OrderModel order;
  final Function() onOrderAccepted;
  final Function() onOrderCompleted;
  final Function(OrderModel order, DriverModel driver) onOrderSubmit;
  final Function(String) onDelete;
  final bool isDriverOrder;
  final UserModel user;
  final bool isKitchen;
  final Function()? onReady;
  final bool isLate;

  const Order(
      {Key? key,
      required this.order,
      required this.onOrderAccepted,
      required this.onOrderSubmit,
      required this.onOrderCompleted,
      required this.isDriverOrder,
      required this.user,
      this.isKitchen = false,
      this.onReady,
      required this.onDelete,
      required this.isLate})
      : super(key: key);

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  double get cartItemsTotal {
    double total = 0;
    for (var element in widget.order.items) {
      total += (element.size.price * element.quantity);
    }
    for (var element in widget.order.offers) {
      total += element.price;
    }
    return total;
  }

  double get total {
    final itemsTotal = cartItemsTotal;
    return itemsTotal -
        ((widget.order.voucher.discount / 100) * itemsTotal) +
        widget.order.deliveryFee.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsTotal = this.cartItemsTotal;
    final total = this.total;
    final orderNumber = widget.order.orderNumber == ""
        ? "000"
        : int.parse(widget.order.orderNumber) < 10
            ? "00${widget.order.orderNumber}"
            : int.parse(widget.order.orderNumber) < 100
                ? "0${widget.order.orderNumber}"
                : widget.order.orderNumber;

    print(orderNumber);

    return Padding(
      padding: EdgeInsets.all(kIsWeb ? 12.sp : 24.sp),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          decoration: cardDecoration.copyWith(
            borderRadius: BorderRadius.circular(40.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(kIsWeb ? 8.0.sp : 12.0.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.all(kIsWeb ? 8.sp : 12.sp),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      kIsWeb
                          ? Container()
                          : widget.order.state == "خلصان"
                              ? Container()
                              : MyPopUpMenu(
                                  options: [
                                    {
                                      'option': 'نسخ',
                                      'icon': Iconsax.copy,
                                      'onPressed': () {
                                        copyOrder(
                                            widget.order, context, widget.user);
                                      },
                                      'textColor': primaryColor,
                                    },
                                    {
                                      'option': 'مشاركة',
                                      'icon': Iconsax.share,
                                      'onPressed': () {
                                        shareOrder(widget.order, widget.user);
                                      },
                                      'textColor': primaryColor,
                                    }
                                  ],
                                  iconColor: primaryColor,
                                  color: Colors.white,
                                ),
                      widget.isLate
                          ? Container(
                              decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(1000.r)),
                              child: Padding(
                                padding:
                                    EdgeInsets.all(kIsWeb ? 8.0.sp : 8.0.sp),
                                child: Row(
                                  children: [
                                    Text(
                                      "بيستعجلك",
                                      style: TextStyling.headline.copyWith(
                                          color: Colors.white,
                                          fontSize: kIsWeb ? 18.sp : 36.sp),
                                    ),
                                    SizedBox(
                                      width: 4.sp,
                                    ),
                                    Icon(
                                      Iconsax.danger5,
                                      color: Colors.white,
                                      size: 18.sp,
                                    )
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: kIsWeb ? 36.h : 0.08.sw,
                              child: Text(
                                "أوردر رقم $orderNumber",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.copyWith(
                                        fontSize: kIsWeb ? 24.sp : 48.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              widget.order.time,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontSize: kIsWeb ? 14.sp : 48.sp,
                                      color: smallFontColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ]),
                    ],
                  ),
                ),
                const StyledDivider(
                  thickness: 1,
                  lineStyle: DividerLineStyle.solid,
                ),
                widget.isKitchen
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(
                            right: kIsWeb ? 8.sp : 24.sp,
                            left: kIsWeb ? 8.sp : 24.sp),
                        child: IgnorePointer(
                          ignoring: kIsWeb,
                          child: MyInkWell(
                            onTap: () {
                              Navigator.of(context).push(ScaleTransition5(
                                  UserProfile(user: widget.user)));
                            },
                            radius: 28.r,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 36.h,
                                      child: Text(
                                        'طلب بإسم',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                fontSize:
                                                    kIsWeb ? 18.sp : 30.sp,
                                                color: smallFontColor
                                                    .withOpacity(0.7),
                                                fontWeight: FontWeight.w400),
                                      ),
                                    ),
                                    Text(
                                      widget.user.name,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      textAlign: TextAlign.end,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.copyWith(
                                              fontSize: kIsWeb ? 24.sp : 48.sp,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 35.sp,
                                ),
                                SizedBox(
                                    width: 0.06.sh,
                                    height: 0.06.sh,
                                    child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100.sp),
                                        child: widget.user.imageUrl ==
                                                    'assets/images/user.png' ||
                                                widget.user.imageUrl == ""
                                            ? Image.asset(
                                                'assets/images/user.png',
                                                fit: BoxFit.cover)
                                            : CachedAvatar(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                    widget.user.imageUrl)))
                              ],
                            ),
                          ),
                        ),
                      ),
                widget.isKitchen
                    ? Container()
                    : const StyledDivider(
                        thickness: 1,
                        lineStyle: DividerLineStyle.solid,
                      ),
                widget.isKitchen
                    ? Container()
                    : SizedBox(
                        height: kIsWeb ? 0.sp : 24.sp,
                      ),
                widget.isKitchen
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kIsWeb ? 14.sp : 50.sp),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      MyInkWell(
                                        onTap: () {
                                          launchUrlString(
                                              "https://maps.google.com/?q=${widget.order.location.lat},${widget.order.location.long}");
                                        },
                                        radius: 10.r,
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              kIsWeb ? 8.sp : 8.0.sp),
                                          child: Text(
                                            "عرض العنوان",
                                            textAlign: TextAlign.end,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                    fontSize:
                                                        kIsWeb ? 12.sp : 36.sp,
                                                    color: Colors.blue,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              widget.order.location.name,
                                              textAlign: TextAlign.end,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      fontSize: kIsWeb
                                                          ? 18.sp
                                                          : 42.sp,
                                                      color: primaryColor,
                                                      fontWeight:
                                                          FontWeight.w700),
                                            ),
                                            SizedBox(
                                              width: kIsWeb ? 0.13.sw : 0.45.sw,
                                              child: Text(
                                                widget.order.location.address,
                                                textAlign: TextAlign.end,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .displayMedium
                                                    ?.copyWith(
                                                        fontSize: kIsWeb
                                                            ? 14.sp
                                                            : 36.sp,
                                                        color: smallFontColor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: kIsWeb ? 18.sp : 60.sp,
                                ),
                                Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: kIsWeb ? 14.sp : 40.sp,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: kIsWeb ? 12.sp : 24.sp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        right: kIsWeb ? 18.sp : 60.sp),
                                    child: MyInkWell(
                                      onTap: () {
                                        launchUrlString(
                                            "tel://${widget.order.phoneNumber}");
                                      },
                                      radius: 10.sp,
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        widget.order.phoneNumber.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                fontSize:
                                                    kIsWeb ? 18.sp : 40.sp,
                                                color: Colors.blue,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  FontAwesomeIcons.phone,
                                  size: kIsWeb ? 14.sp : 40.sp,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: kIsWeb ? 0.sp : 24.sp,
                            ),
                            const StyledDivider(
                              thickness: 1,
                              lineStyle: DividerLineStyle.solid,
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: kIsWeb ? 0.sp : 24.sp,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kIsWeb ? 18.sp : 50.sp),
                  child: Text(
                    'الطلبات',
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: kIsWeb ? 18.sp : 42.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                SizedBox(
                  height: kIsWeb ? 8.sp : 24.sp,
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: kIsWeb ? 18.sp : 50.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        children: List.generate(
                            widget.order.offers.length,
                            (index) => Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "عرض ${widget.order.offers[index].title}",
                                      textDirection: TextDirection.rtl,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                              fontSize: kIsWeb ? 18.sp : 36.sp),
                                    ),
                                    Text(
                                      "EGP ${widget.order.offers[index].price.toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: primaryColor,
                                              fontSize: kIsWeb ? 18.sp : 36.sp),
                                    ),
                                  ].reversed.toList(),
                                )),
                      ),
                      widget.order.offers.isEmpty
                          ? Container()
                          : SizedBox(
                              height: kIsWeb ? 0.sp : 24.sp,
                            ),
                      Column(
                          children:
                              List.generate(widget.order.items.length, (index) {
                        String itemId = widget.order.items[index].id;
                        String itemCategoryId =
                            widget.order.items[index].categoryId;
                        SizeModel itemSize = widget.order.items[index].size;
                        String size = itemSize.name;
                        int price = itemSize.price.round();
                        int categoryIndex = restaurantData.menu.indexWhere(
                            (element) => element.id == itemCategoryId);
                        CategoryModel category = categoryIndex < 0
                            ? restaurantData.menu[0]
                            : restaurantData.menu[categoryIndex];
                        int itemIndex = restaurantData.menu[categoryIndex].items
                            .indexWhere((element) => element.id == itemId);
                        ItemModel item = itemIndex < 0
                            ? category.items[0]
                            : category.items[itemIndex];

                        return IgnorePointer(
                          ignoring: kIsWeb,
                          child: MyInkWell(
                            radius: 24.sp,
                            onTap: () {
                              categoryIndex < 0 || itemIndex < 0
                                  ? showSnackBar(
                                      context: context,
                                      message: "صنف غير موجود حاليًا")
                                  : Navigator.push(
                                      context,
                                      ScaleTransition5(CategoryScreen(
                                          category: category,
                                          chosenItem: item)));
                            },
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: kIsWeb ? 8.sp : 24.sp),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Center(
                                      child: Text(
                                    'EGP ${(widget.order.items[index].quantity * price).toStringAsFixed(2)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium!
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor,
                                            fontSize: kIsWeb ? 14.sp : 36.sp),
                                  )),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: kIsWeb ? 18.sp : 40.sp),
                                        child: SizedBox(
                                          width: kIsWeb ? 0.1.sw : 0.5.sw,
                                          child: Text(
                                            itemIndex < 0 || categoryIndex < 0
                                                ? "x${widget.order.items[index].quantity} - صنف محذوف"
                                                : 'x${widget.order.items[index].quantity} ${category.name} - ${item.name} ($size)',
                                            textDirection: TextDirection.rtl,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium
                                                ?.copyWith(
                                                    fontSize:
                                                        kIsWeb ? 14.sp : 36.sp,
                                                    color: primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: kIsWeb ? 28.sp : 60.sp,
                                          height: kIsWeb ? 28.sp : 60.sp,
                                          child: categoryIndex < 0 ||
                                                  itemIndex < 0
                                              ? Image.asset(
                                                  "assets/images/nointernetavatar.png")
                                              : Image.asset(category.image))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                      const StyledDivider(
                        thickness: 1,
                        lineStyle: DividerLineStyle.solid,
                      ),
                    ],
                  ),
                ),
                widget.order.note == ''
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kIsWeb ? 18.sp : 70.sp,
                            vertical: kIsWeb ? 20.sp : 24.sp),
                        child: Text(
                          ' ملحوظة: ${widget.order.note}',
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.rtl,
                          style: TextStyling.headline
                              .copyWith(fontSize: kIsWeb ? 18.sp : 42.sp),
                        ),
                      ),
                widget.isKitchen
                    ? Container()
                    : SizedBox(
                        height: kIsWeb ? 0.sp : 24.sp,
                      ),
                widget.isKitchen
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kIsWeb ? 18.sp : 50.sp,
                            vertical: kIsWeb ? 0.sp : 12.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${cartItemsTotal.toStringAsFixed(2)} EGP'
                                  .toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textDirection: TextDirection.rtl,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: kIsWeb ? 18.sp : 36.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'إجمالي الطلبات',
                              textDirection: TextDirection.rtl,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: kIsWeb ? 18.sp : 36.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                widget.isKitchen
                    ? Container()
                    : widget.order.voucher.name.isNotEmpty
                        ? Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kIsWeb ? 18.sp : 50.sp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  child: Text(
                                    '- ${((widget.order.voucher.discount / 100) * cartItemsTotal).toStringAsFixed(2)} EGP'
                                        .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textDirection: TextDirection.rtl,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                            fontSize: kIsWeb ? 18.sp : 36.sp,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ),
                                Text(
                                  'كود خصم ${widget.order.voucher.name}',
                                  textDirection: TextDirection.rtl,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displayMedium
                                      ?.copyWith(
                                          fontSize: kIsWeb ? 18.sp : 36.sp,
                                          color: primaryColor,
                                          fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )
                        : Container(),
                widget.isKitchen
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kIsWeb ? 18.sp : 50.sp,
                            vertical: kIsWeb ? 8.sp : 12.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Text(
                                '${widget.order.deliveryFee.toStringAsFixed(2)} EGP '
                                    .toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: kIsWeb ? 18.sp : 36.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              'ضريبة التوصيل',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: kIsWeb ? 18.sp : 36.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                widget.isKitchen
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: kIsWeb ? 18.sp : 50.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              child: Text(
                                'EGP ${total.toStringAsFixed(2)}',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.end,
                                textDirection: TextDirection.rtl,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: kIsWeb ? 20.sp : 48.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w700),
                              ),
                            ),
                            Text(
                              'الإجمالي',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: kIsWeb ? 18.sp : 48.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                SizedBox(
                  height: kIsWeb ? 0.sp : 24.sp,
                ),
                widget.order.state == 'عند الكاشير'
                    ? OrderButtons(
                        onDelete: (body) {
                          widget.onDelete(body);
                        },
                        order: widget.order,
                        onOrderAccepted: widget.onOrderAccepted)
                    : widget.order.state == 'عالنار'
                        ? widget.isKitchen
                            ? Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: kIsWeb ? 18.sp : 50.sp),
                                child: MyElevatedButton(
                                  onPressed: widget.onReady ?? () {},
                                  text: 'جاهز',
                                  width: double.infinity,
                                  enabled: true,
                                  fontSize: kIsWeb ? 18.sp : 40.sp,
                                  color: Colors.transparent,
                                  gradient: true,
                                  textColor: Colors.white,
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: kIsWeb ? 8.sp : 12.sp),
                                  Text(
                                    "مستني الأوردر يجهز من المطبخ...",
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                    style: TextStyling.smallFont.copyWith(
                                        color: Colors.deepOrange,
                                        fontSize: kIsWeb ? 18.sp : 32.sp,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )
                        : widget.order.state == 'جاهز'
                            ? ChooseDriver(
                                order: widget.order,
                                onSubmit: (order, driver) =>
                                    widget.onOrderSubmit(order, driver))
                            : widget.order.state == 'في الطريق' ||
                                    widget.order.state == 'خلصان'
                                ? widget.isDriverOrder
                                    ? Container()
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: kIsWeb ? 14.sp : 24.sp),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            const StyledDivider(
                                              thickness: 1,
                                              lineStyle: DividerLineStyle.solid,
                                            ),
                                            Text(
                                              'الأوردر مع',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayMedium!
                                                  .copyWith(
                                                      color: primaryColor,
                                                      fontSize: kIsWeb
                                                          ? 18.sp
                                                          : 32.sp),
                                            ),
                                            SizedBox(
                                              height: kIsWeb ? 6.h : 12.sp,
                                            ),
                                            Container(
                                              decoration: cardDecoration,
                                              width: double.infinity,
                                              child: IgnorePointer(
                                                ignoring: kIsWeb,
                                                child: MyInkWell(
                                                  onTap: () {
                                                    bool driverExist = false;
                                                    late DriverModel driver;
                                                    for (var element
                                                        in restaurantData
                                                            .drivers) {
                                                      element.name ==
                                                              widget.order
                                                                  .driverName
                                                          ? {
                                                              driverExist =
                                                                  true,
                                                              driver = element
                                                            }
                                                          : {};
                                                    }

                                                    driverExist
                                                        ? Navigator.of(context)
                                                            .push(ScaleTransition5(
                                                                DriverProfile(
                                                                    driver:
                                                                        driver)))
                                                        : showDialog(
                                                            context: context,
                                                            builder: (context) {
                                                              TextEditingController
                                                                  nameController =
                                                                  TextEditingController();
                                                              TextEditingController
                                                                  phoneNumberController =
                                                                  TextEditingController();
                                                              String imagePath =
                                                                  'assets/images/user.png';
                                                              final ImagePicker
                                                                  imgpicker =
                                                                  ImagePicker();

                                                              nameController
                                                                      .text =
                                                                  widget.order
                                                                      .driverName;
                                                              phoneNumberController
                                                                      .text =
                                                                  widget.order
                                                                      .driverPhoneNumber;

                                                              Widget
                                                                  imageWidget =
                                                                  Image.asset(
                                                                      'assets/images/user.png');

                                                              return AddDriverDialog(
                                                                  phoneNumberController:
                                                                      phoneNumberController,
                                                                  nameController:
                                                                      nameController,
                                                                  imagePath:
                                                                      imagePath,
                                                                  imageWidget:
                                                                      imageWidget,
                                                                  selectImage: selectAndUploadImage(
                                                                      context,
                                                                      onUploaded:
                                                                          (url) {
                                                                    setState(
                                                                        () {
                                                                      imagePath =
                                                                          url;
                                                                      imageWidget =
                                                                          CachedAvatar(
                                                                              imageUrl: url);
                                                                    });
                                                                  }));
                                                            });
                                                  },
                                                  radius: 25.r,
                                                  child: Padding(
                                                    padding: EdgeInsets.all(
                                                        kIsWeb
                                                            ? 8.sp
                                                            : 24.0.sp),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        kIsWeb
                                                            ? Text(
                                                                widget.order
                                                                    .driverPhoneNumber,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .displayMedium
                                                                    ?.copyWith(
                                                                      fontSize:
                                                                          14.sp,
                                                                      color:
                                                                          primaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                              )
                                                            : PhoneNumber(
                                                                phoneNumber: widget
                                                                    .order
                                                                    .driverPhoneNumber),
                                                        SizedBox(
                                                          width: kIsWeb
                                                              ? 0.05.sw
                                                              : 0.28.sw,
                                                          child: Text(
                                                            widget.order
                                                                .driverName,
                                                            textDirection:
                                                                TextDirection
                                                                    .rtl,
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .displayLarge!
                                                                .copyWith(
                                                                    color:
                                                                        primaryColor,
                                                                    fontSize: kIsWeb
                                                                        ? 18.sp
                                                                        : 48.sp),
                                                          ),
                                                        ),
                                                        ClipOval(
                                                          child: MyImage(
                                                              width: kIsWeb
                                                                  ? 40.h
                                                                  : 100.h,
                                                              height: kIsWeb
                                                                  ? 40.h
                                                                  : 100.h,
                                                              image: widget
                                                                      .order
                                                                      .driverId
                                                                      .isNotEmpty
                                                                  ? widget.order
                                                                      .driverImage
                                                                  : 'assets/images/user.png'),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: kIsWeb ? 8.h : 24.sp,
                                            ),
                                            widget.order.state == 'خلصان'
                                                ? Container()
                                                : MyElevatedButton(
                                                    onPressed: () {
                                                      widget.onOrderCompleted();
                                                    },
                                                    text: 'وصل',
                                                    width: double.infinity,
                                                    enabled: true,
                                                    fontSize:
                                                        kIsWeb ? 18.sp : 40.sp,
                                                    color: Colors.transparent,
                                                    gradient: true,
                                                    textColor: Colors.white,
                                                  ),
                                            SizedBox(
                                              height: kIsWeb ? 8.h : 24.sp,
                                            ),
                                          ],
                                        ),
                                      )
                                : Container(),
                widget.order.state == 'خلصان' && widget.order.rate.rate != 0
                    ? Rate(
                        rate: widget.order.rate,
                      )
                    : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
