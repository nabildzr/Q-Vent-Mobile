import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../core/theme/app_colors.dart';
import '../provider/event_dashboard_provider.dart';

class EventRegistrationPercentage extends StatelessWidget {
  final EventDashboardProvider eventDashboardProvider;

  const EventRegistrationPercentage({
    super.key,
    required this.eventDashboardProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularPercentIndicator(
        radius: 120.0,
        lineWidth: 25.0,
        animation: true,
        percent: ((eventDashboardProvider.event?.attendancePercentage ?? 0) / 100).clamp(0.0, 1.0),
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${eventDashboardProvider.event?.attendancePercentage ?? ''}%",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 70.0,
                height: 0,
                fontStyle: FontStyle.italic,
                color: AppColors.secondary,
              ),
            ),
            const Text(
              "All Registrations",
              style: TextStyle(
                height: 0,
                fontWeight: FontWeight.w600,
                color: AppColors.secondary,
                fontSize: 16.0,
              ),
            ),
          ],
        ),

        backgroundColor: AppColors.primary,
        circularStrokeCap: CircularStrokeCap.round,
        progressBorderColor: AppColors.primary,
        progressColor: AppColors.darkPrimary,
      ),
    );
  }
}
