import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:provider/provider.dart';
import 'package:qr_event_management/features/LandingEvent/presentation/provider/landing_event_provider.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';

import '../../../../core/scope/landing_tabs_scope.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../Home/presentation/provider/home_provider.dart';
import '../../../Home/presentation/widgets/home_view.dart';
import '../../../LandingEvent/presentation/widgets/event_view.dart';
import '../../../Setting/presentation/pages/setting_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _homeScrollController;
  late AnimationController _borderRadiusController;
  late Animation<double> _borderRadiusAnimation;

  @override
  void initState() {
    super.initState();

    final homeProvider = context.read<HomeProvider>();
    homeProvider.stopAutoRefresh();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _homeScrollController = ScrollController();

    _borderRadiusController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    _borderRadiusAnimation = Tween<double>(begin: 0.0, end: 30.0).animate(
      CurvedAnimation(parent: _borderRadiusController, curve: Curves.easeInOut),
    );

    _homeScrollController.addListener(_onHomeScroll);

    // Check token validity on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkTokenValidity();
    });

    // Set up periodic token check (every 15 minutes)
    Timer.periodic(Duration(seconds: 5), (_) {
      print("Running token check...");
      _checkTokenValidity();
    });
  }

  void _checkTokenValidity() {
    final authProvider = context.read<AuthenticationProvider>();
    authProvider.checkTokenAndLogout(context);
  }

  void _onHomeScroll() {
    const double scrollThreshold = 100.0;
    if (!_homeScrollController.hasClients) return;

    final double progress = (_homeScrollController.offset / scrollThreshold)
        .clamp(0.0, 1.0);

    // Daripada animateTo (memicu animasi tiap scroll & butuh duration),
    // langsung set value agar sinkron dengan posisi scroll.
    if (_borderRadiusController.value != progress) {
      _borderRadiusController.value = progress;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _homeScrollController.dispose();
    _borderRadiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      body: SafeArea(
        child: LandingTabsScope(
          controller: _tabController,
          child: Stack(
            children: [
              IndexedStack(
                index: _tabController.index,
                children: [
                  // Tab 1: Home
                  HomeView(
                    borderRadiusAnimation: _borderRadiusAnimation,
                    tabController: _tabController,
                    homeScrollController: _homeScrollController,
                  ),
                  // Tab 2: Events
                  EventView(tabController: _tabController),
                  // Tab 3: Settings
                  SettingView(
                    borderRadiusAnimation: _borderRadiusAnimation,
                    tabController: _tabController,
                  ),
                ],
              ),

              _buildTabBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(color: AppColors.secondary, blurRadius: 30.0),
            ],
            color: Color(0xFFDDE9FF),
            borderRadius: BorderRadius.circular(25),
          ),
          child: TabBar(
            controller: _tabController,
            padding: EdgeInsets.all(4),
            indicator: BoxDecoration(
              color: AppColors.third,
              borderRadius: BorderRadius.circular(25),
            ),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            unselectedLabelColor: Color(0xFF3F7CFF),
            labelColor: Colors.white,
            onTap: (value) async {
              final authProvider = context.read<AuthenticationProvider>();
              final lEventProvider = context.read<LandingEventProvider>();
              final lHomeProvider = context.read<HomeProvider>();

              if (value == 0) {
                await lHomeProvider.getHomeSummaryRefresh(
                  token: authProvider.authorization?.token ?? '',
                );
                await lHomeProvider.getHomeEventHistoryRefresh(
                  token: authProvider.authorization?.token ?? '',
                );
              }

              if (value == 1) {
                if (authProvider.userProfile != null) {
                  await lEventProvider.getEventUpcoming(
                    token: authProvider.authorization?.token ?? '',
                    userId: authProvider.userProfile!.id,
                  );
                  await lEventProvider.getEventOngoing(
                    token: authProvider.authorization?.token ?? '',
                    userId: authProvider.userProfile!.id,
                  );
                  await lEventProvider.getEventPast(
                    token: authProvider.authorization?.token ?? '',
                    userId: authProvider.userProfile!.id,
                  );
                } else {
                  // Handle case where user profile is null
                  print("User profile is null, skipping event fetching");
                  // Optionally try to fetch the user profile
                  await authProvider.getUser();
                }
              }

              setState(() {});
            },
            tabs: [
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Iconify(
                    MaterialSymbols.home_rounded,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Iconify(Ri.calendar_2_fill, color: AppColors.primary),
                ),
              ),
              Tab(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Iconify(Ri.settings_fill, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
