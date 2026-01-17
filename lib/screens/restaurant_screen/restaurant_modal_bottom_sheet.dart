import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import '../../components/myElevatedButton.dart';
import '../../components/myTextField.dart';
import '../../components/my_scroll_configurations.dart';
import '../../styles.dart';
import 'categories_image_slider.dart';

class RestaurantModalBottomSheet extends StatefulWidget {
  RestaurantModalBottomSheet(
      {super.key, required this.onAdd, required this.edit, required this.map});

  static int index = 1;
  static TextEditingController controller1 = TextEditingController();
  static String type = 'food';
  Function() onAdd;
  bool edit;
  CategoryModel map;

  @override
  State<RestaurantModalBottomSheet> createState() =>
      _RestaurantModalBottomSheetState();
}

class _RestaurantModalBottomSheetState
    extends State<RestaurantModalBottomSheet> {

  String type = 'food';
  String image = 'assets/images/food/1.png';
  String error = '';

  @override
  void initState() {
    widget.map.toJson().isNotEmpty
        ? {
            RestaurantModalBottomSheet.controller1.text = widget.map.name,
            RestaurantModalBottomSheet.type = widget.map.type,

            print(widget.map.image),
          }
        : RestaurantModalBottomSheet.controller1.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: EdgeInsets.all(48.sp),
        child: MyScrollConfigurations(
          horizontal: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.edit ? 'تعديل' : 'نوع جديد',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 64.sp),
                ),
                CategoriesImageSlider(
                  isEdit: widget.edit,
                    map: widget.edit
                        ? widget.map
                        : CategoryModel(
                            id: "",
                            firestoreId: "",
                        time: DateTime.now().toString(),
                        name: "",
                            image: 'assets/images/food/1.png',
                            type: 'food',
                            items: [])),
                MyTextField(
                    error: error,
                    descriptionTextField: false,
                    title: "إسم الصنف",
                    maxLength: 25,
                    isValidatable: true,
                    controller: RestaurantModalBottomSheet.controller1,
                    type: 'normal',
                    hintText: 'مثال: مارجريتا',
                    isExpanding: false),
                SizedBox(
                  height: 36.sp,
                ),
                MyElevatedButton(
                  fontSize: 40.h,
                  onPressed: ()  {
                    RestaurantModalBottomSheet.controller1.text.isEmpty?
                    setState(() {
                      error = 'من فضلك أدخل إسم الصنف';
                    }) :
                     widget.onAdd();
                  },
                  text: widget.edit ? 'تعديل' : 'إضافة',
                  width: double.infinity,
                  enabled: true,
                  color: Colors.transparent,
                  textColor: Colors.white,
                  gradient: true,
                ),
                SizedBox(
                  height: 40.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
