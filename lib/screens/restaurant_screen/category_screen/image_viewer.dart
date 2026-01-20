import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/back_arrow_button.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/components/my_alert_dialog.dart';
import 'package:kol/styles.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../components/loading.dart';
import '../../../components/show_snack_bar.dart';
import '../../../core/firestore_database/getDocId.dart';
import '../../../core/models/menu_models/category_model.dart';
import '../../../core/models/menu_models/item_model.dart';
import '../../../core/shared_preferences/saveMap.dart';
import 'package:kol/map.dart';
import 'category_screen.dart';

class MyImageViewer extends StatefulWidget {
  CategoryModel category;
  ItemModel item;
  String url;
  Function() onDelete;

  MyImageViewer(
      {super.key,
      required this.onDelete,
      required this.item,
      required this.url,
      required this.category});

  @override
  State<MyImageViewer> createState() => _MyImageViewerState();
}

class _MyImageViewerState extends State<MyImageViewer> {
  List<Widget> imageWidgets = [];

  @override
  Widget build(BuildContext context) {
    int imageIndex =
        widget.item.images.indexWhere((element) => element == widget.url);

    Future<void> getFirestoreId() async {
      if (widget.category.firestoreId == "" ||
          CategoryScreen.item.firestoreId == "") {
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
            saveMap();
          });
        });
      } else {
        print(
            'firestore ID already exist - category: ${widget.category.firestoreId}');
        print(
            'firestore ID already exist - item: ${CategoryScreen.item.firestoreId}');
      }
    }

    Future<void> deleteImage(String indexedImage) async {
      setState(() {
        List<String> newImages = [];

        for (var element in CategoryScreen.item.images) {
          newImages.add(element);
        }

        newImages.remove(
            newImages[newImages.indexWhere((image) => image == indexedImage)]);

        showDialog(
            context: context,
            builder: (context) => const Loading(),
            barrierDismissible: false);
        getFirestoreId().then((value) async {
          await restaurantDocument
              .collection('menu')
              .doc(widget.category.firestoreId)
              .collection('items')
              .doc(CategoryScreen.item.firestoreId)
              .update({'images': newImages}).then((value) {
            List menu = restaurant['menu'];
            int categoryIndex = menu
                .indexWhere((element) => element['id'] == widget.category.id);
            Map<String, dynamic> category = menu[categoryIndex];

            List items = category['items'];
            int itemIndex = items
                .indexWhere((item) => item['id'] == CategoryScreen.thisItem.id);
            Map<String, dynamic> item = items[itemIndex];

            item['images'] = newImages;
            CategoryScreen.item.images = newImages;

            Navigator.pop(context);
            Navigator.pop(context);

            widget.onDelete();

            showSnackBar(context: context, message: 'تم الحذف');
          }).onError((error, stackTrace) => showSnackBar(
                  context: context, message: 'خطأ في الشبكة، حاول مرة أخرى'));
        });
      });
    }

    PageController? controller = PageController(initialPage: imageIndex);

    return SafeArea(
      child: GestureDetector(
        onVerticalDragStart: (details) {
          Navigator.pop(context);
        },
        child: Stack(
          children: [
            PhotoViewGallery.builder(
              pageController: controller,
              onPageChanged: (index) {
                imageIndex = index;
              },
              scrollPhysics: const BouncingScrollPhysics(),
              builder: (context, index) {
                return PhotoViewGalleryPageOptions.customChild(
                    child: SizedBox(
                        width: 1.sw,
                        child:
                            CachedAvatar(imageUrl: widget.item.images[index])));
              },
              itemCount: widget.item.images.length,
            ),
            Padding(
              padding: EdgeInsets.all(40.sp),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: 100.h,
                          height: 100.h,
                          child: ClipOval(
                            child: Material(
                              color: primaryColor.withOpacity(0.3),
                              child: IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => MyAlertDialog(
                                          controller: TextEditingController(),
                                          description: '',
                                          textfield: false,
                                          title: "حذف الصورة؟",
                                          body: Container(
                                            child: CachedAvatar(
                                                imageUrl: widget
                                                    .item.images[imageIndex]),
                                          ),
                                          firstButton: 'حذف',
                                          secondButton: 'الغاء',
                                          onFirstButtonPressed: () {
                                            deleteImage(
                                                widget.item.images[imageIndex]);
                                          },
                                          onSecondButtonPressed: () {},
                                          isFirstButtonRed: true));
                                },
                                icon: Icon(Iconsax.trash,
                                    color: Colors.white, size: 72.sp),
                                splashColor: backGroundColor.withOpacity(0.5),
                                splashRadius: 64.sp,
                              ),
                            ),
                          )),
                      const BackArrowButton(),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
