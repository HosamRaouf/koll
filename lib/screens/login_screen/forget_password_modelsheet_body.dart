import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/core/firebase_auth/resetPassword.dart';

import '../../components/loading.dart';
import '../../components/myTextField.dart';
import '../../styles.dart';

class ForgetPasswordModelSheet extends StatefulWidget {
  const ForgetPasswordModelSheet({Key? key, this.isWeb = false}) : super(key: key);
  static  TextEditingController forgotPasswordController = TextEditingController();
  final bool isWeb;


  @override
  State<ForgetPasswordModelSheet> createState() => _ForgetPasswordModelSheetState();
}

class _ForgetPasswordModelSheetState extends State<ForgetPasswordModelSheet> {

  bool isLoading = false;
  String emailError = "";

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding:
          const EdgeInsets
              .all(15.0),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment
                .end,
            children: [
              Text(
                'نسيت كلمة المرور؟',
                style: Theme.of(
                    context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(
                    fontSize: widget.isWeb ? 24 :
                    70.sp,
                    fontWeight:
                    FontWeight
                        .w700,
                    color:
                    primaryColor),
              ),
              Text(
                'أدخل البريد الإلكتروني الخاص بيك وهنبعتلك إيميل استعادة كلمة المرور',
                textDirection: TextDirection.rtl,
                style: Theme.of(
                    context)
                    .textTheme
                    .displayMedium
                    ?.copyWith(
                    fontSize: widget.isWeb ? 14 :
                    30.sp,
                    fontWeight:
                    FontWeight
                        .w500,
                    color: Colors.black
                        .withOpacity(
                        0.5)),
              ),
              Padding(
                padding: EdgeInsets
                    .only(
                    top: widget.isWeb ? 16 :
                    50.sp,
                  bottom: widget.isWeb ? 8 : 10.sp
                    ),
                child: MyTextField(
                  isWeb: widget.isWeb,
                    error: "",
                    descriptionTextField: false,

                    title: 'البريد الإلكتروني',
                  maxLength: 150,
                    isValidatable: true,
                  isExpanding: false,
                    controller:
                    ForgetPasswordModelSheet.forgotPasswordController,
                    type: 'email',
                    hintText:
                    'example@gmail.com'),
              ),
              Padding(
                padding: EdgeInsets
                    .symmetric(
                    vertical: widget.isWeb ? 16 :
                    20.sp),
                child: Container(
                  width: double
                      .infinity,
                  height: widget.isWeb ? 40 :
                  0.045.sh,
                  decoration:
                  BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor
                            .withOpacity(
                            0.25),
                        spreadRadius:
                        1,
                        blurRadius:
                        1,
                        offset: const Offset(
                            0,
                            2), // changes position of shadow
                      ),
                    ],
                    gradient:
                     LinearGradient(
                      begin: Alignment
                          .topCenter,
                      end: Alignment
                          .bottomCenter,
                      colors: [
                        primaryColor,
                        accentColor
                      ],
                    ),
                    borderRadius:
                    BorderRadius
                        .circular(
                        10),
                  ),
                  child:
                  ElevatedButton(
                    style: ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      Colors
                          .transparent,
                      shadowColor:
                      Colors
                          .transparent,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                            10),
                      ),
                    ),
                    onPressed:
                        () {
                          resetPassword(ForgetPasswordModelSheet.forgotPasswordController.text, onSuccess: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            Navigator.pop(context);
                            ForgetPasswordModelSheet.forgotPasswordController.clear();
                            showSnackBar(context: context, message: 'تم إرسال البريد الإلكتروني بنجاح، راجع حسابك',); }, onError: (e) {
                            setState(() {
                              // checkResponseStat(e, errorMessage: emailError);
                            });
                          });
                    },
                    child: Text(
                      'تأكيد',
                      style: Theme.of(
                          context)
                          .textTheme
                          .displayLarge!
                          .copyWith(
                          color:
                          Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: widget.isWeb ? 16 : 40.sp),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        isLoading? const Loading() : Container()
      ],
    );
  }
}
