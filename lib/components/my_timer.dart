import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyStopWatch extends StatefulWidget {
  DateTime initialTime;
  Color color;

  MyStopWatch({super.key, required this.initialTime, required this.color});

  @override
  State<MyStopWatch> createState() => _MyStopWatchState();
}

class _MyStopWatchState extends State<MyStopWatch> {
  late final Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (_) {
      final now = DateTime.now();
      setState(() {
        _elapsed = now.difference(widget.initialTime);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      "( ${_elapsed.inHours != 0 ? '${_elapsed.inHours}:' : ''}${_elapsed.inMinutes.remainder(60)}:${(_elapsed.inSeconds.remainder(60))} )",
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
          color: widget.color,
          fontSize: kIsWeb ? 18.sp : 28.sp,
          fontWeight: FontWeight.w600,
          fontStyle: FontStyle.italic),
    );
  }
}
