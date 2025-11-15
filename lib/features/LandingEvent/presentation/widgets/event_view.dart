import 'package:flutter/material.dart';

import '../pages/event_page.dart';
import 'event_landing_head.dart';

class EventView extends StatelessWidget {
  const EventView({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            ),
          child: EventLandingHead(
            tabIndex: _tabController.index,
          ),
        ),
        Expanded(
          child: EventLandingPage(
            tabIndex: _tabController.index,
          ),
        ),
      ],
    );
  }
}