import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/myTextField.dart';
import 'package:kol/components/my_inkwell.dart';
import 'package:kol/components/my_scroll_configurations.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_storage/uploadImage.dart';
import 'package:kol/core/firestore_database/getDocId.dart';
import 'package:kol/core/models/menu_models/category_model.dart';
import 'package:kol/core/shared_preferences/saveMap.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/restaurant_screen/category_screen/edit_size_modal.dart';
import 'package:kol/screens/restaurant_screen/category_screen/image_viewer.dart';
import 'package:kol/screens/restaurant_screen/category_screen/item_data.dart';
import 'package:kol/screens/restaurant_screen/category_screen/item_size.dart';
import 'package:kol/screens/restaurant_screen/category_screen/item_widget.dart';
import 'package:kol/styles.dart';

// import 'package:multi_image_layout/image_model.dart';

import '../../../components/back_arrow_button.dart';
import '../../../components/loading.dart';
import '../../../components/my_alert_dialog.dart';
import '../../../components/my_flat_button.dart';
import '../../../core/models/menu_models/item_model.dart';
import 'package:kol/map.dart';
import '../../no_internet_screen.dart';
import 'add_item_modal_bottom_sheet.dart';
import 'image_widget.dart';

class CategoryScreen extends StatefulWidget {
  static List<ItemModel> items = [];
  static ItemModel item = ItemModel(
      id: "",
      firestoreId: "",
      name: "",
      image: "",
      description: "",
      time: DateTime.now().toString(),
      ordered: 0,
      images: [],
      prices: []);
  CategoryModel category;
  static List<Widget> imagesWidgets = [];
  static List<Widget> itemSizes = [];
  static ItemModel thisItem = ItemModel(
      id: "",
      firestoreId: "",
      name: "",
      time: DateTime.now().toString(),
      image: "",
      description: "",
      ordered: 0,
      images: [],
      prices: []);
  ItemModel chosenItem;

