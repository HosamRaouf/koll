import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../components/myElevatedButton.dart';
import '../../styles.dart';

class OnTheWayOrder extends StatefulWidget {
  String? adress;
  int? phoneNumber;
  List<List<String>>? orderNames;
  List<String>? imageUrls;
  String? note;
  String? dateTime;
  String? cost;
  String? userName;
  String? userImage;

  OnTheWayOrder(
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
  State<OnTheWayOrder> createState() => _OnTheWayOrderState();
}

class _OnTheWayOrderState extends State<OnTheWayOrder> {



  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(100.sp),
      elevation: 25.sp,
      shadowColor: primaryColor,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(40.r)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20.sp, left: 20.sp, right: 20.sp),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.dateTime!,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 25.sp,
                        color: smallFontColor.withOpacity(0.7),
                        fontWeight: FontWeight.w400),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                            height: 0.08.sw,
                            child: Text(
                              widget.userName!,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              textAlign: TextAlign.end,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                  fontSize: 40.sp,
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600),
                            ),
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
                              borderRadius: BorderRadius.circular(100.sp),
                              child: CachedAvatar(imageUrl: widget.userImage!)))
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.sp),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 35.sp),
                        child: SizedBox(
                          width: 0.77.sw,
                          child: Text(
                            widget.adress!,
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                fontSize: 30.sp,
                                color: primaryColor,
                                fontWeight:
                                FontWeight.w600),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 15.sp),
                        child: Icon(
                          FontAwesomeIcons.locationDot,
                          size: 45.sp,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 40.sp),
                        child: InkWell(
                          onTap: () {
                            launchUrlString("tel://${widget.phoneNumber}");
                          },
                          child: Text(
                            textAlign: TextAlign.end,
                            widget.phoneNumber!.toString(),
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
                      Icon(
                        FontAwesomeIcons.phone,
                        size: 40.sp,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  Column(
                      children: List.generate(
                          widget.orderNames!.length,
                              (index) => Padding(
                            padding: EdgeInsets.only(bottom: 10.sp),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Center(
                                    child: Text(
                                      '${widget.orderNames![index][1]}EGP',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium!
                                          .copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: primaryColor,
                                          fontSize: 30.sp),
                                    )),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                      EdgeInsets.only(right: 40.sp),
                                      child: Text(
                                        widget.orderNames![index][0],
                                        textAlign: TextAlign.end,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                            fontSize: 30.sp,
                                            color: primaryColor,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                    ),
                                    Icon(
                                      FontAwesomeIcons.cutlery,
                                      size: 40.sp,
                                      color: primaryColor,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )))
                ],
              ),
            ),
            widget.note! == ''
                ? Container()
                : Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.sp),
              child: Text(
                ' ملحوظة: ${widget.note}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 35.sp,
                    color: primaryColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50.sp, vertical: 15.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      '${widget.cost!}EGP',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 40.sp,
                          color: primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    'الإجمالي',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 40.sp,
                        color: primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
Padding(
  padding: EdgeInsets.symmetric(vertical: 20.sp, horizontal: 35.sp),
  child:   Container(
    decoration: BoxDecoration(
    color: primaryColor.withOpacity(0.2),

    borderRadius: BorderRadius.circular(20.sp)
),
    width: double.infinity,

    height: 140.h,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.sp),
          child: SizedBox(
              width: 100.sp,
              height: 100.sp,
              child: Image.asset('assets/images/user.png')),
        ),
        Padding(
          padding: EdgeInsets.only(left: 15.sp),
          child: SizedBox(
            width: 560.w,
            child: Text('Mohammed abo abdo el7ashoom',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 45.sp, color:primaryColor, fontWeight: FontWeight.w600, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp),
          child: Row(
            children: [
              SizedBox(
                  width: 100.sp,
                  height: 100.sp,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.phone, size: 60.sp, color: primaryColor,), splashRadius: 70.sp,)),
              SizedBox(width: 20.sp,),
              SizedBox(
                  width: 100.sp,
                  height: 100.sp,
                  child: IconButton(onPressed: () {}, icon: Icon(Icons.info, size: 60.sp, color: primaryColor,), splashRadius: 70.sp,)),
            ],
          ),
        )

      ],
    ),


  ),
),
            Padding(
              padding: EdgeInsets.only(bottom: 40.sp, left: 35.sp, right: 35.sp),
              child: MyElevatedButton(
                  fontSize: 40.h,                  width: double.infinity,
                  enabled: true,
                  onPressed: () {
                  },
                  text: 'تم',
                  gradient: true,
                  color: Colors.transparent,
                  textColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
