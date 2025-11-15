import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../gen/loading/wave_loading.dart';
import '../../../../widgets/connection_container.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../provider/home_provider.dart';
import '../widgets/home_alert.dart';
import '../widgets/home_event_history.dart';
import '../widgets/home_event_overview.dart';

class HomePage extends StatefulWidget {
  final int tabIndex;
  final ScrollController? scrollController;

  const HomePage({super.key, required this.tabIndex, this.scrollController});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    final authProvider = context.read<AuthenticationProvider>();

    print("started home page: ${authProvider.userProfile}");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeProvider = context.read<HomeProvider>();
      if (homeProvider.homeSummaryStatus == HomeStatus.initial) {
        homeProvider.startAutoRefresh(token: authProvider.authorization!.token);
      }
    });
  }

  Future<void> _handleRefresh() async {
    final user = context.read<AuthenticationProvider>();
    final homeProvider = context.read<HomeProvider>();
    print("home user token: ${user.authorization!.token}");

    await user.getUser();

    await homeProvider.getHomeSummaryRefresh(
      token: user.authorization?.token ?? '',
    );

    await homeProvider.getHomeEventHistoryRefresh(
      token: user.authorization?.token ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: RefreshIndicator(
            onRefresh: _handleRefresh,
            color: Theme.of(context).primaryColor,
            child:
                homeProvider.homeSummaryStatus == HomeStatus.loading
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [WaveLoading(), Gap(50)],
                    )
                    : SingleChildScrollView(
                      controller: widget.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          if ((homeProvider.homeSummary?.currentMonthCount ??
                                  0) >=
                              1)
                            homeAlert(
                              homeProvider: homeProvider,
                              context: context,
                            ),
                          ConnectionContainer(gap: 15, bottom: true),
                          eventOverview(homeProvider: homeProvider),
                          Gap(15),
                          eventHistory(
                            homeProvider: homeProvider,
                            context: context,
                          ),
                        ],
                      ),
                    ),
          ),
        );
      },
    );
  }
}
