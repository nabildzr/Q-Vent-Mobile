import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class GeneralBackButton extends StatelessWidget {
  final Function()? onTap;
  final Color? iconColor;

  const GeneralBackButton({
    super.key,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Iconify(
        Ic.outline_arrow_back_ios_new,
        size: 25,
        color: iconColor ?? Colors.black,
      ),
      onPressed: onTap,
    );
  }
}
