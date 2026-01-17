
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kol/map.dart';


Future<void> fetchSpecificData(BuildContext context, {required String field, required var data}) async {
  // showDialog(context: context, builder: (context)=> const Loading());
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('restaurants');
    DocumentReference userDocument = users.doc(restaurantData.id);
    DocumentSnapshot snapshot = await userDocument.get();

    Map<String, dynamic> map = snapshot.data() as Map<String, dynamic>;
    data = map[field];

    print('Data: $data');
    return(data);
  }

  on FirebaseException catch (e) {
    print('Error getting document: ${e.code}');
    return;
  }
}