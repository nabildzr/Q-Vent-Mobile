import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

import '../../../../core/constant/constant.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../EventDashboard/presentation/pages/event_dashboard_page.dart';
import '../../domain/entities/search_event_entity.dart';

class SearchEventCard extends StatelessWidget {
  final SearchEventEntity? event;

  const SearchEventCard({super.key, this.event});

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDashboardPage(eventId: event?.id ?? 0 ),
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
                    (event!.banner == null || event!.banner!.trim().isEmpty)
                        ? const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white70,
                          ),
                        )
                        : CachedNetworkImage(
                          imageUrl: "${Constant.domain}/storage/${event!.banner}",
                          width: double.infinity,
                          height: 200,
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
                          errorWidget:
                              (context, url, error) => Container(
                                height: 200,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary,
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
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSSMUi9wHqia_68xlAU7vP3E3sxn5K0KS-nUvBZk5jSJ54p8FPnw20uYV5yxNgF59DZoqc&usqp=CAU',
                            fit: BoxFit.cover,
                            width: 30,
                            height: 30,
                          ),
                        ),
                        Gap(10),
                        Text(
                          event!.createdBy ?? 'Unknown Creator',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
      
                    Gap(5),
                    Text(
                      event!.title ?? 'Untitled',
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "${event!.startDate} - ${event!.endDate}",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.grey,
                      ),
                    ),
                    Text(
                      event!.location ?? 'Unlocated',
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
