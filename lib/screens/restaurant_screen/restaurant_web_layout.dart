import 'package:flutter/cupertino.dart';
import 'package:kol/core/models/restaurant_model.dart';
import 'package:kol/screens/restaurant_screen/restaurant_header.dart';

class RestaurantWebLayout extends StatelessWidget {
  RestaurantModel restaurant;
  RestaurantWebLayout({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        RestaurantHeader(
          opened: true,
          isWeb: true,
          restaurant: restaurant,
        )
      ],
    ));
  }
}
