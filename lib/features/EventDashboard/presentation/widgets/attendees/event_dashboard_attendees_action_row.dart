import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:gap/gap.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/attendee_with_attendance_entity.dart';

// build action row (select all, switch, reset)

class EventDashboardAttendeesActionRow extends StatefulWidget {
  final List<AttendeeWithAttendanceEntity> attendees;
  final Map<String, bool> selectedAttendees;
  final bool switchAllValue;
  final Function(AttendeeWithAttendanceEntity, bool) onAttendeeSelectionChanged;
  final Function(AttendeeWithAttendanceEntity) isAttendeeSelected;
  final Function(AttendeeWithAttendanceEntity, bool) onAttendeePresenceChanged;
  final Function(List<AttendeeWithAttendanceEntity>) onResetChanges;
  final Function(bool) onSwitchAllValueChanged;
  

  const EventDashboardAttendeesActionRow(List<AttendeeWithAttendanceEntity> filteredAttendees, {
    super.key,
    required this.attendees,
    required this.selectedAttendees,
    required this.switchAllValue,
    required this.onAttendeeSelectionChanged,
    required this.isAttendeeSelected,
    required this.onAttendeePresenceChanged,
    required this.onResetChanges,
    required this.onSwitchAllValueChanged,
  });

  @override
  State<EventDashboardAttendeesActionRow> createState() => _EventDashboardAttendeesActionRowState();
}

class _EventDashboardAttendeesActionRowState extends State<EventDashboardAttendeesActionRow> {
  @override
  Widget build(BuildContext context) {
    bool selectAll = false;
    if (widget.attendees.isNotEmpty) {
      selectAll = widget.attendees.every(
        (a) => widget.selectedAttendees[a.attendeeEntity.id.toString()] == true,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                color: AppColors.grey1,
                borderRadius: BorderRadius.circular(12),
              ),
              child: CheckboxListTile(
                dense: true,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text("Select All"),
                checkboxShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                value: selectAll,
                activeColor: AppColors.primary,
                onChanged: (val) {
                  for (var attendee in widget.attendees) {
                    widget.onAttendeeSelectionChanged(attendee, val ?? false);
                  }
                },
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                          color: AppColors.grey1,

                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Switch", overflow: TextOverflow.ellipsis),
                  Expanded(
                    child: Switch(
                      value: widget.switchAllValue,
                      onChanged: (val) {
                        widget.onSwitchAllValueChanged(val);
                        for (var attendee in widget.attendees) {
                          if (widget.isAttendeeSelected(attendee)) {
                            widget.onAttendeePresenceChanged(attendee, val);
                          }
                        }
                      },
                      activeColor: AppColors.primary,
                      inactiveThumbColor: AppColors.red,
                      trackOutlineColor: MaterialStateProperty.all(
                        AppColors.primaryLight,
                      ),
                      inactiveTrackColor: Colors.red[200],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
                           color: AppColors.grey1,

              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: "Reset changes",
              onPressed: () => widget.onResetChanges(widget.attendees),
              icon: const Iconify(Ic.twotone_refresh, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}