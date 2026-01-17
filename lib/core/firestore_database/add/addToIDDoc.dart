

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';


Future<String> addToIdDoc(String id, {required CollectionReference doc, required Map<String, dynamic> data, required String collectionPath}) async {
  String docId = '';
  var document = doc.where('id', isEqualTo: id);

   await document.get().then((value) {
     for (var element in value.docs) {
       docId = element.id;
     }
   }).then((value) async {
     await doc.doc(docId).collection(collectionPath).add(data);
   }).then((value) {
     saveMap();
   });
  return docId;
}