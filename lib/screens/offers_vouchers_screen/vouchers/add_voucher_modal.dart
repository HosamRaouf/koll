import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kol/core/firestore_database/getDocId.dart';
import 'package:kol/core/models/voucher_model.dart';
import 'package:kol/map.dart';

import '../../../components/loading.dart';
import '../../../components/myElevatedButton.dart';
import '../../../components/myTextField.dart';
import '../../../styles.dart';

class AddVoucher extends StatefulWidget {
  TextEditingController nameController;
  TextEditingController discountController;
  TextEditingController limitController;
  Function() onAdd;
  bool isEdit;
  VoucherModel voucher;

  AddVoucher(
      {super.key,
      required this.discountController,
      required this.nameController,
      required this.limitController,
        required this.voucher,
      required this.onAdd, required this.isEdit});

  @override
  State<AddVoucher> createState() => _AddVoucherState();
}

class _AddVoucherState extends State<AddVoucher> {
  @override
  void dispose() {
    widget.limitController.clear();
    widget.nameController.clear();
    widget.discountController.clear();
    super.dispose();
  }

updateVoucher() {
  VoucherModel voucher = VoucherModel(id: widget.voucher.id, firestoreId: widget.voucher.firestoreId, name: widget.nameController.text, discount: int.parse(widget.discountController.text), limit: int.parse(widget.limitController.text), time: widget.voucher.time);
  restaurantDocument.collection('vouchers').doc(voucher.firestoreId).update(voucher.toJson()).then((value) {
    widget.voucher = voucher;
    restaurant['vouchers'][restaurant['vouchers'].indexWhere((element) => element['id'] == voucher.id)] = voucher.toJson();
    restaurantData.vouchers[restaurantData.vouchers.indexWhere((element) => element.id == voucher.id)] = voucher;
    widget.onAdd();
  });
}

addVoucher() async {
    VoucherModel voucher = VoucherModel(
      id: uuid.v1(),
      firestoreId: "",
      name: widget.nameController.text,
      discount: int.parse(widget.discountController.text),
      limit: int.parse(widget.limitController.text),
      time: DateFormat("EEE, MMM d, yyyy – h:mm aaa")
          .format(DateTime.now())
          .toString(),
    );
    await restaurantDocument.collection('vouchers').add(voucher.toJson()).then((value) {
      getDocId(docWhere: restaurantDocument.collection('vouchers').where('id', isEqualTo: voucher.id)).then((id) {
        voucher.firestoreId = id;
        restaurantDocument.collection('vouchers').doc(id).update(voucher.toJson()).then((value) {
          restaurant['vouchers'].add(voucher.toJson());
          restaurantData.vouchers.add(voucher);
          widget.onAdd();
        });
      });
    });
}


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(28.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              widget.isEdit? 'تعديل الكوبون' : 'إضافة كوبون',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: primaryColor,
                  fontSize: 60.sp,
                  fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 28.sp,
            ),
            MyTextField(
              error: '',
              descriptionTextField: false,
              title: 'كود الخصم',
              controller: widget.nameController,
              type: 'normal',
              hintText: 'e.g: EXAMPLE25',
              maxLength: 14,
              isExpanding: false,
              isValidatable: true,
              onSubmit: () {},
              onChanged: (text) {},
            ),
            SizedBox(
              height: 28.sp,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  child: MyTextField(
                    error: '',
                    descriptionTextField: false,

                    title: 'الحد الأدنى للأوردر',
                    controller: widget.limitController,
                    type: 'number',
                    hintText: 'e.g: 200EGP',
                    maxLength: 4,
                    isExpanding: false,
                    isValidatable: true,
                    onSubmit: () {},
                    onChanged: (text) {},
                  ),
                ),
                SizedBox(
                  child: MyTextField(
                    descriptionTextField: false,
                    error: '',
                    title: 'النسبة المئوية للخصم',
                    maxLength: 2,
                    controller: widget.discountController,
                    type: 'number',
                    hintText: 'e.g: 25%',
                    isExpanding: false,
                    isValidatable: true,
                    onSubmit: () {},
                    onChanged: (text) {},
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 28.sp,
            ),
            MyElevatedButton(
              onPressed: () async {
                  if (widget.discountController.text.isNotEmpty &&
                      widget.nameController.text.isNotEmpty &&
                      widget.limitController.text.isNotEmpty) {
                    showDialog(context: context, builder: (context)=> const Loading());
                    widget.isEdit? await updateVoucher() : await addVoucher();
                  }
              },
              text:widget.isEdit? 'تعديل' : 'إضافة',
              width: double.infinity,
              enabled: true,
              fontSize: 52.sp,
              color: Colors.transparent,
              textColor: Colors.white,
              gradient: true,
            )
          ],
        ),
      ),
    );
  }
}
