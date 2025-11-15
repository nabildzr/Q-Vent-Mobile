import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:qr_event_management/features/Home/presentation/provider/home_provider.dart'
    show HomeStatus, HomeProvider;
import 'package:qr_event_management/features/Home/presentation/widgets/home_event_history_item.dart';
import 'package:qr_event_management/gen/loading/wave_loading.dart';

import '../../../../core/controller/inner_tab_controller.dart';
import '../../../../core/scope/landing_tabs_scope.dart';
import '../../../../core/theme/app_colors.dart';

Widget eventHistory({
  required BuildContext context,
  required HomeProvider homeProvider,
}) {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Your Event History",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: AppColors.grey,
            ),
          ),
          GestureDetector(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
                padding: EdgeInsets.symmetric(horizontal: 15),
              ),
              onPressed: () {
                eventInnerTabIndex.value = 2;
                // then moved to Events tab (index 1)
                final controller = LandingTabsScope.of(context)?.controller;
                controller?.animateTo(1);
              },
              child: Row(
                children: [
                  Iconify(
                    Ic.outline_remove_red_eye,
                    color: AppColors.primary,
                    size: 18,
                  ),
                  SizedBox(width: 3),
                  Text(
                    'view all',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

    homeProvider.homeEventHistoryStatus == HomeStatus.loading
          ? SizedBox(
            height: 525,
            
            child: WaveLoading())
          : homeProvider.homeEventHistoryStatus == HomeStatus.error
          ? SizedBox(
            height: 525,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Iconify(
                        Bi.calendar2_date_fill,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Gap(25),
                  Text(
                    "Something went wrong, please\ntry again later",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Gap(100),
                ],
              ),
            ),
          )
          : (homeProvider.homeEventHistory?.isEmpty ?? true)
          ? SizedBox(
            height: 525,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9999),
                    child: Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Iconify(
                        Bi.calendar2_date_fill,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Gap(25),
                  Text(
                    "No events found",

                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Gap(100),
                ],
              ),
            ),
          )
          : ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: homeProvider.homeEventHistory!.length,
            separatorBuilder: (_, __) => const Gap(0),
            itemBuilder: (context, index) {
              final event = homeProvider.homeEventHistory![index];
              return HomeEventHistoryItem(
                title: event?.title ?? 'Untitled',
                category:
                    (event?.category?.isNotEmpty ?? false)
                        ? event!.category!
                        : "doesn't have a category",
                endDate: event?.endDate ?? '0 ago',
                banner: event.banner,
                id: event.id,
              );
            },
          ),

      Gap(100),
    ],
  );
}
