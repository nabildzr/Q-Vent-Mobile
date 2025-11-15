import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../core/theme/app_colors.dart';

class EventDashboardItem extends StatelessWidget {
  const EventDashboardItem({
    super.key,
    required this.title,
    required this.count,
    this.onTap,
  });

  final String title;
  final String count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Text(
                      count,
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   right: -6,
                    //   child: Container(
                    //     width: 5,
                    //     height: 5,
                    //     decoration: BoxDecoration(
                    //       color: AppColors.red,
                    //       borderRadius: BorderRadius.circular(4),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Gap(5),
                Iconify(
                  Ic.outline_arrow_forward_ios,
                  color: AppColors.secondary,
                  size: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}