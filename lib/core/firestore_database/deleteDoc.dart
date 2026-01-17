

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';

import 'fetch/fetchAll.dart';

deleteDoc(BuildContext context, {required Query<Map<String, dynamic>> doc, required Function() onComplete}) async {

  late DocumentReference post;

 await doc.get().then((snapshot) {
    post = snapshot.docs[0].reference;
  });

  var batch = firestore.batch();
  batch.delete(post);
  batch.commit().then((value) {
    saveMap();
    onComplete();
  });
}