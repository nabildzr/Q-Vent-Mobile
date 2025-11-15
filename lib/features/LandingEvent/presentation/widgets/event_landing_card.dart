import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../EventDashboard/presentation/pages/event_dashboard_page.dart';

class EventLandingCard extends StatelessWidget {
  final int? id;
  final String? title;
  final String? location;
  final String? createdBy;
  final String? startDate;
  final String? endDate;
  final String? banner;

  const EventLandingCard({
    super.key,
    this.title,
    this.location,
    this.createdBy,
    this.startDate,
    this.endDate,
    this.banner,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) =>
                    EventDashboardPage(eventId: id ?? 0),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              // Fade in for push, no animation for pop
                return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20.0,
                offset: Offset(0, 8),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child:
                    (banner == null || banner!.trim().isEmpty)
                        ? const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white70,
                          ),
                        )
                        : CachedNetworkImage(
                          imageUrl: "${Constant.domain}/storage/$banner",
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          placeholder:
                              (context, url) => Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primary,
                                    strokeWidth: 10,
                                  ),
                                ),
                              ),
                          errorWidget:
                              (context, url, error) => Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.primaryLight,
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    color: AppColors.primary,
                                    size: 100,
                                  ),
                                ),
                              ),
                        ),
              ),

              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  top: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSMUi9wHqia_68xlAU7vP3E3sxn5K0KS-nUvBZk5jSJ54p8FPnw20uYV5yxNgF59DZoqc&usqp=CAU",
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                            placeholder:
                                (context, url) => Container(
                                  height: 30,
                                  width: 30,
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
                            errorWidget:
                                (context, url, error) => Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                    color: AppColors.secondary,
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      color: AppColors.primary,
                                      size: 10,
                                    ),
                                  ),
                                ),
                          ),
                        ),
                        Gap(10),
                        Text(
                          createdBy ?? 'Unknown Creator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),

                    Gap(5),
                    Text(
                      title ?? 'Untitled',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "$startDate - $endDate",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      location ?? 'Unlocated',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
