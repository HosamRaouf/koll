import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kol/components/address.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/screens/order_screen/drop_down_menu.dart';
import 'package:kol/screens/order_screen/orders_listview.dart';
import '../../components/myElevatedButton.dart';
import '../../components/phone_number.dart';
import '../../styles.dart';
import '../../components/my_alert_dialog.dart';
import '../no_internet_screen.dart';

class OrderScreen extends StatefulWidget {
  String? adress;
  String? phoneNumber;
  List<List<String>>? orderNames;
  List<String>? imageUrls;
  String? note;
  String? dateTime;
  String? cost;
  String? userName;
  String? userImage;

  OrderScreen(
      {Key? key,
      required this.adress,
      required this.cost,
      required this.dateTime,
      required this.imageUrls,
      required this.note,
      required this.orderNames,
      required this.phoneNumber,
      required this.userImage,
      required this.userName})
      : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState(
      address: adress,
      cost: cost,
      dateTime: dateTime,
      imageUrls: imageUrls,
      note: note,
      orderNames: orderNames,
      phoneNumber: phoneNumber,
      userImage: userImage,
      userName: userName);
}

class _OrderScreenState extends State<OrderScreen> {
  _OrderScreenState(
      {required this.address,
      required this.cost,
      required this.dateTime,
      required this.imageUrls,
      required this.note,
      required this.orderNames,
      required this.phoneNumber,
      required this.userImage,
      required this.userName});

  String? address;
  String? phoneNumber;
  List<List<String>>? orderNames;
  List<String>? imageUrls;
  String? note;
  String? dateTime;
  String? cost;
  String? userName;
  String? userImage;
  TextEditingController areYouSureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      builder: (BuildContext context, Widget? child) => Scaffold(
        body: SafeArea(
          child: InternetCheck(
            child: Container(
              decoration: BoxDecoration(
                  color: backGroundColor,
                  borderRadius: BorderRadius.circular(65.sp)),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.sp),
                child: SizedBox(
                  height: 1.sh,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [                        Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    OrderDropDownMenu(
                                        userName: userName,
                                        phoneNumber: phoneNumber,
                                        cost: cost,
                                        adress: address,
                                        orderNames: orderNames),
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                          EdgeInsets.symmetric(horizontal: 35.sp),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                height: 0.04.sw,
                                                child: Text(
                                                  'طلب بإسم',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayMedium
                                                      ?.copyWith(
                                                      fontSize: 30.sp,
                                                      color: smallFontColor
                                                          .withOpacity(0.7),
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 0.5.sw,
                                                height: 0.08.sw,
                                                child: Text(
                                                  userName!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  textAlign: TextAlign.end,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.copyWith(
                                                      fontSize: 50.sp,
                                                      color: primaryColor,
                                                      fontWeight: FontWeight.w600),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                            width: 0.06.sh,
                                            height: 0.06.sh,
                                            child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(100.sp),
                                                child: CachedAvatar(imageUrl: userImage!))),
                                      ],
                                    )
                                  ],
                                ),
                                  Address(address: address!),
                                  PhoneNumber(
                                    phoneNumber: phoneNumber!,
                                  ),
            
            
            
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.h,
                            ),
                            SizedBox(
                              width: 1040.w,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'الطلبات',
                                        textAlign: TextAlign.right,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                            fontSize: 55.sp,
                                            color: primaryColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      SizedBox(
                                        width: 15.sp,
                                      ),
                                      Icon(
                                        FontAwesomeIcons.cutlery,
                                        size: 50.sp,
                                        color: primaryColor,
                                      ),
                                    ],
                                  ),
                                  LimitedBox(
                                    maxHeight: 700.h,
                                    child: ScrollConfiguration(
                                      behavior: const ScrollBehavior(),
                                      child: GlowingOverscrollIndicator(
                                        axisDirection: AxisDirection.down,
                                        color: primaryColor,
                                        child: OrdersListView(
                                            imageUrls: imageUrls,
                                            orderNames: orderNames),
                                      ),
                                    ),
                                  ),
            
                                ],
                              ),
                            ),
            
                          ],
                        ),
                      ),
            
            
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          note! == ''
                              ? Container()
                              : Text(
                            ' ملحوظة: $note',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 30.sp,
                                color: primaryColor,
                                fontWeight: FontWeight.w500),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${cost!}EGP',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                        fontSize: 30.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'إجمالي الطلبات',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                        fontSize: 30.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '10EGP',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                        fontSize: 30.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'خدمة التوصيل',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                        fontSize: 30.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '-30%',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                        fontSize: 30.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'KOL30 كود خصم',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium
                                        ?.copyWith(
                                        fontSize: 30.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '155EGP',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                        fontSize: 50.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    'الإجمالي',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    textAlign: TextAlign.end,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displaySmall
                                        ?.copyWith(
                                        fontSize: 50.sp,
                                        color: primaryColor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20.sp,
                          ),
                          MyElevatedButton(
                              width: double.infinity,
                              enabled: true,
                              fontSize: 40.h,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              text: 'تأكيد',
                              gradient: true,
                              color: Colors.transparent,
                              textColor: Colors.white),
                          SizedBox(
                            height: 20.sp,
                          ),
                          MyElevatedButton(
                              width: double.infinity,
                              enabled: true,
                              fontSize: 40.h,
                              onPressed: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        MyAlertDialog(
                                          isFirstButtonRed: true,
                                          onFirstButtonPressed: () {},
                                          onSecondButtonPressed: () {},
                                          firstButton: 'رفض',
                                          secondButton: 'إلغاء',
                                          body: Container(),
                                          title:           'رفض الطلب؟',
                                          description:           'من فضلك وضّح للعميل ليه طلبه اترفض',
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
                          SizedBox(height: 15.sp),
                          Text(
                            dateTime!,
                            textAlign: TextAlign.left,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                fontSize: 30.sp,
                                color:
                                smallFontColor.withOpacity(0.7),
                                fontWeight: FontWeight.w400),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
