import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import '../../../../core/theme/app_colors.dart';

class EventDashboardResultItemContentWidget extends StatelessWidget {
  const EventDashboardResultItemContentWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.isBadge,
    required this.isScannedStatus,
    required this.textContent,
  });

  final Widget? icon;
  final String title;
  final bool? isBadge;
  final bool? isScannedStatus;
  final String? textContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: AppColors.grey.withOpacity(0.8),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),

            child: icon,
          ),
          Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                ),
                isBadge == true
                    ? Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                      decoration: BoxDecoration(
                        color:
                            isScannedStatus == true
                                ? AppColors.successLight
                                : AppColors.failedLight,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        textContent ?? '',
                  overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color:
                              isScannedStatus == true
                                  ? AppColors.successDark
                                  : AppColors.failedDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                    : Text(
                      textContent ?? 'None',
                  overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
