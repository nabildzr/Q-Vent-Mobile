import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';

import '../../../../core/theme/app_colors.dart';
import '../provider/home_provider.dart';

Widget eventOverview({required HomeProvider homeProvider}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Event Overview",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondary,
                ),
              ),
              GestureDetector(
                onTap: () {
                  print('clicked');
                },
                child: Iconify(
                  Bi.three_dots_vertical,
                  color: AppColors.secondary,
                ),
              ),
            ],
          ),

          SizedBox(height: 3),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upcoming event",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondary,
                    height: 1,
                  ),
                  textAlign: TextAlign.start,
                ),

                if (homeProvider.homeSummaryStatus != HomeStatus.error)
                  Text(
                    homeProvider.homeSummary?.upcomingEvent ??
                        'No Upcoming Event',
                    style: TextStyle(
                      fontSize: 19,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  )
                else
                  Text(
                    homeProvider.cleanErrorMessage,
                    style: TextStyle(
                      fontSize: 19,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),

                SizedBox(height: 3),
                
                Text(
                  "Ongoing event",
                  style: TextStyle(
                  fontSize: 18,
                  color: AppColors.secondary,
                  height: 1,
                  ),
                  textAlign: TextAlign.start,
                ),

                if (homeProvider.homeSummaryStatus != HomeStatus.error)
                  Text(
                  homeProvider.homeSummary?.ongoingEvent ??
                    'No Ongoing Event',
                  style: TextStyle(
                    fontSize: 19,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  )
                else
                  Text(
                  homeProvider.cleanErrorMessage,
                  style: TextStyle(
                    fontSize: 19,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  ),

                SizedBox(height: 3),
                Text(
                  "Total Past Event Participated",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.secondary,
                    height: 1,
                  ),
                  textAlign: TextAlign.start,
                ),

                if (homeProvider.homeSummaryStatus != HomeStatus.error)
                  Text(
                    homeProvider.homeSummary?.pastCount.toString() ?? '0',
                    style: TextStyle(
                      fontSize: 19,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  )
                else
                  Text(
                    'Loading...',
                    style: TextStyle(
                      fontSize: 19,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
