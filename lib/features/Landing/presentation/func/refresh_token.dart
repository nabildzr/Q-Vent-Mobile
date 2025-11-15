import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../pages/landing_page.dart';

void refreshToken(context, {required String token}) async {
  final authProvider = Provider.of<AuthenticationProvider>(
    context,
    listen: false,
  );

  await authProvider.refreshToken(token);

  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (_) => LandingPage()),
    (route) => false,
  );
}