


import 'package:cloud_firestore/cloud_firestore.dart';

import '../../shared_preferences/saveMap.dart';

Future<void> updateDocUsingID (String id, String id2, {required CollectionReference doc, required Map<String, dynamic> data, required String collectionPath}) async  {
  String docId = '';
  String docId2 = '';
  var document = doc.where('id', isEqualTo: id);

  await document.get().then((value) {
    for (var element in value.docs) {
      print(element.id);
      docId = element.id;
    }
  }).then((value) async {
    var finalDoc = doc.doc(docId).collection(collectionPath).where('id', isEqualTo: id2);
    finalDoc.get().then((value) {
      for (var element in value.docs) {
        print(element.id);
        docId2 = element.id;
      }
    }).then((value)async  {
      await doc.doc(docId).collection(collectionPath).doc(docId2).update(data);
    }).then((value) {
      saveMap();
    });
  });
}