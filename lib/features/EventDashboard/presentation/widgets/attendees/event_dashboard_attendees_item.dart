import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/attendee_with_attendance_entity.dart';

class EventDashboardAttendeesItem extends StatefulWidget {
  final bool? isSelected;
  final void Function(bool?)? onChangedCheckBox;
  final void Function(bool?)? onChangedSwitch;
  final AttendeeWithAttendanceEntity attendee;
  final bool isPresent;

  const EventDashboardAttendeesItem({
    super.key,
    this.isSelected,
    this.onChangedCheckBox,
    this.onChangedSwitch,
    required this.attendee,
    required this.isPresent,
  });

  @override
  State<EventDashboardAttendeesItem> createState() =>
      _EventDashboardAttendeesItemState();
}

class _EventDashboardAttendeesItemState
    extends State<EventDashboardAttendeesItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: widget.isSelected,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        activeColor: AppColors.primary,
        onChanged: widget.onChangedCheckBox,
      ),
      title: Text(
        widget.attendee.attendeeEntity.fullName,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("ID: ${widget.attendee.attendeeEntity.id}"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Switch(
            value: widget.isPresent,
            onChanged: widget.onChangedSwitch,
            activeColor: AppColors.primary,
            inactiveThumbColor: AppColors.red,
            trackOutlineColor: MaterialStateProperty.all(
              AppColors.primaryLight,
            ),
            inactiveTrackColor: Colors.red[200],
          ),
          Text(
            widget.isPresent ? "Present" : "Absent",
            style: TextStyle(
              color: widget.isPresent ? AppColors.primary : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
