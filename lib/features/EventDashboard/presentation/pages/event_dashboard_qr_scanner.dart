import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/ph.dart';
import 'package:iconify_flutter/icons/ri.dart';
import 'package:iconify_flutter/icons/uil.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:qr_event_management/features/EventDashboard/presentation/pages/event_dashboard_attendee_identity_page.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../gen/alert/toastification.dart';
import '../../../../gen/loading/dialog_screen.dart';
import '../../../../gen/loading/wave_loading.dart';
import '../../../../widgets/general_back_button.dart';
import '../../../Authentication/presentation/provider/authentication_provider.dart';
import '../provider/event_dashboard_provider.dart';
import '../widgets/event_dashboard_result_item.dart';
import '../widgets/event_dashboard_scan_attendance_result.dart';
import 'event_dashboard_attendance_result_page.dart';

class QRViewTest extends StatefulWidget {
  final int eventId;

  const QRViewTest({super.key, required this.eventId});

  @override
  State<QRViewTest> createState() => _QRViewTestState();
}

enum ScanMode { attendance, identityCheck }

class _QRViewTestState extends State<QRViewTest>
    with SingleTickerProviderStateMixin {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  late AnimationController _animationController;
  late Animation<double> _animation;

  ScanMode _currentScanMode = ScanMode.attendance;

  void resetDataState() {
    final eventDashboardProvider = context.read<EventDashboardProvider>();

    eventDashboardProvider.resetAttendanceStatus();
    eventDashboardProvider.resetAttendanceState();
  }

  @override
  void initState() {
    super.initState();

    resetDataState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    final eventDashboardProvider = context.read<EventDashboardProvider>();
    eventDashboardProvider.resetAttendanceStatus();
    eventDashboardProvider.resetAttendanceState();

    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cutOutSize = MediaQuery.of(context).size.width * 0.7;

    return Scaffold(
      appBar: AppBar(
        leading: GeneralBackButton(
          onTap: () {
            Navigator.pop(context);
          },
        ),

        title: Text("Scan QR", style: TextStyle(fontWeight: FontWeight.bold)),

        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.backgroundPage,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                builder:
                    (context) => Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Options',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ListTile(
                            leading: const Iconify(Ri.qr_scan_fill),
                            title: const Text('Scanner Options'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              scannerOptionsModalBottomSheet(context);
                            },
                          ),
                          ListTile(
                            leading: const Iconify(MaterialSymbols.flash_on),
                            title: const Text('Toggle Flash'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            onTap: () {
                              controller?.toggleFlash();
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Iconify(
                              MaterialSymbols.flip_camera_ios,
                            ),
                            title: const Text('Flip Camera'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(99),
                            ),
                            onTap: () {
                              controller?.flipCamera();
                              Navigator.pop(context);
                            },
                          ),
                          Gap(20),
                        ],
                      ),
                    ),
              );
            },
            icon: const Icon(Icons.more_vert, color: AppColors.black),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          // qrscanner
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,

            overlay: QrScannerOverlayShape(
              borderColor: Colors.blue,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 8,
              cutOutSize: cutOutSize,
              overlayColor: Colors.black.withOpacity(0.5),
            ),
          ),

          // scan line
          Positioned.fill(
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: cutOutSize,
                  height: cutOutSize,
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment(0, (2 * _animation.value) - 1),
                        child: ImageFiltered(
                          imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            height: 4,
                            width: cutOutSize,
                            color: Colors.blueAccent.withOpacity(0.8),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // result & tab
          Consumer<EventDashboardProvider>(
            builder: (context, eventDashboardProvider, child) {
              if (eventDashboardProvider.attendanceStatus ==
                  ResponseStatus.loading) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showLoadingDialog(
                    context,
                    text: "Processing attendee data...",
                  );
                });
              }

              if (eventDashboardProvider.attendanceStatus ==
                  ResponseStatus.success) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showCustomToast(
                    context: context,
                    message:
                        eventDashboardProvider.attendeeIdentity != null
                            ? (eventDashboardProvider
                                    .attendeeIdentity
                                    ?.message ??
                                '')
                            : (eventDashboardProvider.attendanceData?.message ??
                                ''),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    primaryColor: AppColors.white,
                  );
                });
              }

              if (eventDashboardProvider.attendanceStatus ==
                  ResponseStatus.error) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context, rootNavigator: true).pop();
                  showCustomToast(
                    context: context,
                    message: eventDashboardProvider.cleanErrorMessage,
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                    primaryColor: AppColors.white,
                  );
                  Future.delayed(Duration(milliseconds: 500), () {
                    eventDashboardProvider.resetAttendanceStatus();
                    eventDashboardProvider.resetAttendanceState();
                  });
                });
              }

              return Positioned(
                bottom: 49,
                right: 15,
                left: 15,
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: 180.0,

                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child:
                      eventDashboardProvider.attendanceStatus ==
                              ResponseStatus.initial
                          ? Center(
                            child: Text('Position the QR code in the frame'),
                          )
                          : eventDashboardProvider.attendanceStatus ==
                                  ResponseStatus.loading ||
                              (eventDashboardProvider.attendanceData == null &&
                                  eventDashboardProvider.attendeeIdentity ==
                                      null)
                          ? Center(child: WaveLoading())
                          : _currentScanMode == ScanMode.attendance
                          ? EventDashboardScanAttendanceResult(
                            eventDashboardProvider: eventDashboardProvider,
                          )
                          : EventDashboardScanIdentityCheckResult(
                            eventDashboardProvider: eventDashboardProvider,
                          ),

                  // child: Center(
                  //   child:
                  //       (result != null)
                  //           ? Text(
                  //             'Barcode Type: ${result!.format.name}\nData: ${result!.code}',
                  //             textAlign: TextAlign.center,
                  //           )
                  //           : const Text('Arahkan QR Code ke dalam kotak'),
                  // ),
                ),
              );
            },
          ),

          Positioned(
            top: 16,
            left: 16,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _currentScanMode == ScanMode.attendance
                        ? Icons.people_alt_outlined
                        : Icons.badge_outlined,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _currentScanMode == ScanMode.attendance
                        ? 'Attendance Mode'
                        : 'Identity Check Mode',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> scannerOptionsModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundPage,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder:
          (context) => Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Scanner Options',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Iconify(
                    Ph.user_focus_bold,
                    color:
                        _currentScanMode == ScanMode.attendance
                            ? AppColors.white
                            : AppColors.black,
                  ),
                  title: Text(
                    'Attendance',
                    style: TextStyle(
                      color:
                          _currentScanMode == ScanMode.attendance
                              ? AppColors.white
                              : AppColors.black,
                    ),
                  ),
                  tileColor:
                      _currentScanMode == ScanMode.attendance
                          ? AppColors.primary
                          : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  onTap: () {
                    resetDataState();

                    setState(() {
                      _currentScanMode = ScanMode.attendance;
                    });
                    Navigator.pop(context);
                  },
                ),
                Gap(5),
                ListTile(
                  leading: Iconify(
                    Uil.qrcode_scan,
                    color:
                        _currentScanMode == ScanMode.identityCheck
                            ? AppColors.white
                            : AppColors.black,
                  ),
                  title: Text(
                    'Identity Check',
                    style: TextStyle(
                      color:
                          _currentScanMode == ScanMode.identityCheck
                              ? AppColors.white
                              : AppColors.black,
                    ),
                  ),
                  tileColor:
                      _currentScanMode == ScanMode.identityCheck
                          ? AppColors.primary
                          : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(99),
                  ),
                  onTap: () {
                    resetDataState();

                    setState(() {
                      _currentScanMode = ScanMode.identityCheck;
                    });
                    Navigator.pop(context);
                  },
                ),
                Gap(20),
              ],
            ),
          ),
    );
  }

  // Limit scan to avoid laggy screening by adding a cooldown
  DateTime? _lastScanTime;

  void _onQRViewCreated(QRViewController controller) {
    final authProvider = context.read<AuthenticationProvider>();
    final eventDashboardProvider = context.read<EventDashboardProvider>();

    this.controller = controller;

    controller.scannedDataStream.listen((scanData) async {
      // Only process scan if not loading and cooldown passed
      if (eventDashboardProvider.attendanceStatus != ResponseStatus.loading) {
        final now = DateTime.now();
        if (_lastScanTime == null ||
            now.difference(_lastScanTime!) > const Duration(seconds: 2)) {
          _lastScanTime = now;
          setState(() {
            result = scanData;
          });

          if (result == null || result!.code == null) {
            eventDashboardProvider.errorMessage = "Invalid QR code format";
            eventDashboardProvider.setAttendanceStatus(ResponseStatus.error);
            return;
          }

          String attendeeId;

          try {
            // Try to parse as JSON if the QR contains JSON data
            final data = jsonDecode(result!.code!);
            attendeeId = data["qrcode_data"]?.toString() ?? "";

            if (attendeeId.isEmpty) {
              eventDashboardProvider.errorMessage =
                  "Missing attendee data in QR";
              eventDashboardProvider.setAttendanceStatus(ResponseStatus.error);
              return;
            }
          } catch (e) {
            // If not JSON or doesn't have qrcode_data, use the raw code
            attendeeId = result!.code!;
          }

          try {
            if (_currentScanMode == ScanMode.attendance) {
              await eventDashboardProvider.scanAttendance(
                authProvider.authorization?.token ?? '',
                widget.eventId,
                attendeeId,
              );
            } else {
              await eventDashboardProvider.scanIdentityCheck(
                authProvider.authorization?.token ?? '',
                widget.eventId,
                attendeeId,
              );
            }
          } catch (e) {
            eventDashboardProvider.errorMessage =
                "Error processing QR code: ${e.toString()}";
            eventDashboardProvider.setAttendanceStatus(ResponseStatus.error);
          }
        }
      }
    });
  }
}

