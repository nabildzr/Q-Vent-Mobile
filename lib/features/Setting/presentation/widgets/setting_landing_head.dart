import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';

class SettingLandingHead extends StatefulWidget {
  final int tabIndex;

  const SettingLandingHead({super.key, required this.tabIndex});

  @override
  State<SettingLandingHead> createState() => _SettingLandingHeadState();
}

class _SettingLandingHeadState extends State<SettingLandingHead> {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthenticationProvider>();

    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20,
        bottom: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
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
                          decoration: BoxDecoration(color: AppColors.secondary),
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
                          decoration: BoxDecoration(color: AppColors.secondary),
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
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.userProfile?.name ?? '',

                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          height: 1,
                        ),
                      ),
                      Text(
                        authProvider.userProfile?.email ?? '',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
