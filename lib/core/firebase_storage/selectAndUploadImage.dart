import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kol/core/firebase_storage/uploadImage.dart';

import '../../routes/app_routes.dart';

Future<void> selectAndUploadImage(BuildContext context,
    {required Function(String) onUploaded}) async {
  try {
    var pickedfile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedfile != null) {
      uploadImage(File(pickedfile.path), pickedfile.name, onUploaded: (url) {
        onUploaded(url);
      }, context: NamedNavigatorImpl.navigatorState.currentContext!);
    } else {
      print("No image is selected.");
    }
  } catch (e) {
    print("error while picking file. $e");
  }
}
