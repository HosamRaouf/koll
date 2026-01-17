import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/loading.dart';
import 'package:kol/components/myTextField.dart';
import 'package:kol/components/primary_bottom_sheet.dart';
import 'package:kol/components/showLoading.dart';
import 'package:kol/core/firebase_auth/loginusingemailandpassword.dart';
import 'package:kol/core/firestore_database/fetch/fetchAll.dart';
import 'package:kol/core/shared_preferences/saveBool.dart';
import 'package:kol/navigation_animations.dart';
import 'package:kol/screens/home_screen/home_screen.dart';
import 'package:rive/rive.dart' as ri;

import '../../core/shared_preferences/savePreference.dart';
import '../../styles.dart';
import '../no_internet_screen.dart';
import 'forget_password_modelsheet_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = true;
  ValueNotifier<bool> isKitchen =
      ValueNotifier(false); // New switch state for web

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  bool isLoading = false;
  String emailError = "";
  String passwordError = "";
  String signInError = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: backGroundColor,
        body: InternetCheck(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    children: [
                      Expanded(
                        child: _buildBackground(context),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 600),
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: SingleChildScrollView(
                              child: _buildFormContent(context, isWeb: true),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return Stack(
                  children: [
                    _buildBackground(context),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: backGroundColor,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(50.r))),
                        child: Padding(
                          padding: EdgeInsets.all(
                            0.025.sh,
                          ),
                          child: SingleChildScrollView(
                            child: _buildFormContent(context, isWeb: false),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: const DecorationImage(
              fit: BoxFit.cover, image: AssetImage("assets/images/icons.png")),
          gradient: LinearGradient(
            colors: [primaryColor, accentColor],
          )),
      child: const Center(
        child: ri.RiveAnimation.asset(
          'assets/riv/logo.riv',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildFormContent(BuildContext context, {bool isWeb = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, accentColor.withOpacity(0.9)],
              ).createShader(bounds),
              child: Text(
                'تسجيل الدخول',
                style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    fontSize: isWeb ? 32 : 90.sp, color: Colors.white),
              ),
            ),
            Text(
              'أهلاً بكم في تطبيق كُل التطبيق الرسمي لمطاعم دكرنس',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: isWeb ? 14 : 40.sp,
                  color: fontColor.withOpacity(0.5)),
            ),
          ],
        ),
        SizedBox(
          height: isWeb ? 24 : 50.h,
        ),
        if (isWeb) ...[
          Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration:
                  cardDecoration.copyWith(color: Colors.white.withOpacity(0.5)),
              child: ValueListenableBuilder(
                  valueListenable: isKitchen,
                  builder: (context, child, value) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'كاشير',
                          style: TextStyling.smallFont.copyWith(
                            color:
                                !isKitchen.value ? primaryColor : Colors.grey,
                            fontWeight: !isKitchen.value
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Switch(
                          value: isKitchen.value,
                          activeColor: primaryColor,
                          activeTrackColor: primaryColor.withOpacity(0.5),
                          inactiveThumbColor: primaryColor,
                          inactiveTrackColor: primaryColor.withOpacity(0.5),
                          onChanged: (value) {
                            isKitchen.value = value;
                          },
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'مطبخ',
                          style: TextStyling.smallFont.copyWith(
                            color: isKitchen.value ? primaryColor : Colors.grey,
                            fontWeight: isKitchen.value
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          ),
          const SizedBox(height: 24),
        ],
        MyTextField(
          isWeb: isWeb,
          error: emailError,
          descriptionTextField: false,
          title: 'البريد الإلكتروني',
          maxLength: 150,
          isValidatable: true,
          isExpanding: false,
          controller: emailController,
          hintText: 'example@gmail.com',
          type: 'email',
        ),
        SizedBox(
          height: isWeb ? 16 : 0.015.sh,
        ),
        MyTextField(
          isWeb: isWeb,
          error: passwordError,
          descriptionTextField: false,
          title: 'كلمة المرور',
          maxLength: 150,
          isValidatable: true,
          isExpanding: false,
          controller: passwordController,
          hintText: '******',
          type: 'password',
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: isWeb ? 16 : 24.sp),
              child: TextButton(
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(
                        primaryColor.withOpacity(0.2)),
                  ),
                  onPressed: () {
                    setState(() {
                      emailController.value.text.isNotEmpty
                          ? ForgetPasswordModelSheet.forgotPasswordController
                              .value = emailController.value
                          : ForgetPasswordModelSheet
                              .forgotPasswordController.text = '';
                    });

                    if (isWeb) {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: const Padding(
                              padding: EdgeInsets.all(24.0),
                              child: SingleChildScrollView(
                                child: ForgetPasswordModelSheet(isWeb: true),
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      primaryBottomSheet(
                          child: const ForgetPasswordModelSheet(),
                          context: context);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(6.sp),
                    child: Text(
                      'نسيت كلمة المرور؟',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                          fontSize: isWeb ? 14 : 40.sp,
                          fontWeight: FontWeight.w700,
                          color: primaryColor),
                    ),
                  )),
            ),
          ],
        ),
        signInError != ""
            ? Padding(
                padding: EdgeInsets.only(bottom: isWeb ? 16 : 24.sp),
                child: Text(
                  signInError,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: isWeb ? 14 : 36.sp, color: Colors.red),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
        Container(
          width: double.infinity,
          height: isWeb ? 48 : 0.05.sh,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 1,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryColor, accentColor],
            ),
            borderRadius: BorderRadius.circular(isWeb ? 12 : 20.r),
          ),
          child: ElevatedButton(
            onPressed: () async {
              FocusScope.of(context).unfocus();

              setState(() {
                signInError = "";
              });

              if (emailController.text.isEmpty &&
                  passwordController.text.isEmpty) {
                setState(() {
                  emailError = "من فضلك أدخل البريد الإلكتروني";
                  passwordError = "من فضلك أدخل كلمة السر";
                });
              } else if (emailController.text.isEmpty) {
                setState(() {
                  emailError = "من فضلك أدخل البريد الإلكتروني";
                  passwordError = "";
                });
              } else if (passwordController.text.isEmpty) {
                setState(() {
                  passwordError = "من فضلك أدخل كلمة السر";
                  emailError = "";
                });
              } else {
                setState(() {
                  emailError = "";
                  passwordError = "";
                  signInError = "";
                  isLoading = true;
                });
                showDialog(
                    context: context,
                    builder: (context) => kIsWeb
                        ? PopScope(
                            canPop: false,
                            child: Container(
                              color: Colors.white.withOpacity(0.1),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : const Loading(),
                    barrierDismissible: false);
                await FirebaseFirestore.instance
                    .collection("restaurants")
                    .get()
                    .then((value) async {
                  value.docs.any(
                          (element) => element['email'] == emailController.text)
                      ? {
                          await signInWithEmailPassword(
                              emailController.text, passwordController.text,
                              onError: (e) {
                                print(e.code);
                                passwordController.clear();
                                if (e.code == 'user-not-found') {
                                  setState(() {
                                    emailError = 'هذا المستخدم غير موجود';
                                  });
                                } else if (e.code == 'wrong-password') {
                                  setState(() {
                                    passwordError = 'كلمة المرور غير صحيحة';
                                  });
                                } else if (e.code == 'network-request-failed') {
                                  setState(() {
                                    signInError =
                                        'خطأ في الشبكة، حاول مرة أخرى';
                                  });
                                } else if (e.code == 'invalid-email') {
                                  setState(() {
                                    emailError =
                                        'من فضلك أدخل البريد الإلكتروني بشكل صحيح';
                                  });
                                } else if (e.code == 'too-many-requests') {
                                  setState(() {
                                    signInError =
                                        'لقد تخطيت الحد الأقصى من المحاولات، حاول في وقت لاحق او استعيد كلمة المرور';
                                  });
                                } else if (e.code == 'invalid-credential') {
                                  setState(() {
                                    passwordError =
                                        "من فضلك تأكد من كلمة المرور";
                                  });
                                } else {
                                  print("log in success");
                                }
                              },
                              onSuccess: () async {
                                savePreference(
                                    key: 'email', value: emailController.text);
                                savePreference(
                                    key: 'password',
                                    value: passwordController.text);
                                saveBooleanValue(true, key: 'rememberMe');
                                saveBooleanValue(isKitchen.value,
                                    key: 'isKitchen');
                                showLoading(context);
                                await fetchAllData().then((value) =>
                                    Navigator.of(context).pushAndRemoveUntil(
                                      SizeRTLNavigationTransition(HomeScreen(
                                          isKitchen: isKitchen.value)),
                                      (route) => false,
                                    ));
                              },
                              onLoading: () {},
                              onLoadingComplete: () {
                                Navigator.pop(context);
                              })
                        }
                      : {
                          Navigator.pop(context),
                          setState(() {
                            emailError = "المستخدم غير موجود";
                          })
                        };
                });
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(isWeb ? 12 : 10.r),
              ),
            ),
            child: Text(
              'تسجيل الدخول',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: isWeb ? 16 : 40.sp),
            ),
          ),
        ),
      ],
    );
  }
}
