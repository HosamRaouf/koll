import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:kol/core/firebase_messaging/getToken.dart';
import 'package:kol/core/firestore_database/getDocId.dart';
import 'package:kol/core/models/restaurant_model.dart';
import 'package:kol/core/models/voucher_model.dart';
import 'package:kol/core/shared_preferences/getPreference.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';

import '../../../map.dart';
import '../../../screens/restaurant_screen/pop_menu/color_picker/methods.dart';
import '../../../screens/users_screen/users_screen.dart';
import '../../../styles.dart';
import '../../models/rating_models/restaurant_rate_model.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

List<VoucherModel> mainVouchers = [];

assignColors(String colorHex) {
  Color color = Color(int.parse(colorHex, radix: 16));
  primaryColor = color;
  accentColor = lighten(color);
  backGroundColor = brighten(color, 0.95);
  warmColor = brighten(color, 0.87);
  myGradient = LinearGradient(colors: [primaryColor, accentColor]);
  cardDecoration = cardDecoration.copyWith(
    color: backGroundColor,
    boxShadow: [
      BoxShadow(
        color: primaryColor.withOpacity(0.02),
        spreadRadius: 0,
        blurRadius: 2,
        offset: const Offset(0, 2),
      ),
      BoxShadow(
        color: accentColor.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 2),
      ),
    ],
  );
}

Future<void> fetchAllData() async {
  String? email;
  await getPreference(key: 'email').then((value) {
    email = value;
  });
  try {
    QuerySnapshot querySnapshot =
        await restaurants.where('email', isEqualTo: email).get();
    print(
        "================================================ 📡📡📡 Fetching General Data 📡📡📡 ==========================================");
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      if (document['email'] == email) {
        restaurant = document.data() as Map<String, dynamic>;
        restaurantData = RestaurantModel.fromJson(restaurant);
        await assignValues();
        assignColors(restaurant['color']);
        saveMap();
        print(
            "================================================ ✅📡📡📡✅ General Data Fetched ✅📡📡📡✅ ==========================================");
      }
    }
  } on FirebaseException catch (e) {
    print(
        "================================================ ❌📡📡📡❌ Error Fetching General Data ❌📡📡📡❌ ==========================================");
    print('Error fetching data: ${e.message}');
  }
}

getCollectionValue(
    {required String id,
    required String collectionName,
    required Function(Map<String, dynamic>) onGet}) async {
  print(
      "================================================ 🛰️ Fetching $collectionName 🛰️ ==========================================");
  try {
    await restaurants
        .doc(id)
        .collection(collectionName)
        .get()
        .then((value) async {
      for (QueryDocumentSnapshot document in value.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (data['firestoreId'] == "") {
          await restaurantDocument
              .collection(collectionName)
              .doc(document.id)
              .update({'firestoreId': document.id});
        }
        onGet(data);
      }
    });
    print(
        "================================================ ✅ $collectionName fetched ✅ ==========================================");
  } catch (e) {
    print(
        "================================================ ❌ Error fetching $collectionName ❌ ==========================================");
    print(e);
  }
}

assignValues() async {
  await getToken().then((value) async {
    List tokens = [];
    for (var element in restaurantData.tokens) {
      tokens.add(element);
    }
    if (!restaurantData.tokens.contains(value)) {
      tokens.clear();
      tokens.add(value);
      print(
          "================================================ 🔐🛰️ Adding token 🛰️🔐 ==========================================");
      try {
        await restaurantDocument.update({"tokens": tokens});
        print(
            "================================================ 🔐✅ Token added ✅🔐 ==========================================");
      } catch (E) {
        print(
            "================================================ 🔐❌ Error adding token ❌🔐 ==========================================");
      }
    } else {
      print(
          "================================================ 🔐😉 Token Exists 😉🔐 ==========================================");
    }
  });

  for (var order in restaurantData.finishedOrders) {
    if (!restaurantData.finishedOrders
        .any((element) => element.id == order.id)) {
      if (!restaurantData.bannedUsers.contains(order.userId)) {
        restaurantData.finishedOrders.add(order);
      }
    }
  }

  for (var driver in restaurantData.drivers) {
    for (var order in restaurantData.finishedOrders) {
      if (driver.firestoreId == order.driverId) {
        driver.orders.add(order);
      }
    }
  }

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: 'menu',
      onGet: (data) async {
        List<Map<String, dynamic>> items = [];
        if (data['firestoreId'] != "") {
          await restaurantDocument
              .collection('menu')
              .doc(data['firestoreId'])
              .collection('items')
              .get()
              .then((value) {
            for (var element in value.docs) {
              items.add(element.data());
            }
          }).catchError((e) async {
            print('e.code: $e');
            await fetchAllData();
          });
          data['items'] = items;
          restaurant['menu'].add(data);
        } else {
          await getDocId(
                  docWhere: restaurantDocument
                      .collection('menu')
                      .where('id', isEqualTo: data['id']))
              .then((value) async {
            await restaurantDocument
                .collection('menu')
                .doc(value)
                .update({'firestoreId': value}).then((value) async {
              await restaurantDocument
                  .collection('menu')
                  .doc(data['firestoreId'])
                  .collection('items')
                  .get()
                  .then((value) {
                for (var element in value.docs) {
                  items.add(element.data());
                }
              }).catchError((e) async {
                print('e.code: $e');
                await fetchAllData();
              });
              data['items'] = items;
              restaurant['menu'].add(data);
            });
          });
        }
      });

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: 'drivers',
      onGet: (data) {
        restaurant['drivers'].add(data);
      });

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: 'offers',
      onGet: (data) {
        restaurant['offers'].add(data);
      });

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: 'vouchers',
      onGet: (data) {
        restaurant['vouchers'].add(data);
      });

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: 'ratings',
      onGet: (data) {
        restaurant['rates'].add(data);
      });

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: 'finishedOrders',
      onGet: (data) {
        restaurant['finishedOrders'].add(data);
      });

  await getCollectionValue(
      id: restaurant['id'],
      collectionName: "reviews",
      onGet: (data) {
        reviews.add(RestaurantRate.fromJson(data));
        restaurantData.rates.add(RestaurantRate.fromJson(data));
      });

  kIsWeb ? null : await fetchUsers();

  await FirebaseFirestore.instance.collection("vouchers").get().then((value) {
    if (value.docs.isNotEmpty) {
      for (var element in value.docs) {
        mainVouchers.add(VoucherModel.fromJson(element.data()));
      }
    }
  });

  restaurant['waitingOrders'] = [];
  restaurantData = RestaurantModel.fromJson(restaurant);
}
