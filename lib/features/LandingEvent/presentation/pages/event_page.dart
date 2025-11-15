import 'package:flutter/material.dart';

import '../../../../core/controller/inner_tab_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/event_tab_view_ongoing.dart';
import '../widgets/event_tab_view_past.dart';
import '../widgets/event_tab_view_upcoming.dart';

class EventLandingPage extends StatefulWidget {
  final int tabIndex;

  const EventLandingPage({super.key, required this.tabIndex});

  @override
  State<EventLandingPage> createState() => _EventLandingPageState();
}

class _EventLandingPageState extends State<EventLandingPage>
    with TickerProviderStateMixin {
  int _selectedTab = 0;

  late final VoidCallback _eventTabListener = () {
    if (!mounted) return;
    setState(() {
      _selectedTab = eventInnerTabIndex.value;
    });
  };

  final List<String> _tabs = ['Upcoming', 'Ongoing', 'Past'];

  @override
  void initState() {
    super.initState();

    _selectedTab = eventInnerTabIndex.value;
    eventInnerTabIndex.addListener(_eventTabListener);
  }

  @override
  void dispose() {
    eventInnerTabIndex.removeListener(_eventTabListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_tabs.length, (index) {
                final isSelected = _selectedTab == index;
                return Expanded(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(15),
                        ),
                        backgroundColor:
                            isSelected ? AppColors.third : AppColors.grey1,
                        shadowColor: Colors.transparent,
                        foregroundColor:
                            isSelected ? AppColors.primary : AppColors.grey2,

                        // elevation: isSelected ? 2 : 0,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        textStyle: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _selectedTab = index;
                        });

                        // keep notifier in sync when user taps
                        eventInnerTabIndex.value = index;
                      },
                      child: Text(_tabs[index]),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 250),
              child: _buildTabContent(_selectedTab),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return Column(key: ValueKey(0), children: [EventTabViewUpcoming()]);
      case 1:
        return Column(key: ValueKey(1), children: [EventTabViewOngoing()]);
      case 2:
        return Column(key: ValueKey(2), children: [EventTabViewPast()]);
      default:
        return SizedBox.shrink();
    }
  }
}
