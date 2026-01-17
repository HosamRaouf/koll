



import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles.dart';

class MyExpansionPanelList extends StatefulWidget {
  MyExpansionPanelList({super.key, required this.body, required this.title, required this.isExpanded});

  bool isExpanded;
  String title;
  Widget body;

  @override
  State<MyExpansionPanelList> createState() => _MyExpansionPanelListState();
}

class _MyExpansionPanelListState extends State<MyExpansionPanelList> {
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expandedHeaderPadding:
      const EdgeInsets.all(0),
      dividerColor: smallFontColor,
      animationDuration:
      const Duration(milliseconds: 500),
      expansionCallback:
          (int index, bool expanded) {
        setState(() {
          widget.isExpanded = !widget.isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          headerBuilder:
              (context, bool isExpanded) {
            return Row(
              mainAxisAlignment:
              MainAxisAlignment.end,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context)
                      .textTheme
                      .displayLarge!
                      .copyWith(
                      color: primaryColor,
                      fontSize: 40.sp),
                ),
              ],
            );
          },
          canTapOnHeader: true,
          backgroundColor: backGroundColor,
          body: widget.body,
          isExpanded: widget.isExpanded,
        ),
      ],
    );
  }
}
