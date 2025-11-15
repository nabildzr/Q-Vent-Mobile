import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../core/theme/app_colors.dart';

class SettingGroupHead extends StatelessWidget {
  final List<Widget> children;
  final String title;

  const SettingGroupHead({
    super.key,
    required this.children,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey,
              ),
            ),
          ],
        ),
        Gap(5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(children: children),
        ),
        Gap(10),
      ],
    );
  }
}

