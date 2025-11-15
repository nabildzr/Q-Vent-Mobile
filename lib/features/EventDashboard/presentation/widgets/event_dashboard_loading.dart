import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../gen/loading/wave_loading.dart';

class EventDashboardLoading extends StatelessWidget {
  const EventDashboardLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          end: Alignment.bottomCenter,
          begin: Alignment.topCenter,
          colors: [
            AppColors.eventDashboard,
            Color.fromARGB(255, 180, 206, 255),
          ],
        ),
      ),
      child: WaveLoading()
    );
  }
}