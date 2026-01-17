import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/my_inkwell.dart';

import '../../../../core/models/menu_models/item_model.dart';
import '../../../../styles.dart';

class ChooseSize extends StatefulWidget {
  bool checkBox;
  SizeModel size;
  Function(SizeModel) onChanged;

  ChooseSize(
      {super.key,
      required this.checkBox,
      required this.size,
      required this.onChanged});

  @override
  State<ChooseSize> createState() => _ChooseSizeState();
}

class _ChooseSizeState extends State<ChooseSize> {
  Color color = primaryColor;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 450),
      decoration: cardDecoration.copyWith(color: color, gradient: widget.checkBox == true
          ? myGradient
          : const LinearGradient(colors: [Colors.white, Colors.white])),
      width: double.infinity,
      child: MyInkWell(
        onTap: () {
          setState(() {
            widget.onChanged(widget.size);
            color = widget.checkBox == true ? Colors.white : primaryColor;
          });
        },
        radius: 32.r,
        child: Padding(
          padding: EdgeInsets.all(24.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.size.price.toStringAsFixed(2)}EGP',
                style: Theme.of(context)
                    .textTheme
                    .displayLarge!
                    .copyWith(color: widget.checkBox == true ? Colors.white : primaryColor, fontSize: 40.sp, fontWeight: FontWeight.w600),
              ),
              Text(
                widget.size.name.toString(),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: smallFontColor, fontSize: 32.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
