import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/cachedAvatar.dart';
import 'package:kol/core/models/order_model.dart';
import '../../../components/my_image.dart';
import '../../../components/my_inkwell.dart';
import '../../../components/phone_number.dart';
import '../../../core/models/driver_model.dart';
import '../../../navigation_animations.dart';
import '../../../styles.dart';
import '../../drivers_screen/driver_profile/driver_profile.dart';
import 'package:kol/map.dart';
import 'add_driver_dialog.dart';

class OrderDriver extends StatefulWidget {
  OrderModel order;
  double radius;
  OrderDriver({super.key, required this.order, required this.radius});

  @override
  State<OrderDriver> createState() => _OrderDriverState();
}

class _OrderDriverState extends State<OrderDriver> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String driverId = widget.order.driverId;
    int driverIndex;
    DriverModel driver;

    driverId != ""
        ? {
            driverIndex = restaurantData.drivers
                .indexWhere((element) => element.id == driverId),
            driver = restaurantData.drivers[driverIndex],
            print(driver.toJson())
          }
        : {
            driver = DriverModel(
                id: "",
                firestoreId: "",
                name: widget.order.driverName,
                phoneNumber: widget.order.driverPhoneNumber,
                image: widget.order.driverImage,
                orders: [],
                rates: [])
          };

    return Container(
      decoration: cardDecoration.copyWith(
          borderRadius: BorderRadius.circular(widget.radius)),
      width: double.infinity,
      child: MyInkWell(
        onTap: () {
          driver.id != ""
              ? Navigator.of(context)
                  .push(ScaleTransition5(DriverProfile(driver: driver)))
              : showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController nameController =
                        TextEditingController();
                    TextEditingController phoneNumberController =
                        TextEditingController();
                    String imagePath = 'assets/images/user.png';

                    nameController.text = driver.name;
                    phoneNumberController.text = driver.phoneNumber;

                    Widget imageWidget = Image.asset('assets/images/user.png');

                    return AddDriverDialog(
                        phoneNumberController: phoneNumberController,
                        nameController: nameController,
                        imagePath: imagePath,
                        imageWidget: imageWidget,
                        selectImage: (url) {
                          setState(() {
                            imagePath = url;
                            imageWidget = CachedAvatar(imageUrl: url);
                          });
                        });
                  });
          print(widget.order.driverName);
        },
        radius: 25.r,
        child: Padding(
          padding: EdgeInsets.all(24.0.sp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PhoneNumber(phoneNumber: driver.phoneNumber),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'وصل الأوردر:',
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(fontSize: 28.sp),
                      ),
                      SizedBox(
                        width: 0.28.sw,
                        child: Text(
                          driver.name,
                          textDirection: TextDirection.rtl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge!
                              .copyWith(fontSize: 48.sp),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 24.sp,
                  ),
                  ClipOval(
                    child: MyImage(
                        width: 100.h,
                        height: 100.h,
                        image: driver.id.isNotEmpty
                            ? driver.image
                            : 'assets/images/user.png'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