class EventDashboardScanIdentityCheckResult extends StatelessWidget {
  final EventDashboardProvider eventDashboardProvider;

  const EventDashboardScanIdentityCheckResult({
    super.key,
    required this.eventDashboardProvider,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                EventDashboardResultItem(
                  title: 'Name',
                  isBadge: false,
                  icon: Iconify(Uil.user, color: AppColors.primary),
                  textContent:
                      eventDashboardProvider
                          .attendeeIdentity
                          ?.attendee
                          .fullName ??
                      '',
                ),
                Gap(15),
                EventDashboardResultItem(
                  title: 'Details',
                  isBadge: false,
                  icon: Iconify(Ph.file_text, color: AppColors.primary),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        barrierDismissible: false,
                        builder: (_) => EventDashboardAttendeeIdentityPage(),
                      ),
                    );
                  },
                  textContent: "Click Me!",
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: SingleChildScrollView(
            child: Column(
              children: [
                EventDashboardResultItem(
                  title: 'Status',
                  isBadge: true,
                  icon: Iconify(Ph.check_circle, color: AppColors.primary),
                  isScannedStatus:
                      eventDashboardProvider
                              .attendeeIdentity
                              ?.attendances
                              .status
                              .isNotEmpty ==
                          true &&
                      eventDashboardProvider
                              .attendeeIdentity
                              ?.attendances
                              .status !=
                          'absent' &&
                      eventDashboardProvider
                              .attendeeIdentity
                              ?.attendances
                              .status !=
                          'invalid',
                  textContent:
                      eventDashboardProvider
                          .attendeeIdentity
                          ?.attendances
                          .status ??
                      'Unknown',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
