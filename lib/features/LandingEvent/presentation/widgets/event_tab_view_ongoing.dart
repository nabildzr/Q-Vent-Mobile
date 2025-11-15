import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'event_empty_state.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../../gen/scroll/scroll_to_up_button.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../provider/landing_event_provider.dart';
import 'event_landing_card.dart';

class EventTabViewOngoing extends StatefulWidget {
  const EventTabViewOngoing({super.key});

  @override
  State<EventTabViewOngoing> createState() => _EventTabViewOngoingState();
}

class _EventTabViewOngoingState extends State<EventTabViewOngoing> {
  late ScrollController _scrollController;
  bool _showBackToTop = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    final user = context.read<AuthenticationProvider>();

    final landingEventProvider = context.read<LandingEventProvider>();
    landingEventProvider.getEventOngoing(
      token: user.authorization?.token ?? '',
      userId: user.userProfile!.id,
    );
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
                  await landingEventProvider.getEventOngoing(
                    token: authProvider.authorization?.token ?? '',
                    userId: authProvider.userProfile?.id ?? 0,
                  );
                },
                child:
                    landingEventProvider.landingEventOngoingStatus ==
                            ResponseStatus.loading
                        ? WaveLoading()
                        : landingEventProvider.landingEventOngoingStatus ==
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
                        : (landingEventProvider.landingEventOngoing?.isEmpty ??
                            true)
                        ? EventEmptyState(
                          text: "No ongoing events found",
                          onRefresh: () async {
                            await landingEventProvider.getEventUpcoming(
                              token: authProvider.authorization?.token ?? '',
                              userId: authProvider.userProfile!.id,
                            );
                          },
                        )
                        : ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount:
                              landingEventProvider.landingEventOngoing!.length,
                          itemBuilder: (context, index) {
                            final event =
                                landingEventProvider
                                    .landingEventOngoing![index];

                            final isLastItem =
                                index ==
                                landingEventProvider
                                        .landingEventOngoing!
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
