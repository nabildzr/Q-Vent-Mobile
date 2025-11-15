import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';

import '../../core/theme/app_colors.dart';

Positioned scrollToUpButton({required ScrollController scrollController}) {
  return Positioned(
    right: 10,
    bottom: 50,
    child: FloatingActionButton(
      backgroundColor: AppColors.primary,
      elevation: 0,
      splashColor: Colors.amberAccent,
      mini: true,
      onPressed: () {
        scrollController.animateTo(
          0,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      },
      child: Iconify(
        MaterialSymbols.keyboard_double_arrow_up,
        color: AppColors.secondary,
      ),
    ),
  );
}