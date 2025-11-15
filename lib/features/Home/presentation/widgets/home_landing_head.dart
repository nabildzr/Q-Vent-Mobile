import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../User/presentation/pages/profile_data_page.dart';

class HomeLandingHead extends StatefulWidget {
  final int tabIndex;

  const HomeLandingHead({super.key, required this.tabIndex});

  @override
  State<HomeLandingHead> createState() => _HomeLandingHeadState();
}

class _HomeLandingHeadState extends State<HomeLandingHead> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfileDataPage()),
                );
              },
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: CachedNetworkImage(
                      imageUrl:
                          "https://ui-avatars.com/api/?name=${authProvider.userProfile?.name ?? ''}&background=7F9CF5&color=ffffff&size=128&rounded=true&bold=true",
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            height: 70,
                            width: 70,
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
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.broken_image,
                                color: AppColors.primary,
                                size: 35,
                              ),
                            ),
                          ),
                    ),
                  ),
                  Gap(15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Text(
                          "Welcome!",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          authProvider.userProfile?.name ?? '',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   children: [
          //     ZoomTapAnimation(
          //       onTap: () {
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (_) => NotificationPage()),
          //         );
          //       },
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(50),
          //         child: Container(
          //           padding: EdgeInsets.all(10),
          //           decoration: BoxDecoration(
          //             color: const Color.fromARGB(217, 217, 217, 1000),
          //           ),
          //           child: Iconify(Ic.baseline_notifications),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
