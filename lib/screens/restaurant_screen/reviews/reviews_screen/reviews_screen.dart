import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:kol/screens/restaurant_screen/reviews/reviews_screen/review_widget.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/models/rating_models/restaurant_rate_model.dart';
import '../../../../map.dart';
import '../../../../styles.dart';
import 'header.dart';

ItemScrollController reviewsScrollController = ItemScrollController();

double currentRate = 0;

class ReviewsScreen extends StatelessWidget {
  ReviewsScreen({
    super.key,
    required this.index,
  });

  int index;

  @override
  Widget build(BuildContext context) {
    late AnimationController animationController;
    reviews.sort((a, b) => myDateTimeFormat
        .parse(b.time)
        .compareTo(myDateTimeFormat.parse(a.time)));
    return Scaffold(
      backgroundColor: backGroundColor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: Container(
            color: backGroundColor,
            child: Column(
              children: [
                const ReviewsHeader(),
                Expanded(
                  child: Container(
                          color: warmColor,
                          child: ScrollablePositionedList.builder(
                            itemScrollController: reviewsScrollController,
                            itemBuilder: (context, index) {
                              RestaurantRate rate = reviews[index];
                              return ReviewWidget(
                                rate: rate,
                                reportable: true,
                              );
                            },
                            itemCount: reviews.length,
                          ))
                      .animate(
                        onInit: (controller) {
                          animationController = controller;
                        },
                        onComplete: (controller) {
                          animationController = controller;
                        },
                      )
                      .slide(
                          begin: const Offset(0, 1),
                          end: const Offset(0, 0),
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.fastEaseInToSlowEaseOut)
                      .fade(
                          duration: const Duration(milliseconds: 2000),
                          curve: Curves.fastEaseInToSlowEaseOut),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
