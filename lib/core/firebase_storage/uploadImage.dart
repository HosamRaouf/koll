import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:kol/components/progress_bar.dart';

import '../../routes/app_routes.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImage(
  File imageFile,
  String imageName, {
  required Function(String) onUploaded,
  required BuildContext context,
}) async {
  String downloadUrl = '';
  Reference snapshot = storage.ref().child('images/$imageName');

  await snapshot.getDownloadURL().then((value) {
    print(value.isNotEmpty);
    onUploaded(value);
    print('downloadUrl: $value');
  }).onError((error, stackTrace) {
    UploadTask task = snapshot.putFile(imageFile);
    try {
      showDialog(
          context: NamedNavigatorImpl.navigatorState.currentContext!,
          barrierDismissible: false,
          builder: (context) => ProgressBar(
                task: task,
                onUploaded: (url) => onUploaded(url),
              ));
    } catch (e) {
      print('e $e');
    }
  });

  return '';
}