  CategoryScreen({super.key, required this.category, required this.chosenItem});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>
    with TickerProviderStateMixin {
  TextEditingController controller = TextEditingController();
  List<Widget> itemWidgets = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int index = 0;
  CategoryModel category = CategoryModel(
      id: "",
      name: "",
      image: "",
      type: "",
      firestoreId: "",
      items: [],
      time: DateTime.now().toString());
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  String selectedItem = '';
  List<CategoryModel> menu = [];

  getCategory() {
    int itemIndex = 0;
    setState(() {
      itemIndex = widget.chosenItem.name != ""
          ? CategoryScreen.items
              .indexWhere((element) => element.id == widget.chosenItem.id)
          : 0;

      CategoryScreen.item = category.items[itemIndex];
      CategoryScreen.thisItem = category.items[itemIndex];

      selectedItem = CategoryScreen.item.name;
      print('item images: ${CategoryScreen.item.images.length}');
      nameController.text = CategoryScreen.item.name;
      descriptionController.text = CategoryScreen.item.description;
    });
  }

  @override
  void initState() {
    Animate.restartOnHotReload = true;
    category = widget.category;
    CategoryScreen.items = category.items;

    CategoryScreen.items.sort(
        (a, b) => DateTime.parse(a.time).compareTo(DateTime.parse(b.time)));

    widget.chosenItem.name.isNotEmpty
        ? {
            CategoryScreen.imagesWidgets.clear(),
            CategoryScreen.itemSizes.clear(),
            CategoryScreen.item = widget.chosenItem,
            getCategory(),
            rebuildItemSizes(true),
            rebuildImages()
          }
        : CategoryScreen.items.isEmpty
            ? print('no items')
            : {
                CategoryScreen.imagesWidgets.clear(),
                CategoryScreen.itemSizes.clear(),
                getCategory(),
                rebuildItemSizes(true),
                rebuildImages()
              };

    super.initState();
  }

  Future<void> getFirestoreId() async {
    if (category.firestoreId == "" || CategoryScreen.item.firestoreId == "") {
      await getDocId(
              docWhere: restaurantDocument
                  .collection('menu')
                  .where('id', isEqualTo: category.id))
          .then((value) async {
        await restaurantDocument
            .collection('menu')
            .doc(category.firestoreId)
            .update({"firestoreId": category.firestoreId});
        category.firestoreId = value;
        saveMap();
        print('sssssss ${category.firestoreId}');
      }).then((value) async {
        await getDocId(
                docWhere: restaurantDocument
                    .collection('menu')
                    .doc(category.firestoreId)
                    .collection('items')
                    .where('id', isEqualTo: CategoryScreen.item.id))
            .then((value) async {
          CategoryScreen.item.firestoreId = value;
          await restaurantDocument
              .collection('menu')
              .doc(category.firestoreId)
              .collection('items')
              .doc(CategoryScreen.item.firestoreId)
              .update({"firestoreId": CategoryScreen.item.firestoreId});
          saveMap();
          print('fffffffffffff ${CategoryScreen.item.firestoreId}');
        });
      });
    } else {
      print('firestore ID already exist - category: ${category.firestoreId}');
      print(
          'firestore ID already exist - item: ${CategoryScreen.item.firestoreId}');
    }
  }

  deleteItem() async {
    CategoryScreen.items.length == 1
        ? {
            showDialog(
                context: context,
                builder: (context) => const Loading(),
                barrierDismissible: false),
            await getFirestoreId().then((value) {
              restaurantDocument
                  .collection('menu')
                  .doc(category.firestoreId)
                  .collection('items')
                  .doc(CategoryScreen.item.firestoreId)
                  .delete();
            }).then((value) {
              showSnackBar(
                context: context,
                message: 'تم حذف ${CategoryScreen.item.name} بنجاح',
              );
              CategoryScreen.items.clear();
              restaurantData
                  .menu[restaurantData.menu
                      .indexWhere((element) => element.id == category.id)]
                  .items
                  .clear();
              restaurant['menu'][restaurant['menu'].indexWhere(
                      (element) => element['id'] == category.id)]['items']
                  .clear();
              rebuildItemSizes(false);
              rebuildImages();
              saveMap();
              Navigator.pop(context);
            })
          }
        : setState(() {
            showDialog(
                context: context,
                builder: (context) => const Loading(),
                barrierDismissible: false);
            getFirestoreId().then((value) {
              restaurantDocument
                  .collection('menu')
                  .doc(category.firestoreId)
                  .collection('items')
                  .doc(CategoryScreen.item.firestoreId)
                  .delete();
            }).then((value) {
              showSnackBar(
                context: context,
                message: 'تم حذف ${CategoryScreen.thisItem.name} بنجاح',
              );
              CategoryScreen.items.remove(CategoryScreen.thisItem);
              category.items.remove(CategoryScreen.thisItem);
              restaurantData
                  .menu[restaurantData.menu
                      .indexWhere((element) => element.id == category.id)]
                  .items
                  .removeWhere(
                      (element) => element.id == CategoryScreen.item.id);
              restaurant['menu'][restaurant['menu'].indexWhere(
                      (element) => element['id'] == category.id)]['items']
                  .removeWhere(
                      (element) => element['id'] == CategoryScreen.item.id);
              print(
                  'lengthhhhh: ${restaurantData.menu[restaurantData.menu.indexWhere((element) => element.id == category.id)].items.length}');
              saveMap();
              CategoryScreen.thisItem = CategoryScreen.items[0];
              CategoryScreen.item = CategoryScreen.items[0];
              CategoryScreen.imagesWidgets.clear();
              CategoryScreen.itemSizes.clear();
              selectedItem = CategoryScreen.thisItem.name;
              rebuildItems(false, items: category.items);
              rebuildItemSizes(false);
              rebuildImages();
              Navigator.pop(context);
            });
          });
  }

  rebuildImages() {
    setState(() {
      CategoryScreen.imagesWidgets.clear();

      for (var element in CategoryScreen.item.images) {
        CategoryScreen.imagesWidgets.add(ImageWidget(
          url: element,
          item: CategoryScreen.item,
        ));
      }
    });
  }

  rebuildItemSizes(
    bool firstBuild,
  ) {
    setState(() {
      firstBuild ? false : CategoryScreen.itemSizes.clear();
      for (var element in CategoryScreen.item.prices) {
        TextEditingController size = TextEditingController();
        TextEditingController price = TextEditingController();
        size.text = element.name;
        price.text = element.price.toInt().toString();
        CategoryScreen.itemSizes.add(Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 8.sp),
          child: ItemSize(
              onSizeEdited: () {
                primaryBottomSheet(
                    child: EditSize(
                        category: category,
                        edit: true,
                        price: price,
                        size: size,
                        element: element,
                        rebuildWidgets: (x) => rebuildItemSizes(false)),
                    context: context);
              },
              onDelete: () {
                List prices = CategoryScreen.thisItem.prices;
                int index = CategoryScreen.item.prices.indexOf(element);
                List sizes = [];
                prices.length == 1
                    ? deleteItem()
                    : {
                        showDialog(
                            context: context,
                            builder: (context) => const Loading(),
                            barrierDismissible: false),
                        prices.forEach((element) {
                          sizes.add(element.toJson());
                        }),
                        sizes.remove(sizes[index]),
                        getFirestoreId().then((value) async {
                          await restaurantDocument
                              .collection('menu')
                              .doc(category.firestoreId)
                              .collection('items')
                              .doc(CategoryScreen.item.firestoreId)
                              .update({'prices': sizes});
                          CategoryScreen.item.prices
                              .remove(CategoryScreen.item.prices[index]);
                          rebuildItemSizes(false);
                          Navigator.pop(context);
                          showSnackBar(
                            context: context,
                            message:
                                'تم حذف ${element.name} - ${element.price}EGP بنجاح',
                          );
                        })
                      };
              },
              size: size.text,
              price: double.parse(price.text).round(),
              index: CategoryScreen.item.prices.indexOf(element),
              items: CategoryScreen.items,
              element: element),
        ));
      }
      print(CategoryScreen.thisItem);
    });
  }

  rebuildItems(bool firstTime, {required List<ItemModel> items}) {
    firstTime ? false : itemWidgets.clear();

    int index = 0;
    int milliSeconds = 75;

    for (var element in items) {
      String name = element.name;
      String image = category.image;

      controller.text.isEmpty
          ? {
              itemWidgets.add(ItemWidget(
                      name: name,
                      image: image,
                      map: element,
                      isSelected: selectedItem == name,
                      onPressed: (text) {
                        setState(() {
                          CategoryScreen.itemSizes.clear();
                          CategoryScreen.imagesWidgets.clear();
                          selectedItem = text;

                          nameController.text = element.name;
                          descriptionController.text = element.description;

                          CategoryScreen.item = element;
                          CategoryScreen.thisItem = element;

                          rebuildItemSizes(false);

                          rebuildImages();
                        });
                      })
                  .animate()
                  .scale(delay: Duration(milliseconds: milliSeconds))),
              index++,
              milliSeconds = milliSeconds + 75
            }
          : name.startsWith(controller.text)
              ? {
                  setState(() {
                    index = 0;
                  }),
                  itemWidgets.add(
                    ItemWidget(
                            name: name,
                            image: image,
                            map: element,
                            isSelected: selectedItem == name,
                            onPressed: (text) {
                              setState(() {
                                CategoryScreen.itemSizes.clear();
                                CategoryScreen.imagesWidgets.clear();
                                CategoryScreen.item = element;
                                CategoryScreen.thisItem = element;
                                selectedItem = text;
                                nameController.text = element.name;
                                descriptionController.text =
                                    element.description;
                                rebuildItemSizes(false);
                                rebuildImages();
                              });
                            })
                        .animate()
                        .scale(delay: Duration(milliseconds: milliSeconds)),
                  ),
                  index++,
                  milliSeconds = milliSeconds + 75
                }
              : print('none');
    }
  }

  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles = [];
  List<Widget> imageWidgets = [];

  void selectImages() async {
    try {
      var pickedfiles = await imgpicker.pickMultiImage(imageQuality: 75);
      setState(() {
        List<String> images = [];

        for (var element in CategoryScreen.item.images) {
          images.add(element);
        }

        pickedfiles.forEach((element) async {
          await uploadImage(File(element.path), element.name, context: context,
              onUploaded: (url) async {
            showDialog(context: context, builder: (context) => const Loading());

            images.add(url);

            List<ItemModel> itemModels = restaurantData
                .menu[restaurantData.menu
                    .indexWhere((element) => element.id == widget.category.id)]
                .items;

            ItemModel itemModel = itemModels[itemModels
                .indexWhere((element) => element.id == CategoryScreen.item.id)];

            List menu = restaurant['menu'];

            int categoryIndex = menu
                .indexWhere((element) => element['id'] == widget.category.id);

            Map<String, dynamic> categoryReferance = menu[categoryIndex];

            List items = categoryReferance['items'];

            int itemIndex = items
                .indexWhere((item) => item['id'] == CategoryScreen.thisItem.id);

            Map<String, dynamic> item = items[itemIndex];

            await getFirestoreId().then((value) async {
              await restaurantDocument
                  .collection('menu')
                  .doc(category.firestoreId)
                  .collection('items')
                  .doc(CategoryScreen.item.firestoreId)
                  .update({'images': images}).then((value) {
                CategoryScreen.item.images = images;
                itemModel.images = images;
                item['images'] = images;

                print('map images: $images');

                saveMap();
                Navigator.pop(context);
                rebuildImages();
              });
            });
          });
        });
      });
    } catch (e) {
      print("error while picking file.");
    }
  }

  @override
  Widget build(BuildContext context) {
    itemWidgets.clear();
    CategoryScreen.items.isEmpty
        ? print('a7a')
        : rebuildItems(true, items: CategoryScreen.items);

    return ScreenUtilInit(
        designSize: const Size(1080, 1920),
        builder: (context, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              key: _scaffoldKey,
              body: InternetCheck(
                child: Container(
                  decoration: BoxDecoration(
                      gradient: myGradient,
                      image: const DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage("assets/images/icons.png"))),
                  child: Stack(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(24.0.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              category.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 75.h,
                                      color: Colors.white),
                            ),
                            SizedBox(
                              width: 48.sp,
                            ),
                            const BackArrowButton()
                          ],
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(0, -24.sp),
                        child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(50.r)),
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Container(
                                    color: backGroundColor,
                                    height: 0.87.sh,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 40.sp,
                                          bottom: 0.sp,
                                          right: 40.sp,
                                          top: 40.sp),
                                      child: MyScrollConfigurations(
                                        horizontal: false,
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: [
                                              MyTextField(
                                                  descriptionTextField: false,
                                                  error: "",
                                                  title: "",
                                                  maxLength: 100,
                                                  isValidatable: false,
                                                  controller: controller,
                                                  onChanged: (text) {
                                                    print(controller.text);
                                                    setState(() {
                                                      itemWidgets.clear();
                                                    });
                                                  },
                                                  type: 'normal',
                                                  hintText: 'بحث',
                                                  isExpanding: false),
                                              SizedBox(
                                                height: 24.sp,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  itemWidgets.isEmpty
                                                      ? Center(
                                                          child: Text(
                                                          controller.text
                                                                  .isNotEmpty
                                                              ? 'لا يوجد منتج بهذا الإسم'
                                                              : 'أضف منتجاتك الآن من زر إضافة',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .displayMedium!
                                                              .copyWith(
                                                                  fontSize:
                                                                      36.sp,
                                                                  color:
                                                                      primaryColor),
                                                        ))
                                                      : Expanded(
                                                          child: SizedBox(
                                                              height: 0.765.sh,
                                                              child:
                                                                  MyScrollConfigurations(
                                                                horizontal:
                                                                    false,
                                                                child:
                                                                    SingleChildScrollView(
                                                                  child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        ItemData(
                                                                          onItemDelete:
                                                                              () {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) => MyAlertDialog(
                                                                                      isFirstButtonRed: true,
                                                                                      onFirstButtonPressed: () {
                                                                                        deleteItem();
                                                                                      },
                                                                                      onSecondButtonPressed: () {},
                                                                                      firstButton: 'حذف المنتج',
                                                                                      secondButton: 'إلغاء',
                                                                                      body: Container(),
                                                                                      title: 'هل انت متأكد؟',
                                                                                      description: 'سيتم حذف ${CategoryScreen.thisItem.name} من قائمة ${widget.category.name}، هل انت متأكد؟',
                                                                                      textfield: false,
                                                                                      controller: TextEditingController(),
                                                                                    ));
                                                                          },
                                                                          descriptionController:
                                                                              descriptionController,
                                                                          nameController:
                                                                              nameController,
                                                                          onPressed:
                                                                              () async {
                                                                            showDialog(
                                                                                context: context,
                                                                                builder: (context) => const Loading(),
                                                                                barrierDismissible: false);
                                                                            await getFirestoreId().then((value) async {
                                                                              await restaurantDocument.collection('menu').doc(category.firestoreId).collection('items').doc(CategoryScreen.item.firestoreId).update({
                                                                                'name': nameController.text,
                                                                                'description': descriptionController.text
                                                                              }).then((value) {
                                                                                setState(() {
                                                                                  CategoryScreen.item.name = nameController.text;
                                                                                  CategoryScreen.item.description = descriptionController.text;
                                                                                  CategoryScreen.thisItem.name = nameController.text;
                                                                                  CategoryScreen.thisItem.description = descriptionController.text;

                                                                                  List menu = restaurant['menu'];
                                                                                  int categoryIndex = menu.indexWhere((element) => element['id'] == category.id);
                                                                                  Map<String, dynamic> thisCategory = menu[categoryIndex];

                                                                                  List items = thisCategory['items'];
                                                                                  int itemIndex = items.indexWhere((item) => item['id'] == CategoryScreen.thisItem.id);
                                                                                  Map<String, dynamic> item = items[itemIndex];

                                                                                  item['name'] = nameController.text;
                                                                                  item['description'] = descriptionController.text;
                                                                                  saveMap();
                                                                                  Navigator.pop(context);
                                                                                });
                                                                              });
                                                                            });
                                                                          },
                                                                          name: CategoryScreen
                                                                              .item
                                                                              .name,
                                                                          description: CategoryScreen
                                                                              .item
                                                                              .description,
                                                                          element:
                                                                              CategoryScreen.item,
                                                                          category:
                                                                              category.name,
                                                                        )
                                                                            .animate()
                                                                            .fade(curve: Curves.easeInOutCubic)
                                                                            .scale(curve: Curves.easeInOutCubic),
                                                                        SizedBox(
                                                                          height:
                                                                              24.sp,
                                                                        ),
                                                                        Divider(
                                                                            color:
                                                                                warmColor),
                                                                        Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                    height: 100.h,
                                                                                    child: MyFlatButton(
                                                                                      textColor: primaryColor,
                                                                                      backgroundColor: backGroundColor,
                                                                                      hint: 'إضافة سعر',
                                                                                      onPressed: () {
                                                                                        TextEditingController sizeController = TextEditingController();
                                                                                        TextEditingController priceController = TextEditingController();

                                                                                        primaryBottomSheet(child: EditSize(category: category, edit: false, price: priceController, size: sizeController, element: SizeModel(name: '', price: 0, id: uuid.v1()), rebuildWidgets: (x) => rebuildItemSizes(false)), context: context);
                                                                                      },
                                                                                      fontSize: 36.h,
                                                                                    )),
                                                                                Text(
                                                                                  'الأسعار',
                                                                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 30.h, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24.sp,
                                                                            ),
                                                                            Column(
                                                                              children: CategoryScreen.itemSizes,
                                                                            ).animate(delay: const Duration(milliseconds: 300)).fade(curve: Curves.easeInOutCubic).scale(curve: Curves.easeInOutCubic),
                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              64.sp,
                                                                        ),
                                                                        Divider(
                                                                            color:
                                                                                warmColor),
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.end,
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                SizedBox(
                                                                                    height: 100.h,
                                                                                    child: MyFlatButton(
                                                                                      textColor: primaryColor,
                                                                                      backgroundColor: backGroundColor,
                                                                                      hint: 'إضافة صورة',
                                                                                      onPressed: () {
                                                                                        selectImages();
                                                                                      },
                                                                                      fontSize: 36.h,
                                                                                    )),
                                                                                Text(
                                                                                  'صور',
                                                                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 30.h, fontWeight: FontWeight.w400),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            SizedBox(
                                                                              height: 24.sp,
                                                                            ),
                                                                            Column(
                                                                              children: List.generate(
                                                                                  CategoryScreen.item.images.length,
                                                                                  (index) => Padding(
                                                                                        padding: EdgeInsets.all(12.sp),
                                                                                        child: MyInkWell(
                                                                                          onTap: () {
                                                                                            Navigator.push(
                                                                                                context,
                                                                                                SizeRTLNavigationTransition(MyImageViewer(
                                                                                                    onDelete: () => setState(() {
                                                                                                          rebuildImages();
                                                                                                        }),
                                                                                                    item: CategoryScreen.item,
                                                                                                    url: CategoryScreen.item.images[index],
                                                                                                    category: category)));
                                                                                          },
                                                                                          radius: 28.r,
                                                                                          child: SizedBox(
                                                                                            height: 0.15.sh,
                                                                                            width: double.infinity,
                                                                                            child: CachedAvatar(
                                                                                              fit: BoxFit.cover,
                                                                                              imageUrl: CategoryScreen.item.images[index],
                                                                                              borderRadius: 28.r,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                            )
                                                                            // MyMultiImageViewer(
                                                                            //   onDelete: () {
                                                                            //     setState(() {
                                                                            //       print('rebuilding');
                                                                            //       rebuildImages();
                                                                            //     });
                                                                            //   },
                                                                            //   category: category,
                                                                            //   item: CategoryScreen.item,
                                                                            //   images: List.generate(
                                                                            //     CategoryScreen.item.images.length,
                                                                            //     (index) => ImageModel(imageUrl: CategoryScreen.item.images[index]),
                                                                            //   ),
                                                                            //   width: 0.7.sw,
                                                                            //   height: 0.5.sw,
                                                                            // )
                                                                          ],
                                                                        )
                                                                            .animate(delay: const Duration(milliseconds: 450))
                                                                            .fade(curve: Curves.easeInOutCubic)
                                                                            .scale(curve: Curves.easeInOutCubic)
                                                                      ]),
                                                                ),
                                                              )

                                                              // ItemInfo(imagesWidgets: CategoryScreen.imagesWidgets, itemSize: CategoryScreen.itemSizes, data:CategoryScreen.item,)
                                                              ),
                                                        ),
                                                  SizedBox(
                                                    width: 32.sp,
                                                  ),
                                                  Column(
                                                    children: [
                                                      MyElevatedButton(
                                                        fontSize: 52.sp,
                                                        onPressed: () {
                                                          primaryBottomSheet(
                                                              context: context,
                                                              enableDrag: true,
                                                              isDismissible:
                                                                  true,
                                                              child: AddItem(
                                                                categoryName:
                                                                    category
                                                                        .name,
                                                                onAdd: () {
                                                                  setState(() {
                                                                    CategoryScreen
                                                                            .item =
                                                                        CategoryScreen
                                                                            .items[0];
                                                                    CategoryScreen
                                                                            .thisItem =
                                                                        CategoryScreen
                                                                            .items[0];

                                                                    selectedItem =
                                                                        CategoryScreen
                                                                            .item
                                                                            .name;

                                                                    nameController
                                                                            .text =
                                                                        CategoryScreen
                                                                            .item
                                                                            .name;
                                                                    descriptionController
                                                                            .text =
                                                                        CategoryScreen
                                                                            .item
                                                                            .description;
                                                                    rebuildItems(
                                                                        false,
                                                                        items: CategoryScreen
                                                                            .items);
                                                                    rebuildItemSizes(
                                                                        false);
                                                                    rebuildImages();
                                                                  });
                                                                },
                                                              ));
                                                        },
                                                        text: '+',
                                                        width: 200.h,
                                                        enabled: true,
                                                        color:
                                                            Colors.transparent,
                                                        gradient: true,
                                                        textColor: Colors.white,
                                                      ),
                                                      SizedBox(
                                                        height: 48.sp,
                                                      ),
                                                      SizedBox(
                                                        height: 0.7.sh,
                                                        child:
                                                            MyScrollConfigurations(
                                                          horizontal: false,
                                                          child:
                                                              SingleChildScrollView(
                                                            child: Column(
                                                                    children:
                                                                        itemWidgets)
                                                                .animate(
                                                                    delay: const Duration(
                                                                        milliseconds:
                                                                            200))
                                                                .fade(
                                                                    curve: Curves
                                                                        .easeInOutCubic)
                                                                .scale(
                                                                    curve: Curves
                                                                        .easeInOutCubic),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
