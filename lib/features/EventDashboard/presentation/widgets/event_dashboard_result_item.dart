import 'package:flutter/material.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import 'event_dashboard_result_item_content_widget.dart';

class EventDashboardResultItem extends StatelessWidget {
  const EventDashboardResultItem({
    super.key,
    this.icon,
    this.status,
    required this.title,
    this.textContent,
    required this.isBadge,
    this.onTap,
    this.isScannedStatus,
  });

  final Widget? icon;
  final Widget? status;
  final String? textContent;
  final String title;
  final bool? isBadge;
  final bool? isScannedStatus;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return EventDashboardResultItemContentWidget(
        icon: icon,
        title: title,
        isBadge: isBadge,
        isScannedStatus: isScannedStatus,
        textContent: textContent,
      );
    }

    return ZoomTapAnimation(
      onTap: onTap,
      child: EventDashboardResultItemContentWidget(
        icon: icon,
        title: title,
        isBadge: isBadge,
        isScannedStatus: isScannedStatus,
        textContent: textContent,
      ),
    );
  }
}

