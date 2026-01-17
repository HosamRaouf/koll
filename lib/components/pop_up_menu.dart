import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyPopUpMenu extends StatefulWidget {
  const MyPopUpMenu({
    super.key,
    required this.options,
    required this.color,
    required this.iconColor,
  });

  final List<Map<String, dynamic>> options;
  final Color color;
  final Color iconColor;

  @override
  State<MyPopUpMenu> createState() => _MyPopUpMenuState();
}

class _MyPopUpMenuState extends State<MyPopUpMenu> {
  List<PopupMenuItem<String>> popUpMenuItems = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kIsWeb ? 48.h : 120.h,
      width: kIsWeb ? 48.h : 120.h,
      child: ClipOval(
        child: Material(
          color: widget.color,
          child: InkWell(
            splashColor: Colors.white,
            onTap: () {},
            child: PopupMenuButton<String>(
              iconSize: kIsWeb ? 28.sp : 72.sp,
              color: widget.color,
              iconColor: widget.iconColor,
              enableFeedback: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0.sp))),
              itemBuilder: (BuildContext context) {
                popUpMenuItems.clear();
                for (var element in widget.options) {
                  popUpMenuItems.add(
                    PopupMenuItem<String>(
                      padding: EdgeInsets.symmetric(vertical: 12.sp),
                      value: element['option'],
                      child: ListTile(
                        onTap: () {
                          Navigator.pop(context);
                          element['onPressed']();
                        },
                        leading: Padding(
                          padding: EdgeInsets.only(left: 24.sp),
                          child: Icon(
                            element['icon'],
                            color: element['textColor'],
                            size: 50.sp,
                          ),
                        ),
                        title: Padding(
                          padding: EdgeInsets.only(right: 24.sp),
                          child: Text(
                            element['option'],
                            textAlign: TextAlign.end,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium
                                ?.copyWith(
                                    color: element['textColor'],
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return popUpMenuItems;
              },
            ),
          ),
        ),
      ),
    );
  }
}
