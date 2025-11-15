//! THIS IS FOR SCROLLABLE PAGE!

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class WaveLoading extends StatelessWidget {
  const WaveLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/lottie/wave_loading_nabildzr.json'),
    );
  }
}
