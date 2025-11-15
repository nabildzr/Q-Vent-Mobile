import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ep.dart';
import 'package:iconify_flutter/icons/ion.dart';
import '../provider/event_dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';

class CheckInAndNotCheckIn extends StatelessWidget {
  final EventDashboardProvider eventDashboardProvider;

  const CheckInAndNotCheckIn({super.key, required this.eventDashboardProvider});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // Iconify(Mdi.circle_outline, color: AppColors.secondary),
            Iconify(Ep.success_filled, color: AppColors.secondary, size: 25,),
            Gap(10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${eventDashboardProvider.event?.presentOrLateCount ?? ''}",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    height: 0,
                  ),
                ),
                Text(
                  'Check In',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                    height: 0,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            // Iconify(Mdi.circle_slice_8, color: AppColors.secondary),
            Iconify(Ion.ios_close_circle, color: AppColors.secondary, size: 25,),

            Gap(10),

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${eventDashboardProvider.event?.absentCount ?? ''}",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 30,
                    fontWeight: FontWeight.w500,
                    height: 0,
                  ),
                ),

                Text(
                  'Not Check In',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w500,
                    height: 0,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
