import 'package:image_picker/image_picker.dart';

void selectImage({required Function(XFile) onSelected}) async {
  try {
    var pickedfile = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (pickedfile != null) {
    } else {
      print("No image is selected.");
    }
  } catch (e) {
    print("error while picking file. $e");
  }
}
