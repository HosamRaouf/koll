import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';

import '../../../components/loading.dart';
import '../../../components/myElevatedButton.dart';
import '../../../components/myTextField.dart';
import '../../../components/my_scroll_configurations.dart';
import '../../../components/show_snack_bar.dart';
import '../../../core/firestore_database/getDocId.dart';
import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../map.dart';
import '../../../styles.dart';
import 'category_screen.dart';

class EditSize extends StatefulWidget {
  TextEditingController size;
  TextEditingController price;
  SizeModel element;
  Function(bool) rebuildWidgets;
  bool edit;
  CategoryModel category;

  EditSize({super.key,
    required this.price,
    required this.size,
    required this.element,
    required this.rebuildWidgets,
    required this.edit,
    required this.category});

  @override
  State<EditSize> createState() => _EditSizeState();
}

class _EditSizeState extends State<EditSize> {
  Future<void> getFirestoreId() async {
    if (widget.category.firestoreId == "" ||
        CategoryScreen.item.firestoreId == "") {
      print(widget.category.id);
      await getDocId(
          docWhere: restaurantDocument
              .collection('menu')
              .where('id', isEqualTo: widget.category.id))
          .then((value) async {
        await restaurantDocument
            .collection('menu')
            .doc(widget.category.firestoreId)
            .update({"firestoreId": widget.category.firestoreId});
        widget.category.firestoreId = value;
        saveMap();
        print('sssssss ${widget.category.firestoreId}');
      }).then((value) async {
        await getDocId(
            docWhere: restaurantDocument
                .collection('menu')
                .doc(widget.category.firestoreId)
                .collection('items')
                .where('id', isEqualTo: CategoryScreen.item.id))
            .then((value) async {
          CategoryScreen.item.firestoreId = value;
          await restaurantDocument
              .collection('menu')
              .doc(widget.category.firestoreId)
              .collection('items')
              .doc(CategoryScreen.item.firestoreId)
              .update({"firestoreId": CategoryScreen.item.firestoreId});
          print('fffffffffffff ${widget.category.firestoreId}');
        });
      });
    } else {
      print(
          'firestore ID already exist - category: ${widget.category
              .firestoreId}');
      print(
          'firestore ID already exist - item: ${CategoryScreen.item
              .firestoreId}');
    }
  }

  String sizeError = '';
  String priceError = '';

