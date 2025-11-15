import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/ion.dart';

import '../../pages/event_dashboard_attendees_page.dart';

class EventDashboardAttendeesSearchFilter extends StatefulWidget {
  final void Function(String)? onChangedSearch;
  final void Function()? onTapFilterOptions;
  final AttendeeFilter currentFilter;

  const EventDashboardAttendeesSearchFilter({
    super.key,
    this.onChangedSearch,
    this.onTapFilterOptions,
    required this.currentFilter,
  });

  @override
  State<EventDashboardAttendeesSearchFilter> createState() =>
      _EventDashboardAttendeesSearchFilterState();
}

class _EventDashboardAttendeesSearchFilterState
    extends State<EventDashboardAttendeesSearchFilter> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              cursorColor: Colors.blue,
              onChanged: widget.onChangedSearch,
              decoration: InputDecoration(
                hintText: 'Search attendee...',
                prefixIcon: const Icon(Icons.search),
                fillColor: const Color(0xFFF5F5F5),
                filled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 105, 105, 105),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: widget.onTapFilterOptions,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey),
                ),
                child: Row(
                  children: [
                    const Iconify(Ic.round_filter_alt),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.currentFilter == AttendeeFilter.none
                            ? 'Filter'
                            : widget.currentFilter.toString().split('.').last,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                    const Iconify(Ion.md_arrow_dropdown),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
