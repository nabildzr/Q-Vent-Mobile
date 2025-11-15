import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../Home/presentation/provider/home_provider.dart';
import '../../../SplashScreen/presentation/pages/splashscreen.dart';

void logout(context) async {
  final authProvider = Provider.of<AuthenticationProvider>(
    context,
    listen: false,
  );

  final homeProvider = Provider.of<HomeProvider>(context, listen: false);

  final shouldLogout = await showDialog<bool>(
    context: context,
    builder:
        (context) => AlertDialog(
          backgroundColor: AppColors.backgroundPage,

          title: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text('Are you sure want to logout?'),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(AppColors.grey2),
                backgroundColor: WidgetStateProperty.all(AppColors.grey1),
              ),

              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel'),
            ),
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(AppColors.red),
                backgroundColor: WidgetStateProperty.all(AppColors.redLight),
              ),

              onPressed: () => Navigator.pop(context, true),
              child: Text("Logout"),
            ),
          ],
        ),
  );

  if (shouldLogout == true) {
    await authProvider.logout();

    authProvider.resetState();
    homeProvider.resetState();
    homeProvider.stopAutoRefresh();
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => SplashScreen()),
      (route) => false,
    );
  }
}

void logoutEasy(context) async {
  final authProvider = Provider.of<AuthenticationProvider>(
    context,
    listen: false,
  );

    print('from authorization local: ${authProvider.authorization!.token}');


  final homeProvider = Provider.of<HomeProvider>(context, listen: false);

  await authProvider.logout();

  authProvider.resetState();
  homeProvider.resetState();
  homeProvider.stopAutoRefresh();
}
