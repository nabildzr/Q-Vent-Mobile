import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../EventDashboard/presentation/pages/event_dashboard_page.dart';

class HomeEventHistoryItem extends StatelessWidget {
  final String title;
  final String category;
  final String endDate;
  final int id;
  final String? banner;

  const HomeEventHistoryItem({
    super.key,
    required this.title,
    required this.category,
    required this.endDate,
    required this.banner, required this.id,
  });

  @override
  Widget build(BuildContext context) {
    String _relativeTime(String input) {
      if (input.trim().isEmpty) return '-';

      // Normalize to simple ISO format
      final normalized =
          input.contains('T') ? input : input.replaceFirst(' ', 'T');
      final dt = DateTime.tryParse(normalized);
      if (dt == null) return '-';

      final now = DateTime.now();
      final isFuture = dt.isAfter(now);
      final diff = (isFuture ? dt.difference(now) : now.difference(dt));

      int value;
      String unit;
      if (diff.inSeconds < 60) {
        value = diff.inSeconds;
        unit = 's';
      } else if (diff.inMinutes < 60) {
        value = diff.inMinutes;
        unit = 'm';
      } else if (diff.inHours < 24) {
        value = diff.inHours;
        unit = 'h';
      } else if (diff.inDays < 365) {
        value = diff.inDays;
        unit = 'd';
      } else {
        value = (diff.inDays / 365).floor();
        unit = 'y';
      }

      return isFuture ? 'in $value$unit' : '$value$unit ago';
    }

    final endAgoText = _relativeTime(endDate);

    return ZoomTapAnimation(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EventDashboardPage(eventId: id)),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(color: AppColors.grey),
                      child:
                          (banner == null || banner!.trim().isEmpty)
                              ? const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: AppColors.third,
                                ),
                              )
                              : CachedNetworkImage(
                                imageUrl: "${Constant.domain}/storage/$banner",
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      height: 200,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary,
                                      ),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: AppColors.primary,
                                          strokeWidth: 10,
                                        ),
                                      ),
                                    ),
                                errorWidget: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.secondary,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.broken_image,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ),
                  Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            height: 1,
                          ),
                        ),
                        Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Gap(10),

            Text(endAgoText, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
