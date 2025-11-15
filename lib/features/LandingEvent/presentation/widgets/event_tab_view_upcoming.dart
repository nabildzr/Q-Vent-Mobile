import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../../gen/scroll/scroll_to_up_button.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../provider/landing_event_provider.dart';
import 'event_empty_state.dart';
import 'event_landing_card.dart';

class EventTabViewUpcoming extends StatefulWidget {
  const EventTabViewUpcoming({super.key});

  @override
  State<EventTabViewUpcoming> createState() => _EventTabViewUpcomingState();
}

class _EventTabViewUpcomingState extends State<EventTabViewUpcoming> {
  late ScrollController _scrollController;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthenticationProvider>();
      final landingEventProvider = context.read<LandingEventProvider>();

      landingEventProvider.getEventUpcoming(
        token: user.authorization?.token ?? '',
        userId: user.userProfile?.id ?? 0,
      );
    });
  }

  void _scrollListener() {
    if (_scrollController.offset > 200 && !_showBackToTop) {
      setState(() {
        _showBackToTop = true;
      });
    } else if (_scrollController.offset <= 200 && _showBackToTop) {
      setState(() {
        _showBackToTop = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<LandingEventProvider, AuthenticationProvider>(
      builder: (context, landingEventProvider, authProvider, child) {
        return SizedBox(
          height: MediaQuery.of(context).size.height - 250,
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await landingEventProvider.getEventUpcoming(
                    token: authProvider.authorization?.token ?? '',
                    userId: authProvider.userProfile!.id,
                  );
                },
                child:
                    landingEventProvider.landingEventUpcomingStatus ==
                            ResponseStatus.loading
                        ? WaveLoading()
                        : landingEventProvider.landingEventUpcomingStatus ==
                            ResponseStatus.error
                        ? EventEmptyState(
                          text: "Something went wrong, please\ntry again later",
                          onRefresh: () async {
                            await landingEventProvider.getEventUpcoming(
                              token: authProvider.authorization?.token ?? '',
                              userId: authProvider.userProfile!.id,
                            );
                          },
                        )
                        : (landingEventProvider.landingEventUpcoming?.isEmpty ??
                            true)
                        ? EventEmptyState(
                          text: "No upcoming events found",
                          onRefresh: () async {
                            await landingEventProvider.getEventUpcoming(
                              token: authProvider.authorization?.token ?? '',
                              userId: authProvider.userProfile!.id,
                            );
                          },
                        )
                        : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              landingEventProvider.landingEventUpcoming?.length,
                          itemBuilder: (context, index) {
                            final event =
                                landingEventProvider
                                    .landingEventUpcoming![index];

                            final isLastItem =
                                index ==
                                landingEventProvider
                                        .landingEventUpcoming!
                                        .length -
                                    1;

                            return Column(
                              children: [
                                EventLandingCard(
                                  id: event.id,
                                  title: event.title,
                                  location: event.location,
                                  createdBy: event.createdBy,
                                  startDate: event.startDate,
                                  endDate: event.endDate,
                                  banner: event.banner,
                                ),

                                if (isLastItem) Gap(75),
                              ],
                            );
                          },
                        ),
              ),
              if (_showBackToTop)
                scrollToUpButton(scrollController: _scrollController),
            ],
          ),
        );
      },
    );
  }
}
