import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/uil.dart';
import '../pages/event_dashboard_attendance_result_page.dart';

import '../../../../core/theme/app_colors.dart';
import '../provider/event_dashboard_provider.dart';
import 'event_dashboard_result_item.dart';

class EventDashboardScanAttendanceResult extends StatelessWidget {
  final EventDashboardProvider eventDashboardProvider;

  const EventDashboardScanAttendanceResult({
    super.key,
    required this.eventDashboardProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                EventDashboardResultItem(
                  title: 'Name',
                  isBadge: false,
                  icon: Iconify(Uil.user, color: AppColors.primary),
                  textContent:
                      eventDashboardProvider
                          .attendanceData
                          ?.attendeeEntity
                          .fullName ??
                      'Unnamed',
                ),
                Gap(15),
                EventDashboardResultItem(
                  title: 'Email',
                  isBadge: false,
                  icon: Iconify(Uil.phone, color: AppColors.primary),
                  textContent:
                      eventDashboardProvider
                          .attendanceData
                          ?.attendeeEntity
                          .email ??
                      '-',
                ),
                Gap(15),
                EventDashboardResultItem(
                  title: 'Details',
                  isBadge: false,
                  icon: Iconify(Ph.file_text, color: AppColors.primary),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDashboardResultPage(),
                      ),
                    );
                  },
                  textContent: "Click Me!",
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                EventDashboardResultItem(
                  title: 'Id Number',
                  isBadge: false,
                  icon: Iconify(
                    MaterialSymbols.numbers_rounded,
                    color: AppColors.primary,
                  ),

                  textContent:
                      "${eventDashboardProvider.attendanceData?.attendeeEntity.id ?? '-'}",
                ),
                Gap(15),
                EventDashboardResultItem(
                  title: 'Status',
                  isBadge: true,
                  isScannedStatus:
                      eventDashboardProvider.attendanceData != null &&
                      eventDashboardProvider
                          .attendanceData!
                          .attendanceEntity
                          .status
                          .isNotEmpty &&
                      eventDashboardProvider
                              .attendanceData!
                              .attendanceEntity
                              .status !=
                          'absent' &&
                      eventDashboardProvider
                              .attendanceData!
                              .attendanceEntity
                              .status !=
                          'invalid',
                  icon: Iconify(Ph.check_circle, color: AppColors.primary),

                  textContent:
                      eventDashboardProvider
                          .attendanceData!
                          .attendanceEntity
                          .status,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
