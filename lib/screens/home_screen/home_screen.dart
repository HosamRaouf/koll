import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:kol/components/my_drawer.dart';
import 'package:kol/map.dart';
import 'package:kol/screens/home_screen/my_bottom_navigation_bar.dart';
import 'package:kol/screens/no_internet_screen.dart';
import 'package:kol/screens/users_screen/users_screen.dart';
import 'package:rive/rive.dart' hide LinearGradient, Image;

import '../../components/cachedAvatar.dart';
import '../../components/loading.dart';
import '../../components/responsive_layout.dart';
import '../../core/models/driver_model.dart';
import '../../core/models/order_model.dart';
import '../../styles.dart';
import 'logic.dart';
import 'order_widget/order.dart' as or;

List ordersUsers = [];
ValueNotifier<List<OrderModel>> streamValueNotifier =
    ValueNotifier<List<OrderModel>>([]);

class HomeScreen extends StatefulWidget {
  final bool isKitchen;
  static ValueNotifier<int> index = ValueNotifier<int>(2);
  static PageController pageController = PageController(initialPage: 3);

  const HomeScreen({Key? key, required this.isKitchen}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>("");

  Stream<QuerySnapshot<Map<String, dynamic>>> ordersStream = restaurantDocument
      .collection("orders")
      .orderBy("time", descending: true)
      .snapshots();

  @override
  void initState() {
    bool showReadyState = kIsWeb && !widget.isKitchen;
    bool isKitchenWeb = kIsWeb && widget.isKitchen;

    if (isKitchenWeb) {
      HomeScreen.index.value = 0;
      HomeScreen.pageController = PageController(initialPage: 0);
    } else if (showReadyState) {
      HomeScreen.index.value = 3;
      HomeScreen.pageController = PageController(initialPage: 3);
    } else {
      HomeScreen.index.value = 2;
      HomeScreen.pageController = PageController(initialPage: 2);
    }

    ordersStream.listen((event) {
      if (!mounted) return;
      streamValueNotifier.value.clear();
      for (var element in event.docs) {
        streamValueNotifier.value.add(OrderModel.fromJson(element.data()));
        if (!users.any((u) => u.firestoreId == element.data()['userId'])) {
          or.fetchUser(element.data()['userId']);
        }
      }
      Future.delayed(const Duration(seconds: 1), () {
        streamValueNotifier.notifyListeners();
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    ordersStream.listen((event) {}).cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: kIsWeb ? const Size(1920, 1080) : const Size(1080, 1920),
        minTextAdapt: true,
        splitScreenMode: true);
    return InternetCheck(
      child: SafeArea(
        child: ResponsiveLayout(
          mobileBody: _buildMobileLayout(context),
          desktopBody: _buildDesktopLayout(context),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              color: warmColor,
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                Image.asset("assets/images/icons2.png").image,
                            fit: BoxFit.cover),
                        gradient: LinearGradient(
                            colors: [accentColor, primaryColor])),
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: 18.sp, top: 18.sp, bottom: 18.sp),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: CachedAvatar(
                                imageUrl: restaurantData.image,
                                borderRadius: 20,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  restaurantData.name,
                                  style: TextStyling.headline.copyWith(
                                      color: Colors.white,
                                      fontSize: 52.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 24.sp,
                                ),
                                SizedBox(
                                  width: 24.sp,
                                ),
                                if (restaurantData.specials.isNotEmpty)
                                  Row(
                                    children: restaurantData.specials
                                        .map((special) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8),
                                              child: Image.asset(
                                                special,
                                                height: 40,
                                                fit: BoxFit.contain,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    const SizedBox.shrink(),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 16),
                                  decoration: cardDecoration.copyWith(
                                      color: Colors.white),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'كاشير',
                                        style: TextStyling.smallFont.copyWith(
                                          color: !widget.isKitchen
                                              ? primaryColor
                                              : Colors.grey,
                                          fontWeight: !widget.isKitchen
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Switch(
                                        value: widget.isKitchen,
                                        activeColor: primaryColor,
                                        activeTrackColor:
                                            primaryColor.withOpacity(0.5),
                                        inactiveThumbColor: primaryColor,
                                        inactiveTrackColor:
                                            primaryColor.withOpacity(0.5),
                                        onChanged: (value) {
                                          Navigator.pushReplacement(
                                            context,
                                            PageRouteBuilder(
                                              pageBuilder: (context, a1, a2) =>
                                                  HomeScreen(isKitchen: value),
                                              transitionDuration: Duration.zero,
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'مطبخ',
                                        style: TextStyling.smallFont.copyWith(
                                          color: widget.isKitchen
                                              ? primaryColor
                                              : Colors.grey,
                                          fontWeight: widget.isKitchen
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: RiveAnimation.asset(
                                        "assets/riv/logo.riv",
                                        artboard: "New Artboard",
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: 12.sp, horizontal: 24.sp),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (!(kIsWeb && widget.isKitchen))
                              Container(
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(50),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      )
                                    ]),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                child: MyBottomNavigationBar(
                                    index: HomeScreen.index.value,
                                    pageController: HomeScreen.pageController,
                                    isKitchen: widget.isKitchen,
                                    isWeb: true),
                              ),
                            SizedBox(
                              width: 24.sp,
                            ),
                            Container(
                              width: 300.h,
                              decoration: cardDecoration.copyWith(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (v) => _searchQuery.value = v,
                                textAlign: TextAlign.right,
                                style: TextStyling.smallFont.copyWith(
                                    color: Colors.black,
                                    fontSize: kIsWeb ? 18 : 22.sp),
                                decoration: InputDecoration(
                                  hintText: "بحث برقم الأوردر",
                                  hintStyle: TextStyling.smallFont
                                      .copyWith(fontSize: kIsWeb ? 18 : 22.sp),
                                  prefixIcon:
                                      Icon(Icons.search, color: primaryColor),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                    borderSide: const BorderSide(
                                        color: Colors.transparent),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50.r),
                                    borderSide: BorderSide(
                                        color: primaryColor, width: 2),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ValueListenableBuilder(
                            valueListenable: HomeScreen.index,
                            builder: (context, index, child) {
                              bool showReadyState = kIsWeb && !widget.isKitchen;
                              bool isKitchenWeb = kIsWeb && widget.isKitchen;
                              String stateName = "";
                              IconData stateIcon = Icons.error;

                              if (isKitchenWeb) {
                                stateName = "عالنار";
                                stateIcon = Icons.local_fire_department_sharp;
                              } else if (showReadyState) {
                                stateName = index == 0
                                    ? "في الطريق"
                                    : index == 1
                                        ? "جاهز"
                                        : index == 2
                                            ? "عالنار"
                                            : "عند الكاشير";
                                stateIcon = index == 0
                                    ? Icons.delivery_dining_sharp
                                    : index == 1
                                        ? Icons.restaurant_menu_rounded
                                        : index == 2
                                            ? Icons.local_fire_department_sharp
                                            : Iconsax.receipt_2_15;
                              } else {
                                stateName = index == 0
                                    ? "في الطريق"
                                    : index == 1
                                        ? "عالنار"
                                        : "عند الكاشير";
                                stateIcon = index == 0
                                    ? Icons.delivery_dining_sharp
                                    : index == 1
                                        ? Icons.local_fire_department_sharp
                                        : Iconsax.receipt_2_15;
                              }

                              return ValueListenableBuilder(
                                  valueListenable: streamValueNotifier,
                                  builder: (context, orders, child) {
                                    int count = orders
                                        .where((e) => e.state == stateName)
                                        .length;
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "($count) $stateName",
                                          textAlign: TextAlign.right,
                                          style: TextStyling.headline
                                              .copyWith(fontSize: 42.sp),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(stateIcon,
                                            color: primaryColor, size: 48.sp),
                                      ],
                                    );
                                  });
                            }),
                      ],
                    ),
                  ),
                  _buildOrdersList(context),
                  kIsWeb
                      ? Container()
                      : const SizedBox(
                          width: 300,
                          child: MyDrawer(),
                        ),
                ],
              ),
            ),
            ValueListenableBuilder(
                valueListenable: isLoading,
                builder: (context, isLoading, child) =>
                    isLoading ? const Loading() : Container())
          ],
        ));
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawerDragStartBehavior: DragStartBehavior.start,
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: (kIsWeb && widget.isKitchen)
          ? null
          : Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                decoration: BoxDecoration(
                    gradient: myGradient,
                    image: const DecorationImage(
                        image: AssetImage("assets/images/icons2.png"),
                        fit: BoxFit.cover)),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.sp),
                  child: MyBottomNavigationBar(
                      index: HomeScreen.index.value,
                      isKitchen: widget.isKitchen,
                      pageController: HomeScreen.pageController),
                ),
              ),
            ),
      endDrawer: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(60.sp),
            bottomLeft: Radius.circular(60.sp)),
        child: const MyDrawer(),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 1920.h,
            decoration: BoxDecoration(
                gradient: myGradient,
                image: const DecorationImage(
                    image: AssetImage("assets/images/icons2.png"),
                    alignment: Alignment.topCenter,
                    fit: BoxFit.fitWidth)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 0.15.sw,
                      width: 0.15.sw,
                      child: const RiveAnimation.asset(
                        "assets/riv/logo.riv",
                        artboard: "New Artboard",
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 48.sp, vertical: 10.sp),
                    child: SizedBox(
                      height: 100.h,
                      width: 100.h,
                      child: IconButton(
                          padding: const EdgeInsets.all(0.0),
                          alignment: Alignment.centerRight,
                          onPressed: () =>
                              _scaffoldKey.currentState?.openEndDrawer(),
                          icon: Icon(
                            Icons.dehaze_rounded,
                            color: backGroundColor,
                            size: 75.h,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.sp,
              ),
              _buildOrdersList(context),
            ],
          ),
          ValueListenableBuilder(
              valueListenable: isLoading,
              builder: (context, isLoading, child) =>
                  isLoading ? const Loading() : Container())
        ],
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context) {
    bool isKitchenWeb = kIsWeb && widget.isKitchen;

    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
            top: kIsWeb ? const Radius.circular(0) : Radius.circular(50.r)),
        child: Container(
          color: warmColor,
          child: PageView(
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling:
                  false, // Disabled implicit scrolling to reduce background work
              physics: isKitchenWeb
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              controller: HomeScreen.pageController,
              onPageChanged: (newIndex) {
                HomeScreen.index.value = newIndex;
              },
              children: isKitchenWeb
                  ? [_buildTabContent("عالنار", 0)]
                  : [
                      _buildTabContent("في الطريق", 0),
                      _buildTabContent("جاهز", 1),
                      _buildTabContent("عالنار", 2),
                      _buildTabContent("عند الكاشير", 3),
                    ]),
        ),
      ),
    );
  }

  Widget _buildTabContent(String stateName, int tabIndex) {
    return ValueListenableBuilder(
        valueListenable: lateOrders,
        builder: (context, value, child) {
          return ValueListenableBuilder(
              valueListenable: streamValueNotifier,
              builder: (context, allOrders, child) {
                return ValueListenableBuilder(
                    valueListenable: _searchQuery,
                    builder: (context, query, child) {
                      List<OrderModel> tabOrders = allOrders.where((order) {
                        bool matchesState = order.state == stateName;
                        if (!matchesState) return false;
                        if (query.isEmpty) return true;
                        String orderNumber =
                            order.id.hashCode.toString().substring(0, 3);
                        return orderNumber.contains(query);
                      }).toList();

                      if (tabOrders.isEmpty) {
                        return Center(
                          child: Text(
                            "مفيش أوردرات دلوقتي",
                            style: TextStyling.subtitle
                                .copyWith(color: primaryColor),
                          ),
                        );
                      }

                      tabOrders.sort((a, b) => myDateTimeFormat
                          .parse(b.time)
                          .compareTo(myDateTimeFormat.parse(a.time)));

                      bool isDesktop = (kIsWeb ||
                          defaultTargetPlatform == TargetPlatform.macOS ||
                          defaultTargetPlatform == TargetPlatform.windows ||
                          defaultTargetPlatform == TargetPlatform.linux);

                      return isDesktop
                          ? MasonryGridView.count(
                              padding: EdgeInsets.all(12.sp),
                              cacheExtent: 1500,
                              physics: const BouncingScrollPhysics(),
                              crossAxisCount: 3,
                              mainAxisSpacing: 12.sp,
                              crossAxisSpacing: 12.sp,
                              itemCount: tabOrders.length,
                              itemBuilder: (context, index) =>
                                  _orderItem(tabOrders[index]),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(12.sp),
                              cacheExtent:
                                  1000, // Pre-render more items for mobile
                              itemCount: tabOrders.length,
                              itemBuilder: (context, index) =>
                                  _orderItem(tabOrders[index]),
                            );
                    });
              });
        });
  }

  Widget _orderItem(OrderModel order) {
    final userIdx = users.indexWhere((u) => u.firestoreId == order.userId);
    if (userIdx == -1) return loading();

    print(lateOrders.value.any((n) => n.contains(order.orderNumber)));
    return RepaintBoundary(
      child: or.Order(
        user: users[userIdx],
        isLate: lateOrders.value.any((n) => n.contains(order.orderNumber)),
        order: order,
        onOrderAccepted: () => _handleAccept(order),
        onOrderSubmit: _handleAssign,
        onOrderCompleted: () => _handleComplete(order),
        isDriverOrder: false,
        onDelete: (body) => _handleDelete(order, body),
        isKitchen: widget.isKitchen,
        onReady: () => _handleReady(order),
      ),
    );
  }

  void _handleReady(OrderModel order) async {
    isLoading.value = true;
    await readyOrder(order, isLoading);
    isLoading.value = false;
  }

  void _handleAccept(OrderModel order) async {
    isLoading.value = true;
    if (order.items.isNotEmpty) {
      for (var item in order.items) {
        final catIdx = restaurantData.menu
            .indexWhere((e) => e.firestoreId == item.firestoreCategoryId);
        if (catIdx != -1) {
          final itemIdx = restaurantData.menu[catIdx].items
              .indexWhere((e) => e.firestoreId == item.firestoreItemId);
          if (itemIdx != -1) {
            int ordered =
                restaurantData.menu[catIdx].items[itemIdx].ordered + 1;
            await restaurantDocument
                .collection('menu')
                .doc(item.firestoreCategoryId)
                .collection("items")
                .doc(item.firestoreItemId)
                .update({"ordered": ordered});
          }
        }
      }
    }
    if (!mounted) return;
    acceptOrder(order, context, isLoading);
    isLoading.value = false;
    audioPlayer.play(AssetSource("audio/3alnaar.mp3"));
  }

  void _handleAssign(OrderModel order, DriverModel driver) async {
    isLoading.value = true;
    await assignDriver(order, driver, isLoading);
    isLoading.value = false;
    audioPlayer.play(AssetSource("audio/beeb.mp3"));
  }

  void _handleComplete(OrderModel order) async {
    isLoading.value = true;
    await orderComplete(order, isLoading);
    isLoading.value = false;
    audioPlayer.play(AssetSource("audio/complete.mp3"));
  }

  void _handleDelete(OrderModel order, String body) async {
    isLoading.value = true;
    await declineOrder(order, body);
    isLoading.value = false;
  }
}
