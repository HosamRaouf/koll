
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kol/styles.dart';
import 'package:share_plus/share_plus.dart';

class OrderDropDownMenu extends StatelessWidget {

  OrderDropDownMenu({Key? key, this.userName, this.adress, this.phoneNumber, this.cost, this.orderNames}) : super(key: key);

  String? adress;
  String? phoneNumber;
  List<List<String>>? orderNames;
  String? note;
  String? dateTime;
  String? cost;
  String? userName;

  @override
  Widget build(BuildContext context) {
    return       PopupMenuButton<String>(
      iconSize: 65.sp,
      enableFeedback: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0.sp))
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'option1',
          child: ListTile(
            onTap: () {
      String orders = '';
      for (var element in orderNames!) {
        orders =
        '$orders\n🍽 : ${element[0]} - 💲 : ${element[1]}EGP';
      }
      Navigator.pop(context);
      Clipboard.setData(ClipboardData(
          text:
          '👤 : ${userName!} \n🚩 : ${adress!} \n📞 : ${phoneNumber!} \n📋الطلبات $orders \nNote : ${note!=null? note! : ''}\n💰 : ${cost!}EGP'))
          .then(
            (value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
              behavior:
              SnackBarBehavior.floating,
              content: Text(
                'تم نسخ معلومات الطلب بنجاح',
                textAlign: TextAlign.end,
                style: Theme.of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                    color: Colors.white,
                    fontSize: 40.sp),
              )));
            });},
            leading: Icon(FontAwesomeIcons.copy, color: primaryColor, size: 50.sp,),
            title: Text('نسخ',
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: primaryColor, fontSize: 40.sp, fontWeight: FontWeight.w500),),
          ),),
        PopupMenuItem<String>(
          value: 'option2',
          child: ListTile(
            onTap: () {
              String orders = '';
              for (var element in orderNames!) {
                orders =
                '$orders\n🍽 : ${element[0]} - 💲 : ${element[1]}EGP';
              }
              Share.share(
                  subject: 'بيانات الطلب',
                  '👤 : ${userName!} \n🚩 : ${adress!} \n📞 : ${phoneNumber!.toString()} \n📋الطلبات $orders \nNote : ${note!=null? note! : ''}  \n💰 : ${cost!}EGP');
            },
            leading: Icon(FontAwesomeIcons.share, color: primaryColor, size: 50.sp,),
            title: Text('مشاركة',
              textAlign: TextAlign.end,

              style: Theme.of(context).textTheme.displayMedium?.copyWith(color: primaryColor, fontSize: 40.sp, fontWeight: FontWeight.w500),),
          ),)
      ],
    )
    ;
  }
}
