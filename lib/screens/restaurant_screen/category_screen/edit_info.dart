import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/show_snack_bar.dart';

import '../../../components/myElevatedButton.dart';
import '../../../components/myTextField.dart';
import '../../../components/my_scroll_configurations.dart';
import '../../../styles.dart';

class EditInfo extends StatefulWidget {
  String name;
  String description;

  EditInfo({super.key, required this.description, required this.name});

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    name.text = widget.name;
    description.text = widget.description;
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
                  'صنف جديد',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 64.sp),
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
                    isValidatable: true,
                    controller: description,
                    type: 'normal',
                    hintText: 'مثال: العجينة الطازجة مع الخضراوات والجبن اللذيذ',
                    isExpanding: true),
                SizedBox(
                  height: 24.sp,
                ),
                MyElevatedButton(
                  fontSize: 40.h,
                  onPressed: () {
                    Navigator.of(context).pop();
                    showSnackBar(context: context, message: 'تم التعديل',
                    );
                  },
                  text: 'تعديل',
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
