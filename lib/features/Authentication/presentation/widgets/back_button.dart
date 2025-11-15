import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';

class AuthenticationCustomBackButton extends StatelessWidget {
  final Function()? onTap;

  const AuthenticationCustomBackButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Iconify(
        Ic.outline_arrow_back_ios_new,
        size: 25,
        color: Colors.black,
      ),
      onPressed: onTap,
    );
  }
}
