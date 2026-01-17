// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:kol/components/cachedAvatar.dart';
// import 'package:kol/styles.dart';
// import 'package:multi_image_layout/image_model.dart';

// import '../core/models/menu_models/category_model.dart';
// import '../core/models/menu_models/item_model.dart';
// import '../navigation_animations.dart';
// import '../screens/restaurant_screen/category_screen/image_viewer.dart';

// class MyMultiImageViewer extends StatelessWidget {
//   ItemModel item;
//   CategoryModel category;
//   Function() onDelete;

//   MyMultiImageViewer({
//     required this.onDelete,
//     required this.category,
//     required this.item,
//     Key? key,
//     required this.images,
//     this.backgroundColor = Colors.black87,
//     this.textStyle = const TextStyle(
//       fontSize: 30,
//       color: Colors.white,
//     ),
//     this.height = 205,
//     this.width,
//   }) : super(key: key);

//   /// Color of the background image.
//   final Color backgroundColor;

//   ///Color for the textStyle
//   final TextStyle textStyle;

//   /// ```List<ImageModel>``` of images and captions to display.
//   ///
//   /// Each image is displayed with respect to its corresponding caption.
//   ///
//   /// Images are compulsory while captions are optional.
//   final List<ImageModel> images;

//   /// Height of the image(s).
//   ///
//   /// If not set, it will be a height of 205.0.
//   final double height;

//   /// Width of the image(s).
//   final double? width;

//   @override
//   Widget build(BuildContext context) {
//     openImage(int index) {
//       Navigator.of(context).push(ScaleTransition5(MyImageViewer(
//         item: item,
//         url: images[index].imageUrl,
//         category: category,
//         onDelete: () {
//           onDelete();
//         },
//       )));
//     }

//     /// MediaQuery Width
//     double defaultWidth = MediaQuery.sizeOf(context).width;
//     final imagesList = images.map((image) => image.imageUrl).toList();
//     final captionList = images
//             .any((image) => image.caption != null && image.caption!.isNotEmpty)
//         ? images.map((image) => image.caption ?? '').toList()
//         : null;

//     switch (images.length) {
//       case 0:
//         return const SizedBox();

//       case 1:
//         return GestureDetector(
//           onTap: () => openImage(0),
//           child: SizedBox(
//             height: height,
//             width: width ?? defaultWidth,
//             child: CachedAvatar(
//               imageUrl: images.first.imageUrl,
//               fit: BoxFit.cover,
//             ),
//           ),
//         );

//       case 2:
//         return SizedBox(
//           height: height,
//           width: width ?? defaultWidth,
//           child: Row(children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 1),
//                 child: GestureDetector(
//                   onTap: () => openImage(1),
//                   child: SizedBox(
//                     height: height,
//                     width: width == null ? defaultWidth / 2 : width! / 2,
//                     child: CachedAvatar(
//                       imageUrl: images[1].imageUrl,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(right: 1),
//                 child: GestureDetector(
//                   onTap: () => openImage(0),
//                   child: SizedBox(
//                     height: height,
//                     width: width == null ? defaultWidth / 2 : width! / 2,
//                     child: CachedAvatar(
//                       imageUrl: images.first.imageUrl,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ]),
//         );

//       case 3:
//         return SizedBox(
//           height: height,
//           width: width ?? defaultWidth,
//           child: Row(children: [
//             Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 0),
//                 child: GestureDetector(
//                   onTap: () => openImage(2),
//                   child: SizedBox(
//                     height: double.infinity,
//                     width: width! / 2,
//                     child: CachedAvatar(
//                       imageUrl: images[2].imageUrl,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2, bottom: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(0),
//                         child: SizedBox(
//                             width: width! / 2,
//                             height: height / 2,
//                             child: CachedAvatar(
//                                 imageUrl: images.first.imageUrl,
//                                 fit: BoxFit.cover)),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(1),
//                         child: SizedBox(
//                           width: width! / 2,
//                           height: height / 2,
//                           child: CachedAvatar(
//                               imageUrl: images[1].imageUrl, fit: BoxFit.cover),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ]),
//         );

//       case 4:
//         return SizedBox(
//           height: height,
//           width: width ?? defaultWidth,
//           child: Row(children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 0, bottom: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(2),
//                         child: SizedBox(
//                           width: width! / 2,
//                           height: height / 2,
//                           child: CachedAvatar(
//                             imageUrl: images[2].imageUrl,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 0, top: 0),
//                       child: GestureDetector(
//                         onTap: () => openImage(3),
//                         child: SizedBox(
//                           width: width! / 2,
//                           height: height / 2,
//                           child: CachedAvatar(
//                             imageUrl: images[3].imageUrl,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2, bottom: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(0),
//                         child: SizedBox(
//                             width: width! / 2,
//                             height: height / 2,
//                             child: CachedAvatar(
//                               imageUrl: images.first.imageUrl,
//                               fit: BoxFit.cover,
//                             )),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(1),
//                         child: SizedBox(
//                           width: width! / 2,
//                           height: height / 2,
//                           child: CachedAvatar(
//                             imageUrl: images[1].imageUrl,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ]),
//         );

//       default:
//         return SizedBox(
//           height: height,
//           width: width ?? defaultWidth,
//           child: Row(children: [
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 0, bottom: 2),
//                       child: GestureDetector(
//                         onTap: () => Navigator.of(context)
//                             .push(ScaleTransition5(MyImageViewer(
//                           item: item,
//                           url: images[2].imageUrl,
//                           category: category,
//                           onDelete: () {
//                             onDelete();
//                           },
//                         ))),
//                         child: SizedBox(
//                             width: width! / 2,
//                             height: height / 2,
//                             child: CachedAvatar(
//                               imageUrl: images[2].imageUrl,
//                               fit: BoxFit.cover,
//                             )),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 0, top: 0),
//                       child: GestureDetector(
//                         onTap: () => openImage(3),
//                         child: SizedBox(
//                             width:
//                                 width == null ? defaultWidth / 2 : width! / 2,
//                             child: Stack(
//                               children: [
//                                 SizedBox(
//                                     width: width! / 2,
//                                     height: height / 2,
//                                     child: CachedAvatar(
//                                         imageUrl: images[3].imageUrl,
//                                         fit: BoxFit.cover)),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                       color: primaryColor.withOpacity(0.5),
//                                       borderRadius:
//                                           BorderRadius.circular(24.r)),
//                                   child: Center(
//                                       child: Text("+${images.length - 4}",
//                                           style: textStyle)),
//                                 ),
//                               ],
//                             )),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(
//               width: 2,
//             ),
//             Expanded(
//               child: Column(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2, bottom: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(0),
//                         child: SizedBox(
//                             width: width! / 2,
//                             height: height / 2,
//                             child: CachedAvatar(
//                               imageUrl: images.first.imageUrl,
//                               fit: BoxFit.cover,
//                             )),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(right: 2),
//                       child: GestureDetector(
//                         onTap: () => openImage(1),
//                         child: SizedBox(
//                           width: width! / 2,
//                           height: height / 2,
//                           child: CachedAvatar(
//                             imageUrl: images[1].imageUrl,
//                             fit: BoxFit.cover,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ]),
//         );
//     }
//   }
// }
