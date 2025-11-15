import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/provider/network_status_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../Authentication/presentation/pages/login_page.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../../Landing/presentation/pages/landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void checkToken() async {
    final authProvider = context.read<AuthenticationProvider>();

    await authProvider.getUser();
    await authProvider.getAuthorization();

    final token = authProvider.authorization?.token;

    if (token == null || authProvider.isTokenExpired()) {
      navigateToLogin();
    } else {
      final isOnline = context.read<NetworkStatusProvider>().isOnline;

      if (isOnline) {
        try {
          await authProvider.refreshToken(authProvider.authorization!.token);
          //check token after refresh
          if (authProvider.refreshTokenStatus == AuthStatus.error ||
              authProvider.isTokenExpired()) {
            navigateToLogin();
            return;
          }
        } catch (e) {
          print('Error refreshing token: $e');
          navigateToLogin();
          return;
        }
      }

      navigateToLanding();
    }
  }

  void navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void navigateToLanding() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => LandingPage()));
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 5), () {
      checkToken();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Q-Vent',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(color: AppColors.primary),
            const SizedBox(height: 48),
            const Text(
              'Created by Nabildzr & Nazriel',
              style: TextStyle(fontSize: 14, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
