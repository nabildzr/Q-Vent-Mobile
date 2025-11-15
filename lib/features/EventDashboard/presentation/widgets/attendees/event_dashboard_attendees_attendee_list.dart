import 'package:flutter/material.dart';
import '../../../domain/entities/attendee_with_attendance_entity.dart';
import 'event_dashboard_attendees_item.dart';

class EventDashboardAttendeesAttendeeList extends StatefulWidget {
  final List<AttendeeWithAttendanceEntity> attendees;
  final Future<void> Function() onRefresh;
  final bool Function(AttendeeWithAttendanceEntity) isAttendeePresent;
  final bool Function(AttendeeWithAttendanceEntity) isAttendeeSelected;
  final void Function(AttendeeWithAttendanceEntity, bool) setAttendeeSelected;
  final void Function(AttendeeWithAttendanceEntity, bool) setAttendeePresent;

  const EventDashboardAttendeesAttendeeList({
    super.key,
    required this.attendees,
    required this.onRefresh,
    required this.isAttendeePresent,
    required this.isAttendeeSelected,
    required this.setAttendeeSelected,
    required this.setAttendeePresent,
  });

  @override
  State<EventDashboardAttendeesAttendeeList> createState() => _EventDashboardAttendeesAttendeeListState();
}

class _EventDashboardAttendeesAttendeeListState extends State<EventDashboardAttendeesAttendeeList> {
  @override
  Widget build(BuildContext context) {
    return _buildAttendeeList(widget.attendees, widget.onRefresh);
  }

  Widget _buildAttendeeList(
    List<AttendeeWithAttendanceEntity> filteredAttendees,
    Future<void> Function() onRefresh,
  ) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        itemCount: filteredAttendees.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final attendee = filteredAttendees[index];
          final isPresent = widget.isAttendeePresent(attendee);
          final isSelected = widget.isAttendeeSelected(attendee);

          return EventDashboardAttendeesItem(
            attendee: attendee,
            isPresent: isPresent,
            isSelected: isSelected,
            onChangedCheckBox:
                (val) => widget.setAttendeeSelected(attendee, val ?? false),
            onChangedSwitch: (val) => widget.setAttendeePresent(attendee, val!),
          );
        },
      ),
    );
  }
}