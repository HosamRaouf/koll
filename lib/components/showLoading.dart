import 'package:flutter/material.dart';

import 'loading.dart';

showLoading(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => const Loading(),
      barrierDismissible: false);
}
