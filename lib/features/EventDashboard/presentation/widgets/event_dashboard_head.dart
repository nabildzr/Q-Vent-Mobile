import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../pages/event_dashboard_page.dart';
import '../provider/event_dashboard_provider.dart';
import 'event_dashboard_refresh_data.dart';

class EventDashboardHead extends StatelessWidget {
  const EventDashboardHead({
    super.key,
    required this.widget,
    required this.eventDashboardProvider,
    required this.authProvider,
  });

  final EventDashboardPage widget;
  final EventDashboardProvider eventDashboardProvider;
  final AuthenticationProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${eventDashboardProvider.event?.title}",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              Row(
                children: [
                  Iconify(Bi.clock_fill, color: AppColors.secondary, size: 20),
                  Gap(5),
                  Text(
                    "${eventDashboardProvider.event?.startDate}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Iconify(Bi.clock_history, color: AppColors.secondary, size: 20),
                  Gap(5),
                  Text(
                    "${eventDashboardProvider.event?.endDate}",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        Gap(10),

        EventDashboardRefreshData(
          widget: widget,
          authProvider: authProvider,
          eventDashboardProvider: eventDashboardProvider,
        ),
      ],
    );
  }
}
