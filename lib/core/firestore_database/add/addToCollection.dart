

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';

Future<void> addDocumentToCollection(
{required CollectionReference doc, required Map<String, dynamic> data}
    ) async {
  try {
    await doc.add(data);
    saveMap();
    print('Document added successfully');
  }
  catch (e) {
    print('Error adding document: $e');
  }
}