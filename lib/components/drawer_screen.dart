import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/my_inkwell.dart';

import '../styles.dart';

class DrawerScreen extends StatefulWidget {
  DrawerScreen(
      {Key? key, required this.icon, required this.label, required this.onTap})
      : super(key: key);
  String label;
  IconData icon;
  var onTap;

  @override
  State<DrawerScreen> createState() =>
      _DrawerScreenState(icon: icon, label: label, onTap: onTap);
}

class _DrawerScreenState extends State<DrawerScreen> {
  var onTap;

  _DrawerScreenState(
      {required this.onTap, required this.label, required this.icon});

  String label;
  IconData icon;

  @override
  Widget build(BuildContext context) {
    var isWeb = MediaQuery.of(context).size.width >= 600; // Simple web check or use explicit param if preferred
    return Padding(
        padding: EdgeInsets.only(bottom: 0.0135.sh),
        child: MyInkWell(
          hoverColor: Colors.white.withOpacity(0.1), // Subtle white hover
          onTap: () {
            onTap();
          },
          radius: 0,
          child: SizedBox(
            height: 0.09.sh,
            width: double.infinity,
            // color: Colors.red,
            child: Padding(
              padding:
                  EdgeInsets.symmetric(vertical: 20.sp, horizontal: 0.05.sw),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded( 
                    child: Center(
                      child: FittedBox( 
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(
                                  // Increased sizes: 50.sp -> 60.sp (or fixed 20 for web)
                                  fontSize: isWeb ? 20 : 60.sp,
                                  color: Colors.white, // Changed to white
                                  fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.sp), // Gap
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Icon(
                      icon,
                      color: Colors.white, // Changed to white
                      // Increased size: 85.sp -> 95.sp (or fixed 30 for web)
                      size: isWeb ? 30 : 95.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
