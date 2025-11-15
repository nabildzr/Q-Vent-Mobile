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

class EventDashboardResultPage extends StatefulWidget {
  const EventDashboardResultPage({super.key});

  @override
  State<EventDashboardResultPage> createState() =>
      _EventDashboardResultPageState();
}

class _EventDashboardResultPageState extends State<EventDashboardResultPage> {
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
    if (eventDashboardProvider.attendanceData != null) {
      setState(() {
        qrcodeData = eventDashboardProvider.attendanceData?.qrCode ?? '-';
        name =
            eventDashboardProvider.attendanceData?.attendeeEntity.fullName ??
            "-";
        attendDate =
            eventDashboardProvider
                .attendanceData
                ?.attendanceEntity
                .checkInDate ??
            "-";
        attendTime =
            eventDashboardProvider
                .attendanceData
                ?.attendanceEntity
                .checkInTime ??
            "-";
        time =
            eventDashboardProvider
                .attendanceData
                ?.attendanceEntity
                .checkInTime ??
            "-";
        email =
            eventDashboardProvider.attendanceData?.attendeeEntity.email ?? "-";
        phoneNumber =
            eventDashboardProvider.attendanceData?.attendeeEntity.phoneNumber ??
            "-";
        status =
            eventDashboardProvider.attendanceData?.attendanceEntity.status ??
            "-";
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      eventDashboardProvider.attendanceData != null &&
                              eventDashboardProvider
                                      .attendanceData!
                                      .attendanceEntity
                                      .status ==
                                  'invalid'
                          ? 
                          Lottie.asset(
                            'assets/lottie/failed_nabildzr.json',
                            width: 100,
                          )

:                           Lottie.asset(
                            'assets/lottie/success_nabildzr.json',
                            width: 100,
                          ),
                      Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            eventDashboardProvider.attendanceData != null &&
                                    eventDashboardProvider
                                            .attendanceData!
                                            .attendanceEntity
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
                                .attendanceData!
                                .attendanceEntity
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
                  Text(
                    eventDashboardProvider.event?.title ?? 'Untitled',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
