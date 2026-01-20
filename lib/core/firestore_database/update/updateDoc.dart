import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/map.dart';
import '../fetch/fetchAll.dart';

updateDoc(BuildContext context,
    {required Query<Map<String, dynamic>> doc,
    required Map<String, dynamic> data,
    required Function() onComplete,
    required var model}) async {
  late DocumentReference post;

  if (model.firestoreId == "") {
    await doc.get().then((snapshot) async {
      post = snapshot.docs[0].reference;
      model.firestoreId = post.id;
      var batch = firestore.batch();
      batch.update(post, data);
      batch.commit().then((value) async {
        await restaurantDocument
            .collection('menu')
            .doc(model.firestoreId)
            .update({'firestoreId': model.firestoreId}).then((value) {
          saveMap();
          onComplete();
        });
      });
    });
  } else {
    await restaurantDocument
        .collection('menu')
        .doc(model.firestoreId)
        .update(data);
    onComplete();
  }
}
