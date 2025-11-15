import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../pages/event_dashboard_page.dart';
import '../provider/event_dashboard_provider.dart';

class EventDashboardRefreshData extends StatefulWidget {
  const EventDashboardRefreshData({
    super.key,
    required this.widget,
    required this.eventDashboardProvider,
    required this.authProvider,
  });

  final EventDashboardPage widget;
  final EventDashboardProvider eventDashboardProvider;
  final AuthenticationProvider authProvider;

  @override
  State<EventDashboardRefreshData> createState() =>
      _EventDashboardRefreshDataState();
}

class _EventDashboardRefreshDataState extends State<EventDashboardRefreshData> {
  bool _isRefreshing = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () async {
        if (!mounted) return;
        setState(() {
          _isRefreshing = true;
        });

        await Future.delayed(Duration(seconds: 1));

        await widget.eventDashboardProvider.getEventById(
          widget.authProvider.authorization?.token,
          widget.widget.eventId,
        );

        await Future.delayed(Duration(seconds: 1));

        if (!mounted) return;

        setState(() {
          _isRefreshing = false;
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9999),
        child: Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(color: AppColors.secondary),
          child: SizedBox(
            width: 35,
            height: 35,
            child:
                _isRefreshing
                    ? CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 4,
                    )
                    : Iconify(Ic.twotone_refresh, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
