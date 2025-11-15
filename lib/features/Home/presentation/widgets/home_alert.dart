import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../core/controller/inner_tab_controller.dart';
import '../../../../core/scope/landing_tabs_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../provider/home_provider.dart';

Widget homeAlert({
  required BuildContext context,
  required HomeProvider homeProvider,
}) {
  return Column(
    children: [
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryLight,
          border: Border.all(
            color: const Color.fromARGB(255, 171, 201, 255),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reminder!",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "You’ve got ${homeProvider.homeSummary?.currentMonthCount ?? 0} events scheduled this month.\nMake sure you’re prepared!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  ZoomTapAnimation(
                    onTap: () {
                      eventInnerTabIndex.value = 0;
                      // then move to event tab (index: 1.,)
                      final controller =
                          LandingTabsScope.of(context)?.controller;
                      controller?.animateTo(1);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.primary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Iconify(
                          MaterialSymbols.arrow_forward_ios_rounded,
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      Gap(15),
    ],
  );
}