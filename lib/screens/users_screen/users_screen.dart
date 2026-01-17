import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:kol/core/models/user_models/user_model.dart';
import 'package:kol/screens/home_screen/home_screen.dart';

import '../../components/blank_screen.dart';
import '../../components/myTextField.dart';
import '../../map.dart';
import '../../styles.dart';
import '../home_screen/order_widget/order.dart';
import 'logic.dart';

List finishedOrdersUsers = [];

Future<void> fetchUsers() async {
  if (users.isEmpty) {
    print(
        "================================================ 📡 Fetching Users 📡 ==========================================");

    for (var order in restaurantData.finishedOrders) {
      if (users.where((element) => element.id == order.userId).isEmpty) {
        if (!restaurantData.bannedUsers.contains(order.userId)) {
          if (!ordersUsers.contains(order.userId)) {
            if (!finishedOrdersUsers.contains(order.userId)) {
              finishedOrdersUsers.add(order.userId);
            }
          }
        }
      }
    }

    for (var element in finishedOrdersUsers) {
      UserModel user = await fetchUser(element);
      if (users.where((element) => element.id == user.id).isEmpty) {
        users.add(user);
      }
    }

    await restaurantDocument.collection("orders").get().then((value) {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) async {
          UserModel user = await fetchUser(element.data()["userId"]);
          if (users.where((element) => element.id == user.id).isEmpty) {
            users.add(user);
          }
        });
      }
    });

    print(
        "================================================ ✅ Users Fetched ✅ ==========================================");
  } else {
    print(
        "================================================ 😉 Users already fetched 😉 ==========================================");
  }
}

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    buildUsers();
    return ScreenUtilInit(
      builder: (context, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: BlankScreen(
          title: 'العملاء',
          child: Padding(
              padding: EdgeInsets.all(40.sp),
              child: Column(
                children: [
                  search(
                      searchController,
                      (p0) => setState(() {
                            searchUsers(searchController.text);
                          })),
                  searchedUserWidgets.isNotEmpty
                      ? searchedUsers()
                      : searchController.text.isNotEmpty
                          ? usersEmptyState(context)
                          : userWidgets.isNotEmpty
                              ? myUsers()
                              : usersEmptyState(context)
                ],
              )),
        )),
      ),
      designSize: const Size(1080, 1920),
    );
  }
}

Widget loading() {
  return Padding(
    padding: EdgeInsets.all(24.sp),
    child: Container(
      width: double.infinity,
      height: 0.2.sh,
      decoration: cardDecoration,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 100.h,
              width: 100.h,
              child: CircularProgressIndicator(
                color: primaryColor,
              )),
          SizedBox(
            height: 24.sp,
          ),
          Text(
            "جاري التحميل",
            style: TextStyling.headline
                .copyWith(fontWeight: FontWeight.w500, fontSize: 42.sp),
          ).animate(onComplete: (controller) {
            controller
                .animateBack(0)
                .then((value) => controller.animateBack(1));
          }).fade(
              duration: const Duration(milliseconds: 400),
              curve: Curves.fastEaseInToSlowEaseOut),
        ],
      )),
    ),
  );
}

Widget search(
    TextEditingController searchController, Function(String) onChanged) {
  return Padding(
    padding: EdgeInsets.only(bottom: 16.sp),
    child: MyTextField(
      descriptionTextField: false,
      title: "",
      error: "",
      maxLength: 100,
      controller: searchController,
      type: 'normal',
      hintText: 'بحث',
      isExpanding: false,
      isValidatable: false,
      onChanged: (text) {
        onChanged(text);
      },
    ),
  );
}

Widget searchedUsers() {
  return Expanded(
    child: Container(
      child: AnimationLimiter(
        child: GridView.count(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          crossAxisCount: 2,
          children: List.generate(
            searchedUserWidgets.length,
            (int index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 600),
                columnCount: 2,
                child: ScaleAnimation(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.fastLinearToSlowEaseIn,
                  child: FadeInAnimation(child: searchedUserWidgets[index]),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

Widget usersEmptyState(BuildContext context) {
  return SizedBox(
      height: 0.7.sh,
      child: Center(
          child: Text(
        'لا يوجد مستخدمين',
        style: Theme.of(context)
            .textTheme
            .displayMedium!
            .copyWith(fontSize: 40.sp, color: primaryColor),
      )));
}

Widget myUsers() {
  return Expanded(
    child: AnimationLimiter(
      child: GridView.count(
        crossAxisSpacing: 20.sp,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        crossAxisCount: 2,
        children: List.generate(
          userWidgets.length,
          (int index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 600),
              columnCount: 2,
              child: ScaleAnimation(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.fastLinearToSlowEaseIn,
                child: FadeInAnimation(child: userWidgets[index]),
              ),
            );
          },
        ),
      ),
    ),
  );
}
