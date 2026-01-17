import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:share_plus/share_plus.dart';
import '../../components/myElevatedButton.dart';
import '../../components/show_snack_bar.dart';
import '../../styles.dart';
import '../../components/my_alert_dialog.dart';

class ConfirmOrderModelSheet extends StatefulWidget {
  ConfirmOrderModelSheet(
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

  String? adress;
  int? phoneNumber;
  List<List<String>>? orderNames;
  List<String>? imageUrls;
  String? note;
  String? dateTime;
  String? cost;
  String? userName;
  String? userImage;

  @override
  State<ConfirmOrderModelSheet> createState() => _ConfirmOrderModelSheetState(
      adress: adress,
      cost: cost,
      dateTime: dateTime,
      imageUrls: imageUrls,
      note: note,
      orderNames: orderNames,
      phoneNumber: phoneNumber,
      userImage: userImage,
      userName: userName);
}

class _ConfirmOrderModelSheetState extends State<ConfirmOrderModelSheet> {
  _ConfirmOrderModelSheetState(
      {required this.adress,
      required this.cost,
      required this.dateTime,
      required this.imageUrls,
      required this.note,
      required this.orderNames,
      required this.phoneNumber,
      required this.userImage,
      required this.userName});

  String? adress;
  int? phoneNumber;
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
    return SafeArea(
      child: IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
              color: backGroundColor,
              borderRadius: BorderRadius.circular(65.sp)),
          child: SingleChildScrollView(

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.sp, vertical: 20.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient:  LinearGradient(
                                    colors: [primaryColor, accentColor]),
                                borderRadius: BorderRadius.circular(100.sp)),
                            width: 100.h,
                            height: 100.h,
                            child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.share,
                                  color: Colors.white,
                                  size: 70.sp,
                                ),
                                onPressed: () {
                                  String orders = '';
                                  for (var element in orderNames!) {
                                    orders =
                                        '$orders\n🍽 : ${element[0]} - 💲 : ${element[1]}EGP';
                                  }
                                  Share.share(
                                      subject: 'بيانات الطلب',
                                      '👤 : ${userName!} \n🚩 : ${adress!} \n📞 : ${phoneNumber!} \n📋 $orders  \n💰 : ${cost!}EGP');
                                }),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.sp),
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient:  LinearGradient(
                                      colors: [primaryColor, accentColor]),
                                  borderRadius: BorderRadius.circular(100.sp)),
                              width: 100.h,
                              height: 100.h,
                              child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.copy,
                                    color: Colors.white,
                                    size: 70.sp,
                                  ),
                                  onPressed: () {
                                    String orders = '';
                                    for (var element in orderNames!) {
                                      orders =
                                          '$orders\n🍽 : ${element[0]} - 💲 : ${element[1]}EGP';
                                    }
                                    Navigator.pop(context);
                                    Clipboard.setData(ClipboardData(
                                            text:
                                                '👤 : ${userName!} \n🚩 : ${adress!} \n📞 : ${phoneNumber!} \n📋 $orders  \n💰 : ${cost!}EGP'))
                                        .then(
                                      (value) {
                                        showSnackBar(context: context, message:                                                   'تم نسخ معلومات الطلب بنجاح',
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35.sp),
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
                                        color: smallFontColor.withOpacity(0.7),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 40.sp),
                                  child: SizedBox(
                                    width: 0.55.sw,
                                    child: Text(
                                      adress!,
                                      textAlign: TextAlign.end,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                              fontSize: 30.sp,
                                              color: primaryColor,
                                              fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                                Icon(
                                  FontAwesomeIcons.locationDot,
                                  size: 40.sp,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 0.55.sw,
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 40.sp),
                                    child: InkWell(
                                      onTap: () {
                                        launchUrlString("tel://$phoneNumber");
                                      },
                                      child: Text(
                                        textAlign: TextAlign.end,
                                        phoneNumber!.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                                fontSize: 40.sp,
                                                color: Colors.blue,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                                Icon(
                                  FontAwesomeIcons.phone,
                                  size: 40.sp,
                                  color: primaryColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 0.06.sh,
                          height: 0.06.sh,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.sp),
                              child: CachedAvatar(imageUrl: userImage!,)))
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints:
                      BoxConstraints(minHeight: 0.1.sh, maxHeight: 0.215.sh),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 35.sp),
                      child: Padding(
                        padding: EdgeInsets.all(10.0.sp),
                        child: ScrollConfiguration(
                          behavior: const ScrollBehavior(),
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.down,
                            color: primaryColor,
                            child: SingleChildScrollView(
                              child: Column(
                                  children: List.generate(
                                      orderNames!.length,
                                      (index) => Padding(
                                            padding: EdgeInsets.all(10.sp),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: primaryColor
                                                        .withOpacity(0.25),
                                                    spreadRadius: 1,
                                                    blurRadius: 1,
                                                    offset: const Offset(0,
                                                        2), // changes position of shadow
                                                  )
                                                ],
                                                borderRadius:
                                                    BorderRadius.circular(35.sp),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(35.sp),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    '${orderNames![index][1]}EGP',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium!
                                                        .copyWith(
                                                            color: primaryColor,
                                                            fontSize: 30.sp),
                                                  ),
                                                  Text(
                                                    orderNames![index][0],
                                                    textAlign: TextAlign.end,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .displayMedium
                                                        ?.copyWith(
                                                            fontSize: 30.sp,
                                                            color: primaryColor,
                                                            fontWeight:
                                                                FontWeight.w700),
                                                  ),
                                                  SizedBox(
                                                    width: 75.h,
                                                    height: 75.h,
                                                    child: CachedAvatar(imageUrl: imageUrls![index]),
                                                  ),
                                                  Icon(
                                                    FontAwesomeIcons.cutlery,
                                                    size: 40.sp,
                                                    color: primaryColor,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ))),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                note! == ''
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 25.sp, horizontal: 100.sp),
                        child: Text(
                          '$note',
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 35.sp,
                              color: primaryColor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.all(35.sp),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(15.0.sp),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0.sp),
                        child: MyElevatedButton(
                            enabled: true,
                            fontSize: 40.h,
                            width: double.infinity,

                            onPressed: () {},
                            text: 'تأكيد',
                            gradient: true,
                            color: Colors.transparent,
                            textColor: Colors.white),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0.sp),
                        child: MyElevatedButton(
                            enabled: true,
                            fontSize: 40.h,
                            width: double.infinity,
                            onPressed: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => MyAlertDialog(
                                  isFirstButtonRed: false,
                                  onFirstButtonPressed: () {},
                                  onSecondButtonPressed: () {},
                                  firstButton: 'رفض',
                                  secondButton: 'إلغاء',
                                  body: Container(),
                                  title:           'رفض الطلب؟',
                                  description:           'من فضلك وضّح للعميل ليه طلبه اترفض',
                                  textfield: true,
                                  controller: areYouSureController,)
                              ).then((val) {
                                areYouSureController.clear();
                              });

                            },
                            text: 'رفض',
                            gradient: false,
                            color: const Color(0xffFFCCCC),
                            textColor: Colors.red),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 0.04.sw,
                              child: Text(
                                dateTime!,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayMedium
                                    ?.copyWith(
                                        fontSize: 30.sp,
                                        color: smallFontColor.withOpacity(0.7),
                                        fontWeight: FontWeight.w400),
                              ),
                            ),
                            Text(
                              '05:00',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                      fontSize: 50.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w800),
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
      ),
    );
  }
}
