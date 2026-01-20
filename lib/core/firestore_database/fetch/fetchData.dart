

import 'package:flutter/cupertino.dart';
import 'package:kol/map.dart';
import 'fetchSpecificData.dart';

fetchSomeData(BuildContext context) {
  fetchSpecificData(context, field: 'name', data: restaurant['name']);
}