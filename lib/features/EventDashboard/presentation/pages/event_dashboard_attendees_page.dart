import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:provider/provider.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../../widgets/general_back_button.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../../domain/entities/attendee_with_attendance_entity.dart';
import '../provider/event_dashboard_provider.dart';
import '../widgets/attendees/event_dashboard_attendees_action_row.dart';
import '../widgets/attendees/event_dashboard_attendees_attendee_list.dart';
import '../widgets/attendees/event_dashboard_attendees_search_filter.dart';

enum AttendeeFilter { none, present, absent, azAsc, azDesc }

class EventDashboardAttendeesPage extends StatefulWidget {
  const EventDashboardAttendeesPage({super.key});

  @override
  State<EventDashboardAttendeesPage> createState() =>
      _EventDashboardAtttendesPageState();
}

class _EventDashboardAtttendesPageState
    extends State<EventDashboardAttendeesPage> {
  // Search and filter state
  String searchQuery = "";
  AttendeeFilter currentFilter = AttendeeFilter.none;

  // Selection state
  Map<int, bool> selectedAttendees = {};
  Map<int, bool> attendeeStatusChanges = {};
  bool switchAllValue = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final eventDashboardProvider = context.read<EventDashboardProvider>();
      final authProvider = context.read<AuthenticationProvider>();

      eventDashboardProvider.getEventAttendees(
        authProvider.authorization?.token ?? '',
        eventDashboardProvider.event?.id ?? 0,
      );
    });
  }

  // helper methods for attendance status
  bool isAttendeePresent(AttendeeWithAttendanceEntity attendee) {
    return attendeeStatusChanges[attendee.attendeeEntity.id] ??
        (attendee.attendanceEntity.status == 'present');
  }

  void setAttendeePresent(
    AttendeeWithAttendanceEntity attendee,
    bool isPresent,
  ) {
    setState(() {
      attendeeStatusChanges[attendee.attendeeEntity.id] = isPresent;
    });
  }

  // helper methods for selection
  bool isAttendeeSelected(AttendeeWithAttendanceEntity attendee) {
    return selectedAttendees[attendee.attendeeEntity.id] ?? false;
  }

  void setAttendeeSelected(
    AttendeeWithAttendanceEntity attendee,
    bool isSelected,
  ) {
    setState(() {
      selectedAttendees[attendee.attendeeEntity.id] = isSelected;
    });
  }

  // reset all changes
  void resetChanges(List<AttendeeWithAttendanceEntity> attendees) {
    setState(() {
      selectedAttendees.clear();
      attendeeStatusChanges.clear();
      switchAllValue = true;
    });
  }

  // apply filter to attendees list
  List<AttendeeWithAttendanceEntity> applyFilters(
    List<AttendeeWithAttendanceEntity> attendees,
  ) {
    // first apply search filter
    var filtered =
        attendees
            .where(
              (a) =>
                  a.attendeeEntity.fullName.toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ) ||
                  a.attendanceEntity.status.contains(searchQuery),
            )
            .toList();

    // then apply type filter
    switch (currentFilter) {
      case AttendeeFilter.present:
        filtered = filtered.where((a) => isAttendeePresent(a)).toList();
        break;
      case AttendeeFilter.absent:
        filtered = filtered.where((a) => !isAttendeePresent(a)).toList();
        break;
      case AttendeeFilter.azAsc:
        filtered.sort(
          (a, b) =>
              a.attendeeEntity.fullName.compareTo(b.attendeeEntity.fullName),
        );
        break;
      case AttendeeFilter.azDesc:
        filtered.sort(
          (a, b) =>
              b.attendeeEntity.fullName.compareTo(a.attendeeEntity.fullName),
        );
        break;
      case AttendeeFilter.none:
        // f no additional filtering
        break;
    }

    return filtered;
  }

  // show filter options
  void showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _buildFilterSheet(),
    );
  }

  // build filter bottom sheet
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
                Navigator.pop(context);
              },
            ),
            title: Text(label),
            onTap: () {
              setState(() {
                currentFilter = filterOption;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
        const SizedBox(height: 10),
      ],
    );
  }

  // build submit modal
  void showSubmitModal(
    List<Map<String, dynamic>> selectedData,
    authProvider,
    provider,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: AppColors.backgroundPage,
      builder:
          (context) => DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.3,
            maxChildSize: 0.9,
            builder:
                (context, scrollController) => _buildSubmitSheet(
                  selectedData,
                  scrollController,
                  authProvider,
                  provider,
                ),
          ),
    );
  }

  void handleSubmit(
    List<Map<String, dynamic>> selectedData,
    AuthenticationProvider authProvider,
    EventDashboardProvider provider,
  ) async {
    try {
      final token = authProvider.authorization?.token;
      final eventId = provider.event?.id;

      Navigator.pop(context);

      showLoadingDialog(context, text: "Updating...");

      await provider.updateAttendees(token, eventId, selectedData);

      // close dialog
      if (mounted) Navigator.pop(context);

      setState(() {
        selectedAttendees.clear();
        attendeeStatusChanges.clear();
      });

      showCustomToast(
        context: context,
        message: 'Attendance status updated successfully',
        backgroundColor: AppColors.success,
        foregroundColor: AppColors.white,
        primaryColor: AppColors.white,
      );
    } catch (e) {
      // close dialog if error
      if (mounted) Navigator.pop(context);

      showCustomToast(
        context: context,
        message: 'Failed to update: ${e.toString()}',
        backgroundColor: AppColors.error,
        foregroundColor: AppColors.white,
        primaryColor: AppColors.white,
      );
    }
  }

  // build submit sheet content
  Widget _buildSubmitSheet(
    List<Map<String, dynamic>> selectedData,
    ScrollController scrollController,
    AuthenticationProvider authProvider,
    EventDashboardProvider provider,
  ) {
    return Column(
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
          "Review Selected Attendees",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            controller: scrollController,
            itemCount: selectedData.length,
            itemBuilder: (context, index) {
              final data = selectedData[index];
              return ListTile(
                leading: CircleAvatar(child: Text(data["id"].toString())),
                title: Text(data["name"]!.toString()),
                trailing: Text(
                  data["status"]!.toString(),
                  style: TextStyle(
                    color:
                        data["status"] == "Present" ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            },
          ),
        ),
        if (provider.event != null &&
            provider.event!.isOngoing)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: () => handleSubmit(selectedData, authProvider, provider),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                decoration: BoxDecoration(
                  color: AppColors.buttonBackgroundPrimary,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Update',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Future<void> onRefresh(authProvider, provider) async {
    try {
      final token = authProvider.authorization?.token;
      final eventId = provider.event?.id;

      // token and event id validation
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your session is invalid. Please log in again'),
          ),
        );
        return;
      }

      if (eventId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Event ID not found')));
        return;
      }

      await provider.getEventAttendees(token, eventId);

      //reset local
      setState(() {
        selectedAttendees.clear();
        attendeeStatusChanges.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPage,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundPage,
        title: const Text(
          "Attendees",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        scrolledUnderElevation: 0,
        leading: GeneralBackButton(onTap: () => Navigator.pop(context)),
      ),
      body: Consumer2<EventDashboardProvider, AuthenticationProvider>(
        builder: (context, provider, authProvider, child) {
          final attendees = provider.listAttendee?.attendeeWithAttendance ?? [];
          final filteredAttendees = applyFilters(attendees);
          final selectedCount =
              selectedAttendees.values.where((selected) => selected).length;

          return Column(
            children: [
              // Search and filter row
              EventDashboardAttendeesSearchFilter(
                currentFilter: currentFilter,
                onChangedSearch: (val) => setState(() => searchQuery = val),
                onTapFilterOptions: () => showFilterOptions(),
              ),

              EventDashboardAttendeesActionRow(
                filteredAttendees,
                attendees: filteredAttendees,
                selectedAttendees: Map<String, bool>.from(
                  selectedAttendees.map(
                    (key, value) => MapEntry(key.toString(), value),
                  ),
                ),
                switchAllValue: switchAllValue,
                onAttendeeSelectionChanged: (attendee, isSelected) {
                  setAttendeeSelected(attendee, isSelected);
                },
                isAttendeeSelected: isAttendeeSelected,
                onAttendeePresenceChanged: (attendee, isPresent) {
                  setAttendeePresent(attendee, isPresent);
                },
                onResetChanges: (attendees) {
                  resetChanges(attendees);
                },
                onSwitchAllValueChanged: (value) {
                  setState(() {
                    switchAllValue = value;
                  });
                },
              ),
              // attendee list
              Expanded(
                child:
                    provider.listAttendeeStatus == ResponseStatus.loading
                        ? WaveLoading()
                        : provider.listAttendeeStatus == ResponseStatus.error
                        ? Center(child: Text('Error loading attendees'))
                        : provider.listAttendee!.attendeeWithAttendance.isEmpty
                        ? Center(child: Text('No attendees found'))
                        : EventDashboardAttendeesAttendeeList(
                          attendees: filteredAttendees,
                          onRefresh: () => onRefresh(authProvider, provider),
                          isAttendeePresent: isAttendeePresent,
                          isAttendeeSelected: isAttendeeSelected,
                          setAttendeeSelected: setAttendeeSelected,
                          setAttendeePresent: setAttendeePresent,
                        ),
              ),
            ],
          );
        },
      ),
      floatingActionButton:
          Consumer2<EventDashboardProvider, AuthenticationProvider>(
            builder: (context, provider, authProvider, child) {
              final selectedCount =
                  selectedAttendees.values.where((selected) => selected).length;
              final attendees =
                  provider.listAttendee?.attendeeWithAttendance ?? [];

              if (selectedCount > 0) {
                return FloatingActionButton.extended(
                  splashColor: AppColors.secondary,

                  foregroundColor: AppColors.primary,
                  backgroundColor: AppColors.primaryLight,
                  elevation: 2,
                  onPressed: () {
                    final selectedData =
                        attendees
                            .where((a) => isAttendeeSelected(a))
                            .map(
                              (a) => {
                                "id": a.attendeeEntity.id,
                                "name": a.attendeeEntity.fullName,
                                "status":
                                    isAttendeePresent(a) ? "Present" : "Absent",
                              },
                            )
                            .toList();

                    showSubmitModal(selectedData, authProvider, provider);
                  },
                  label: Text("Submit ($selectedCount)"),
                  icon: const Icon(Icons.check),
                );
              }
              return SizedBox.shrink(); // no FAB when nothing is selected
            },
          ),
    );
  }

  // build action row (select all, switch, reset)
  Widget _buildActionRow(List<AttendeeWithAttendanceEntity> filteredAttendees) {
    bool selectAll = false;
    if (filteredAttendees.isNotEmpty) {
      selectAll = filteredAttendees.every(
        (a) => selectedAttendees[a.attendeeEntity.id] == true,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                color: AppColors.grey3.withOpacity(0.6),
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
                  setState(() {
                    for (var a in filteredAttendees) {
                      setAttendeeSelected(a, val ?? false);
                    }
                  });
                },
              ),
            ),
          ),
          Gap(10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.grey),
                color: AppColors.grey3.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Switch", overflow: TextOverflow.ellipsis),
                  Expanded(
                    child: Switch(
                      value: switchAllValue,
                      onChanged: (val) {
                        setState(() {
                          switchAllValue = val;
                          for (var a in filteredAttendees) {
                            if (isAttendeeSelected(a)) {
                              setAttendeePresent(a, val);
                            }
                          }
                        });
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
          Gap(10),
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey),
              color: AppColors.grey3.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: "Reset changes",
              onPressed: () => resetChanges(filteredAttendees),
              icon: const Iconify(Ic.twotone_refresh, color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
