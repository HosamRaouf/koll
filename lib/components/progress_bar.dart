import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kol/components/myElevatedButton.dart';
import 'package:kol/components/show_snack_bar.dart';
import 'package:kol/screens/no_internet_screen.dart';

import '../routes/app_routes.dart';
import '../styles.dart';

class ProgressBar extends StatefulWidget {
  ProgressBar({super.key, required this.task, required this.onUploaded});

  UploadTask task;
  Function(String) onUploaded;

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  int totalBytes = 1;
  int bytesTransferred = 1;
  double value = 0.0;

  @override
  void initState() {
    upload();
    super.initState();
  }

  String formatBytes(int bytes) {
    const int kbInBytes = 1024;
    const int mbInBytes = 1024 * 1024;

    if (bytes < kbInBytes) {
      return '$bytes B';
    } else if (bytes < mbInBytes) {
      double kbValue = bytes / kbInBytes;
      return '${kbValue.toStringAsFixed(2)}KB';
    } else {
      double mbValue = bytes / mbInBytes;
      return '${mbValue.toStringAsFixed(2)}MB';
    }
  }

  upload() async {
    widget.task.snapshotEvents.listen((event) {
      event.state.name == 'running'
          ? setState(() {
              value = (event.bytesTransferred / event.totalBytes) * 100;
              bytesTransferred = event.bytesTransferred;
              totalBytes = event.totalBytes;
            })
          : {};
    });
    try {
      await widget.task.then((p0) =>
          Navigator.pop(NamedNavigatorImpl.navigatorState.currentContext!));
      await widget.task.snapshot.ref.getDownloadURL().then((value) {
        widget.onUploaded(value);
      }).onError((error, stackTrace) {
        print('errorOrCancelled');
      });
    } catch (e) {
      print('Error uploading image: $e');
      Navigator.of(NamedNavigatorImpl.navigatorState.currentContext!).pop();
      showSnackBar(
          context: NamedNavigatorImpl.navigatorState.currentContext!,
          message: 'خطأ في الشبكة، لم يتم رفع الصورة');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternetCheck(
      child: PopScope(
        canPop: false,
        child: Container(
          color: Colors.black.withOpacity(0.3),
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Container(
              width: 0.9.sw,
              height: 0.45.sw,
              decoration: cardDecoration,
              child: Padding(
                padding: EdgeInsets.all(42.sp),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'جاري رفع الصورة',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                          fontWeight: FontWeight.w700, fontSize: 72.sp),
                    ),
                    SizedBox(
                      height: 42.sp,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: 0.9.sw,
                          height: 0.04.sw,
                          child: LinearProgressIndicator(
                            value: value / 100,
                            minHeight: 0.5.sp,
                            backgroundColor: warmColor,
                            borderRadius: BorderRadius.circular(100.r),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${formatBytes(bytesTransferred)}/${formatBytes(totalBytes)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 36.sp, color: smallFontColor),
                            ),
                            Text(
                              '${value.toInt()}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium!
                                  .copyWith(
                                      fontSize: 42.sp,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 24.sp,
                        ),
                        MyElevatedButton(
                          onPressed: () {
                            widget.task.cancel();
                            Navigator.pop(context);
                            showSnackBar(
                                context: context,
                                message: 'تم إلغاء رفع الصورة');
                          },
                          text: 'إلغاء',
                          width: double.infinity,
                          enabled: true,
                          fontSize: 40.sp,
                          color: Colors.transparent,
                          textColor: Colors.white,
                          gradient: true,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
