import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

void showCustomToast({
  required BuildContext context,
  required String message,
  String? title,
  ToastificationType type = ToastificationType.info,
  Color? primaryColor,
  Color? backgroundColor,
  Color? foregroundColor,
  Duration? autoCloseDuration,
  Alignment alignment = Alignment.topCenter,
  bool showIcon = true,
  IconData? iconData,
}) {
  toastification.dismissAll();

  toastification.show(
    context: context,
    type: type,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: autoCloseDuration ?? const Duration(seconds: 5),
    callbacks: ToastificationCallbacks(
      onTap: (toastItem) => toastification.dismissAll(),
    ),

    title: title != null ? Text(title) : null,
    description: Text(message, style: TextStyle(fontWeight: FontWeight.w600)),
    alignment: alignment ,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    icon: showIcon ? Icon(iconData ?? _getDefaultIcon(type)) : null,
    showIcon: showIcon,
    primaryColor: primaryColor ?? _getDefaultColor(type),
    backgroundColor: backgroundColor ?? Colors.white,
    foregroundColor: foregroundColor ?? Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
    showProgressBar: true,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,
  );
}

IconData _getDefaultIcon(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Icons.check;
    case ToastificationType.error:
      return Icons.error;
    case ToastificationType.warning:
      return Icons.warning;
    case ToastificationType.info:
    default:
      return Icons.info;
  }
}

Color _getDefaultColor(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Colors.green;
    case ToastificationType.error:
      return Colors.red;
    case ToastificationType.warning:
      return Colors.orange;
    case ToastificationType.info:
    default:
      return Colors.blue;
  }
}