  @override
  Widget build(BuildContext context) {

    List menu = restaurant['menu'];
    int categoryIndex = menu.indexWhere((element) => element['id'] == widget.category.id);
    Map<String, dynamic> category = menu[categoryIndex];

    List items = category['items'];
    int itemIndex = items.indexWhere((item) => item['id'] == CategoryScreen.thisItem.id);
    Map<String, dynamic> item = items[itemIndex];

    return Padding(
      padding: EdgeInsets.all(48.sp),
      child: MyScrollConfigurations(
        horizontal: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.edit ? 'تعديل السعر' : 'إضافة سعر',
                style: Theme
                    .of(context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 64.sp),
              ),
              SizedBox(
                height: 24.sp,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: MyTextField(
                        descriptionTextField: false,
                        error: sizeError,
                        title: "الحجم",
                        maxLength: 10,
                        isValidatable: true,
                        controller: widget.size,
                        type: 'normal',
                        hintText: 'e.g: Small',
                        isExpanding: false),
                  ),
                  SizedBox(
                    child: MyTextField(
                        descriptionTextField: false,
                        error: priceError,
                        title: "السعر",
                        maxLength: 4,
                        isValidatable: true,
                        controller: widget.price,
                        type: 'number',
                        hintText: 'e.g: 100EGP',
                        isExpanding: false),
                  ),
                ],
              ),
              SizedBox(
                height: 36.sp,
              ),
              MyElevatedButton(
                fontSize: 40.h,
                onPressed: () async {
                  print(widget.size.text);
                  print(widget.price.text);
                  if(widget.size.text.isEmpty && widget.price.text.isEmpty) {
                    setState(() {
                      sizeError = "من فضلك أدخل الحجم";
                      priceError = "من فضلك أدخل السعر";
                    });
                  }
                  else if (
                  widget.size.text.isEmpty
                  ) {
                    setState(() {
                      sizeError = "من فضلك أدخل الحجم";
                      priceError = "";
                    });
                  }
                  else if(      widget.price.text.isEmpty) {
                    setState(() {
                      sizeError = "";
                      priceError = "من فضلك أدخل السعر";
                    });
                  }

                  else {
                    if (widget.edit) {
                      List sizes = [];
                      {
                        showDialog(
                          context: context,
                          builder: (context) => const Loading(),
                        );

                        for (var element in CategoryScreen.item.prices) {
                          sizes.add(element.toJson());
                        }


                        sizes[sizes.indexWhere((element) => element['id'] == widget.element.id)] =
                            SizeModel(
                                id: widget.element.id,
                                name: widget.size.text,
                                price: double.parse(widget.price.text))
                                .toJson();

                        await getFirestoreId().then((value) async {
                          await restaurantDocument
                              .collection('menu')
                              .doc(widget.category.firestoreId)
                              .collection('items')
                              .doc(CategoryScreen.item.firestoreId)
                              .update({'prices': sizes}).then((value) {

                            CategoryScreen.item.prices[CategoryScreen.item.prices
                                .indexWhere((element) => element.id == widget.element.id)] =
                                SizeModel(
                                    id: widget.element.id,
                                    name: widget.size.text,
                                    price: double.parse(widget.price.text));

                            item['prices'].clear();
                            for (var element in CategoryScreen.item.prices) {
                              item['prices'].add(element.toJson());
                            }

                            widget.rebuildWidgets(false);
                            saveMap();
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                            showSnackBar(
                              context: context,
                              message:
                              'تم تعديل ${widget.size.text} إلى ${widget.price
                                  .text}EGP بنجاح',
                            );
                          });
                        }).catchError((e) {
                          Navigator.pop(context);
                          showSnackBar(context: context, message: 'خطأ في الشبكة، حاول مرة أخرى');
                        });
                      }
                    } else {
                      int lenght = CategoryScreen.item.prices.length;

                      List sizes = [];

                      for (var element in CategoryScreen.item.prices) {
                        sizes.add(element.toJson());
                      }

                      SizeModel sizeModel = SizeModel(
                          id: widget.element.id,
                          name: widget.size.text,
                          price: double.parse(widget.price.text));

                      showDialog(
                          context: context,
                          builder: (context) => const Loading(),
                          barrierDismissible: false);

                      await getFirestoreId().then((value)  {
                        print('firestore got');
                        sizes.add(sizeModel.toJson());

                        restaurantDocument
                            .collection('menu')
                            .doc(widget.category.firestoreId)
                            .collection('items')
                            .doc(CategoryScreen.item.firestoreId)
                            .update({'prices': sizes}).then((value) {

                          print('updating');

                          item['prices'].add(sizeModel.toJson());

                          CategoryScreen.item.prices.insert(
                              lenght,
                              SizeModel(
                                  id: widget.element.id,
                                  name: widget.size.text,
                                  price: double.parse(widget.price.text)));

                          CategoryScreen.thisItem.prices = CategoryScreen.item.prices;





                          saveMap();
                          widget.rebuildWidgets(false);
                          print('items rebuilt');
                          Navigator.of(context).pop();

                          Navigator.of(context).pop();

                          showSnackBar(
                            context: context,
                            message:
                            'تم إضافة ${widget.size.text} - ${widget.price
                                .text}EGP بنجاح',
                          );
                        });
                      });
                    }
                  }


                },
                text: widget.edit ? 'تعديل' : 'إضافة',
                width: double.infinity,
                enabled: true,
                color: Colors.transparent,
                textColor: Colors.white,
                gradient: true,
              ),
              SizedBox(
                height: 24.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
