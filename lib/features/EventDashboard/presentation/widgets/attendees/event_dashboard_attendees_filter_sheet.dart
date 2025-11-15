import 'package:flutter/material.dart';

enum AttendeeFilter { none, azAsc, azDesc }

class EventDashboardAttendeesFilterSheet extends StatefulWidget {
  final AttendeeFilter initialFilter;
  final Function(AttendeeFilter) onFilterChanged;

  const EventDashboardAttendeesFilterSheet({
    super.key, 
    this.initialFilter = AttendeeFilter.none,
    required this.onFilterChanged,
  });

  @override
  State<EventDashboardAttendeesFilterSheet> createState() => _EventDashboardAttendeesFilterSheetState();
}

class _EventDashboardAttendeesFilterSheetState extends State<EventDashboardAttendeesFilterSheet> {
  late AttendeeFilter currentFilter;

  @override
  void initState() {
    super.initState();
    currentFilter = widget.initialFilter;
  }

  @override
  Widget build(BuildContext context) {
    return _buildFilterSheet();
  }

  Widget _buildFilterSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 8),
          height: 5,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Filter Attendees",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...AttendeeFilter.values.map((filterOption) {
          String label = filterOption.toString().split('.').last;
          if (label == 'azAsc') label = 'A-Z Ascending';
          if (label == 'azDesc') label = 'A-Z Descending';
          if (label == 'none') label = 'None';

          return ListTile(
            leading: Radio<AttendeeFilter>(
              value: filterOption,
              groupValue: currentFilter,
              onChanged: (val) {
                setState(() {
                  currentFilter = val!;
                });
                widget.onFilterChanged(currentFilter);
                Navigator.pop(context);
              },
            ),
            title: Text(label),
            onTap: () {
              setState(() {
                currentFilter = filterOption;
              });
              widget.onFilterChanged(currentFilter);
              Navigator.pop(context);
            },
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }
}