import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../pages/home_page.dart';
import 'home_landing_head.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
    required Animation<double> borderRadiusAnimation,
    required TabController tabController,
    required ScrollController homeScrollController,
  }) : _borderRadiusAnimation = borderRadiusAnimation,
       _tabController = tabController,
       _homeScrollController = homeScrollController;

  final Animation<double> _borderRadiusAnimation;
  final TabController _tabController;
  final ScrollController _homeScrollController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _borderRadiusAnimation,

          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(_borderRadiusAnimation.value),
                  bottomRight: Radius.circular(_borderRadiusAnimation.value),
                ),
                border:
                    _borderRadiusAnimation.value > 0
                        ? Border(
                          bottom: BorderSide(
                            width: 2,
                            color: AppColors.primary,
                          ),
                        )
                        : null,
              ),
              child: HomeLandingHead(tabIndex: _tabController.index),
            );
          },
        ),
        Expanded(
          child: HomePage(
            tabIndex: _tabController.index,
            scrollController: _homeScrollController,
          ),
        ),
      ],
    );
  }
}
