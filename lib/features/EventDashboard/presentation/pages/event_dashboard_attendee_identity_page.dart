import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../provider/event_dashboard_provider.dart';
import '../../../../widgets/general_back_button.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class EventDashboardAttendeeIdentityPage extends StatefulWidget {
  const EventDashboardAttendeeIdentityPage({super.key});

  @override
  State<EventDashboardAttendeeIdentityPage> createState() =>
      _EventDashboardAttendeeIdentityPageState();
}

class _EventDashboardAttendeeIdentityPageState
    extends State<EventDashboardAttendeeIdentityPage> {
  String qrcodeData = '-';
  String attendDate = '-';
  String attendTime = '-';
  String time = '-';
  String email = '-';
  String name = '-';
  String phoneNumber = '-';
  String status = '-';

  @override
  void initState() {
    super.initState();

    final eventDashboardProvider = context.read<EventDashboardProvider>();

    // Initialize state variables from provider data
    if (eventDashboardProvider.attendeeIdentity != null) {
      setState(() {
        qrcodeData =
            eventDashboardProvider.attendeeIdentity?.attendee.code ?? '-';
        name =
            eventDashboardProvider.attendeeIdentity?.attendee.fullName ?? "-";
        attendDate =
            eventDashboardProvider.attendeeIdentity?.attendances.checkInDate ??
            "-";
        attendTime =
            eventDashboardProvider.attendeeIdentity?.attendances.checkInTime ??
            "-";
        time =
            eventDashboardProvider.attendeeIdentity?.attendances.checkInTime ??
            "-";
        email =
            eventDashboardProvider.attendeeIdentity!.attendee.email.isEmpty
                ? "-"
                : eventDashboardProvider.attendeeIdentity!.attendee.email;
        phoneNumber =
            eventDashboardProvider.attendeeIdentity!.attendee.phoneNumber.isEmpty
                ? "-"
                : eventDashboardProvider.attendeeIdentity!.attendee.phoneNumber;
      
        status =
            eventDashboardProvider.attendeeIdentity?.attendances.status ?? "-";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan Attendance Result',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: GeneralBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        scrolledUnderElevation: 0,
      ),
      body: Consumer<EventDashboardProvider>(
        builder: (context, eventDashboardProvider, child) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 20.0,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      eventDashboardProvider.attendeeIdentity != null &&
                              eventDashboardProvider
                                      .attendeeIdentity!
                                      .attendances
                                      .status ==
                                  'invalid'
                          ? Lottie.asset(
                            'assets/lottie/failed_nabildzr.json',
                            width: 100,
                          )
                          : Lottie.asset(
                            'assets/lottie/success_nabildzr.json',
                            width: 100,
                          ),
                      Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventDashboardProvider.attendeeIdentity != null &&
                                    eventDashboardProvider
                                            .attendeeIdentity!
                                            .attendances
                                            .status ==
                                        'invalid'
                                ? 'Invalid'
                                : 'Success',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            eventDashboardProvider
                                .attendeeIdentity!
                                .attendances
                                .status,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.black.withOpacity(0.8),
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(10),
                  Divider(color: AppColors.grey1, thickness: 2),
                  Gap(10),
                  Gap(10),
                  Text(
                    name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'QR Code',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    qrcodeData,
                                    style: TextStyle(
                                      color: AppColors.black,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Gap(5),
                                ZoomTapAnimation(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: AppColors.backgroundPage,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(32),
                                        ),
                                      ),
                                      builder:
                                          (context) => Container(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Code Details',
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 16),

                                                ListTile(
                                                  leading: const Iconify(
                                                    MaterialSymbols.qr_code,
                                                  ),
                                                  title: Text(qrcodeData),
                                                ),
                                                Gap(20),
                                              ],
                                            ),
                                          ),
                                    );
                                  },
                                  child: Iconify(
                                    Ic.outline_remove_red_eye,
                                    color: AppColors.primary,
                                    size: 25,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Attend Date',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              attendDate,
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              attendTime,
                              style: TextStyle(
                                color: AppColors.black,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Email',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            email,
                            style: TextStyle(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(10),

                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Phone Number',
                            style: TextStyle(
                              color: AppColors.grey,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            phoneNumber,
                            style: TextStyle(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Notes',
                            style: TextStyle(
                              color: AppColors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            eventDashboardProvider
                                    .attendeeIdentity!
                                    .attendances
                                    .notes
                                    .isEmpty
                                ? 'None'
                                : eventDashboardProvider
                                    .attendeeIdentity!
                                    .attendances
                                    .notes,
                            style: TextStyle(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(10),
                  IdentityItem(
                    label: 'Event Title',
                    value:
                        eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .title
                                .isEmpty
                            ? 'Untitled'
                            : eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .title,
                  ),
                  Gap(10),
                  IdentityItem(
                    label: 'Event Location',
                    value:
                        eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .location
                                .isEmpty
                            ? 'No Location'
                            : eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .location,
                  ),
                  Gap(10),
                  IdentityItem(
                    label: 'Event Start Date',
                    value:
                        eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .startDate
                                .isEmpty
                            ? 'Not been set'
                            : eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .startDate,
                  ),
                  Gap(10),
                  IdentityItem(
                    label: 'Event End Date',
                    value:
                        eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .endDate
                                .isEmpty
                            ? 'Not been set'
                            : eventDashboardProvider
                                .attendeeIdentity!
                                .event
                                .endDate,
                  ),
                  Gap(10),
                  Divider(color: AppColors.grey1, thickness: 2),
                  Gap(10),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status',
                            style: TextStyle(
                              color: AppColors.grey,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            status,
                            style: TextStyle(
                              color: AppColors.black,
                              overflow: TextOverflow.ellipsis,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Gap(30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class IdentityItem extends StatelessWidget {
  final String label;
  final String value;

  const IdentityItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: AppColors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: AppColors.black,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
