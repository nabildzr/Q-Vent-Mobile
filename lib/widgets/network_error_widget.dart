import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../core/theme/app_colors.dart';

class NetworkErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const NetworkErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 64, color: AppColors.grey2),
            const Gap(16),
            Text(
              'Connection Error',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.grey,
              ),
            ),
            const Gap(8),
            Text(
              _getReadableErrorMessage(message),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.grey2),
            ),
            const Gap(24),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  String _getReadableErrorMessage(String errorMessage) {
    if (errorMessage.contains('Connection closed before full header')) {
      return 'Server connection was interrupted. This may be due to unstable internet connection or the server is temporarily unavailable.';
    } else if (errorMessage.contains('Failed host lookup')) {
      return 'Unable to connect to server. Please check your internet connection and try again.';
    } else if (errorMessage.contains('Connection refused')) {
      return 'Server is not responding. Please try again later.';
    } else if (errorMessage.contains('Connection timed out')) {
      return 'Connection timed out. Please check your internet connection and try again.';
    } else if (errorMessage.contains('No Internet')) {
      return 'No internet connection available. Please check your connection and try again.';
    } else {
      return 'There was a problem connecting to the server. Please try again.';
    }
  }
}
