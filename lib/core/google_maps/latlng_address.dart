

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';

Future<void> getAddressFromLatLng(lat, lng, address) async {
  await placemarkFromCoordinates(
      lat, lng)
      .then((List<Placemark> placemarks) {
    Placemark place = placemarks[0];
      address =
      '${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}';
  }).catchError((e) {
    debugPrint(e);
  });
}
