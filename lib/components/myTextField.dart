import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../styles.dart';

class MyTextField extends StatefulWidget {
  MyTextField(
      {Key? key,
      required this.controller,
      required this.type,
      required this.hintText,
      required this.isExpanding,
      required this.title,
      required this.isValidatable,
      required this.maxLength,
      required this.error,
      this.onChanged,
      this.focusScopeNode,
      this.onSubmit,
      required this.descriptionTextField,
      this.isWeb = false})
      : super(key: key);

  final TextEditingController controller;
  final String type;
  final String hintText;
  bool isExpanding = false;
  bool isValidatable;
  Function(String text)? onChanged;
  Function()? onSubmit;
  FocusNode? focusScopeNode;
  String title;
  int maxLength;
  String error;
  bool descriptionTextField;
  final bool isWeb;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isExpanding = false;
  bool isPasswordVisible = false;
  bool isEmpty = false;
  bool tap = false;

  @override
  Widget build(BuildContext context) {
    // Responsive font sizes for Web
    final double titleFontSize = kIsWeb ? 16 : 36.sp;
    final double textFontSize = kIsWeb ? 18 : 50.sp;
    final double hintFontSize = kIsWeb ? 18 : 40.spMin;
    final double errorFontSize = kIsWeb ? 14 : 32.sp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        widget.title.isNotEmpty
            ? Align(
                alignment: Alignment.topRight,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: smallFontColor,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w300),
                ))
            : Container(),
        SizedBox(
          height: kIsWeb ? 8 : 12.sp,
        ),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(kIsWeb ? 12 : 30.sp),
          child: TextField(
            focusNode: widget.focusScopeNode,
            onTap: () {
              setState(() {
                tap = true;
              });
            },
            onChanged: (text) {
              if (widget.onChanged != null) {
                widget.onChanged!(text);
              }
              setState(() {
                isEmpty = text.isEmpty;
              });
            },
            onTapOutside: (pointer) {
              setState(() {
                isEmpty = widget.controller.text.isEmpty && tap;
              });
            },
            onSubmitted: (text) {
              setState(() {
                if (widget.onSubmit != null) {
                  widget.onSubmit!();
                }
                isEmpty = widget.controller.text.isEmpty && tap;
              });
              FocusScope.of(context).unfocus();
            },
            onEditingComplete: () {
              setState(() {
                isEmpty = widget.controller.text.isEmpty && tap;
              });
            },
            maxLines: widget.descriptionTextField
                ? 4
                : isExpanding
                    ? 5
                    : 1,
            minLines: 1,
            inputFormatters: widget.type == 'number'
                ? [FilteringTextInputFormatter.digitsOnly]
                : [],
            maxLength: widget.maxLength,
            cursorRadius: Radius.circular(kIsWeb ? 16 : 50.sp),
            keyboardType: widget.type == 'number'
                ? TextInputType.number
                : widget.type == 'password'
                    ? TextInputType.visiblePassword
                    : widget.type == 'email'
                        ? TextInputType.emailAddress
                        : TextInputType.text,
            controller: widget.controller,
            obscureText: widget.type == 'password' ? !isPasswordVisible : false,
            cursorColor: primaryColor,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .displayMedium!
                .copyWith(fontSize: textFontSize, color: primaryColor),
            decoration: InputDecoration(
              counterText: "",
              fillColor: warmColor,
              prefixIcon: widget.type == 'password'
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kIsWeb ? 8 : 15.sp),
                      child: IconButton(
                        icon: Icon(
                          isPasswordVisible == true
                              ? Icons.remove_red_eye_outlined
                              : Icons.remove_red_eye,
                          color: primaryColor,
                          size: kIsWeb ? 20 : 50.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    )
                  : widget.type == 'email'
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: kIsWeb ? 8 : 15.sp),
                          child: Icon(
                            Icons.alternate_email,
                            size: kIsWeb ? 20 : 50.sp,
                            color: widget.controller.text.isEmpty
                                ? primaryColor.withOpacity(0.5)
                                : primaryColor,
                          ),
                        )
                      : null,
              filled: true,
              hintText: widget.hintText,
              hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: hintFontSize, color: primaryColor.withOpacity(0.3)),
              contentPadding: EdgeInsets.symmetric(
                  vertical: kIsWeb ? 12 : 10.0.sp,
                  horizontal: kIsWeb ? 16 : 20.0.sp),
              enabledBorder: OutlineInputBorder(
                borderSide:
                    BorderSide(width: 1, color: primaryColor.withOpacity(0.0)),
                borderRadius: BorderRadius.circular(kIsWeb ? 12 : 30.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: primaryColor),
                borderRadius: BorderRadius.circular(kIsWeb ? 12 : 30.r),
              ),
            ),
          ),
        ),
        widget.isValidatable
            ? isEmpty
                ? Text(
                    widget.error != ""
                        ? widget.error
                        : 'من فضلك أدخل ${widget.title != "" ? widget.title : widget.hintText}',
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: errorFontSize, color: Colors.red),
                  )
                : widget.error.isNotEmpty
                    ? Text(
                        widget.error,
                        textDirection: TextDirection.rtl,
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium!
                            .copyWith(
                                fontSize: errorFontSize, color: Colors.red),
                      )
                    : Container()
            : Container(),
      ],
    )
        .animate(delay: const Duration(milliseconds: 100))
        .fade(curve: Curves.easeInOutCubic)
        .scale(curve: Curves.easeInOutCubic);
  }
}
