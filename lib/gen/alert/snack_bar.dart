import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

void showCustomSnackBar({
  required BuildContext? context,
   Widget? content,
  required String message,
  Color? color,
  double? left,
  double? right,
}) {
    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.up,
        // available to use any widget
        content: content ?? Text(message),
        backgroundColor: color ?? AppColors.primary,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 130,
          left: left ?? 10,
          right: right ?? 10,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}
