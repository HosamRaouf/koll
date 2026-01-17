import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import '../../../core/models/rating_models/order_rate_model.dart';
import '../../../styles.dart';

class Rate extends StatelessWidget {
  OrderRateModel rate;
  Rate({super.key, required this.rate});

  @override
  Widget build(BuildContext context) {
    return               Padding(
      padding: EdgeInsets.all(24.sp),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: cardDecoration.copyWith(gradient: myGradient),
          child: Padding(
            padding: EdgeInsets.all(24.sp),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(rate.rate, (index) => const Icon(Iconsax.star1,color: Colors.orange,)),
                  ),
                ),
                Text(rate.feedback, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 36.sp, color: Colors.white),),
                Text(rate.time, style: Theme.of(context).textTheme.displayMedium!.copyWith(fontSize: 28.sp, color: smallFontColor),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
