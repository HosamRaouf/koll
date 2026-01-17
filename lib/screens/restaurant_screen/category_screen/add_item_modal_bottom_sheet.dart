import 'package:arabic_font/arabic_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/map.dart';

import '../../../../components/myElevatedButton.dart';
import '../../../../components/myTextField.dart';
import '../../../../components/my_scroll_configurations.dart';
import '../../../../styles.dart';
import '../../../components/loading.dart';
import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/menu_models/item_model.dart';
import 'category_screen.dart';

class AddItem extends StatefulWidget {
  String categoryName;
  Function() onAdd;

  AddItem({super.key, required this.categoryName, required this.onAdd});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController size = TextEditingController();
  TextEditingController price = TextEditingController();
  List<SizeModel> sizes = [];
  List<Widget> sizeWidgets = [];
  bool isSizesEmpty = false;
  List<ItemModel> items = [];
  String image = '';

  String priceError = '';
  String sizeError = '';
  late CategoryModel category;

  @override
  void initState() {
    category = restaurantData.menu[restaurantData.menu
        .indexWhere((element) => element.name == widget.categoryName)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Padding(
        padding: EdgeInsets.all(48.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'صنف جديد',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 72.sp),
                ),
                SizedBox(
                  height: 24.sp,
                ),
                MyTextField(
                    error: "",
                    descriptionTextField: false,
                    title: "الإسم",
                    maxLength: 25,
                    isValidatable: true,
                    controller: name,
                    type: 'normal',
                    hintText: 'مثال: مارجريتا',
                    isExpanding: false),
                SizedBox(
                  height: 24.sp,
                ),
                MyTextField(
                    error: "",
                    descriptionTextField: false,
                    title: "الوصف",
                    maxLength: 100,
                    isValidatable: false,
                    controller: description,
                    type: 'normal',
                    hintText:
                        'مثال: العجينة الطازجة مع الخضراوات والجبن اللذيذ',
                    isExpanding: true),
                SizedBox(
                  height: 48.sp,
                ),
                Container(
                  decoration: cardDecoration.copyWith(
                      borderRadius: BorderRadius.circular(52.r)),
                  child: Padding(
                    padding: EdgeInsets.all(36.0.sp),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'أضف سعر',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 52.sp, color: primaryColor),
                        ),
                        SizedBox(
                          height: 36.sp,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MyTextField(
                                error: sizeError,
                                descriptionTextField: false,
                                title: "الحجم",
                                maxLength: 10,
                                isValidatable: false,
                                controller: size,
                                type: 'normal',
                                hintText: 'Small',
                                isExpanding: false),
                            SizedBox(
                              height: 36.sp,
                            ),
                            MyTextField(
                                error: priceError,
                                descriptionTextField: false,
                                title: "السعر",
                                maxLength: 4,
                                isValidatable: false,
                                controller: price,
                                type: 'number',
                                hintText: 'e.g: 100EGP',
                                isExpanding: false),
                            SizedBox(
                              height: 36.sp,
                            ),
                            Container(
                              width: double.infinity,
                              height: 100.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.r),
                                  gradient: myGradient),
                              child: Material(
                                color: Colors.transparent,
                                child: MyInkWell(
                                  radius: 24.r,
                                  onTap: () {
                                    int index = 0;
                                    setState(() {
                                      size.text.isNotEmpty &&
                                              price.text.isNotEmpty
                                          ? {
                                              isSizesEmpty = false,
                                              sizeWidgets.add(Padding(
                                                padding: EdgeInsets.only(
                                                    left: 24.sp),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20.r),
                                                      gradient: LinearGradient(
                                                          colors: [
                                                            primaryColor,
                                                            accentColor
                                                          ],
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter)),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 42.sp),
                                                        child: Text(
                                                          '${size.text} - ${price.text}EGP',
                                                          textDirection:
                                                              TextDirection.rtl,
                                                          style: ArabicTextStyle(
                                                              arabicFont:
                                                                  ArabicFont
                                                                      .cairo,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 36.h),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.all(
                                                            12.0.sp),
                                                        child: ClipOval(
                                                          child: Material(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.3),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                setState(() {
                                                                  sizeWidgets.length ==
                                                                          1
                                                                      ? sizeWidgets
                                                                          .clear()
                                                                      : sizeWidgets
                                                                          .remove(
                                                                              sizeWidgets[index]);
                                                                });
                                                              },
                                                              icon: Icon(
                                                                  Iconsax.trash,
                                                                  color: Colors
                                                                      .red,
                                                                  size: 48.h),
                                                              splashColor:
                                                                  backGroundColor
                                                                      .withOpacity(
                                                                          0.5),
                                                              splashRadius:
                                                                  48.h,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )),
                                              sizes.add(SizeModel(
                                                  id: uuid.v1(),
                                                  name: size.text,
                                                  price: double.parse(
                                                      price.text))),
                                              FocusScope.of(context).unfocus()
                                            }
                                          : {
                                              setState(() {
                                                size.text.isEmpty
                                                    ? sizeError =
                                                        'من فضلك أدخل حجم الصنف'
                                                    : sizeError = '';
                                                price.text.isEmpty
                                                    ? priceError =
                                                        'من فضلك أدخل سعر الصنف'
                                                    : priceError = '';
                                                isSizesEmpty = true;
                                              })
                                            };
                                      size.clear();
                                      price.clear();
                                      index++;
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(12.0.sp),
                                    child: Icon(
                                      Iconsax.add,
                                      size: 65.h,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 24.sp,
                ),
                MyScrollConfigurations(
                  horizontal: false,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: sizeWidgets),
                  ),
                ),
                SizedBox(
                  height: 24.sp,
                ),
                isSizesEmpty == true
                    ? Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.sp),
                          child: Text(
                            'من فضلك أضف الحجم',
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .displayMedium!
                                .copyWith(fontSize: 36.sp, color: Colors.red),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            MyElevatedButton(
              fontSize: 40.h,
              onPressed: () async {
                String id = uuid.v1();
                ItemModel theItem = ItemModel(
                    id: id,
                    firestoreId: id,
                    time: DateTime.now().toString(),
                    name: name.text,
                    image: image,
                    description: description.text,
                    ordered: 0,
                    images: [],
                    prices: sizes);
                sizeWidgets.isEmpty
                    ? {isSizesEmpty = true, print(isSizesEmpty)}
                    : {
                        name.text.isEmpty
                            ? print(sizeWidgets)
                            : {
                                await restaurantDocument
                                    .collection("menu")
                                    .doc(category.firestoreId)
                                    .collection("items")
                                    .doc(id)
                                    .set(theItem.toJson()),
                                showDialog(
                                    context: context,
                                    builder: (context) => const Loading()),
                                CategoryScreen.items.add(theItem),
                                restaurant['menu'][restaurant['menu']
                                        .indexWhere((map) =>
                                            map['id'] == category.id)]['items']
                                    .add(theItem.toJson()),
                                saveMap(),
                                widget.onAdd(),
                                Navigator.of(context).pop(),
                                Navigator.pop(context),
                                showSnackBar(
                                  context: context,
                                  message: 'تم إضافة ${name.text} بنجاح',
                                ),
                              }
                      };
              },
              text: 'إضافة',
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
    );
  }
}
