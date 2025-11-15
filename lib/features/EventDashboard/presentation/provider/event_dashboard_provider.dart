import 'package:flutter/widgets.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/check_identity_model.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/check_identity_entity.dart';

import '../../../../core/constant/enum_status.dart';
import '../../../../core/error/clean_error_message_cleaner.dart';
import '../../domain/entities/attendance_data_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/list_attendees_entity.dart';
import '../../domain/usecases/get_event_attendees_usecase.dart';
import '../../domain/usecases/get_event_by_id_usecase.dart';
import '../../domain/usecases/scan_attendance_usecase.dart';
import '../../domain/usecases/scan_identity_check_usecase.dart';
import '../../domain/usecases/update_attendees_status_usecase.dart';

class EventDashboardProvider extends ChangeNotifier {
  final GetEventByIdUsecase getEventByIdUsecase;
  final ScanAttendanceUsecase scanAttendanceUsecase;
  final ScanIdentityCheckUsecase scanIdentityCheckUsecase;
  final GetEventAttendeesUsecase getEventAttendeesUsecase;
  final UpdateAttendeesStatusUsecase updateAttendeesStatusUsecase;

  EventDashboardProvider({
    required this.getEventByIdUsecase,
    required this.scanAttendanceUsecase,
    required this.scanIdentityCheckUsecase,
    required this.getEventAttendeesUsecase,
    required this.updateAttendeesStatusUsecase,
  });

  //? init
  String? errorMessage;

  // dashboard
  EventEntity? _event;

  // attendance
  AttendanceDataEntity? _attendanceData;
  CheckIdentityEntity? _attendeeIdentity;
  ListAttendeesEntity? _listAttendees;

  ResponseStatus _eventStatus = ResponseStatus.initial;
  ResponseStatus _attendanceStatus = ResponseStatus.initial;
  ResponseStatus _listAttendeesStatus = ResponseStatus.initial;
  ResponseStatus _updateAttendeesStatus = ResponseStatus.initial;

  //? getters
  String get cleanErrorMessage => errorMessage.cleanErrorMessage;
  EventEntity? get event => _event;
  AttendanceDataEntity? get attendanceData => _attendanceData;
  CheckIdentityEntity? get attendeeIdentity => _attendeeIdentity;
  ListAttendeesEntity? get listAttendee => _listAttendees;
  ResponseStatus get eventStatus => _eventStatus;
  ResponseStatus get attendanceStatus => _attendanceStatus;
  ResponseStatus get listAttendeeStatus => _listAttendeesStatus;
  ResponseStatus get updateAttendeesStatus => _updateAttendeesStatus;

  void _setEventStatus(ResponseStatus status) {
    _eventStatus = status;
    notifyListeners();
  }

  void setAttendanceStatus(ResponseStatus status) {
    _attendanceStatus = status;
    notifyListeners();
  }

  void _setListAttendeesStatus(ResponseStatus status) {
    _listAttendeesStatus = status;
    notifyListeners();
  }

  void _setUpdateAttendeesStatus(ResponseStatus status) {
    _updateAttendeesStatus = status;
    notifyListeners();
  }

  void resetAllState() {
    errorMessage = null;
    _event = null;
    _attendanceData = null;
    _listAttendees = null;
    _eventStatus = ResponseStatus.initial;
    _attendanceStatus = ResponseStatus.initial;
    _listAttendeesStatus = ResponseStatus.initial;
    _updateAttendeesStatus = ResponseStatus.initial;
    notifyListeners();
  }

  void resetAttendanceStatus() {
    _attendanceStatus = ResponseStatus.initial;
    errorMessage = null;
    notifyListeners();
  }

  void resetAttendanceState() {
    _attendanceData = null;
    notifyListeners();
  }

  Future<void> getEventById(token, eventId) async {
    _setEventStatus(ResponseStatus.loading);

    final result = await getEventByIdUsecase.execute(token, eventId);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        print(errorMessage);
        _setEventStatus(ResponseStatus.error);
      },
      (event) {
        _event = event;
        print(event);
        _setEventStatus(ResponseStatus.success);
      },
    );
  }

  // Future<void> scanAttendance(token, eventId, code) async {
  //   setAttendanceStatus(ResponseStatus.loading);

  //   final result = await scanAttendanceUsecase.execute(token, eventId, code);

  //   result.fold(
  //     (failure) {
  //       errorMessage = failure.message;
  //       setAttendanceStatus(ResponseStatus.error);
  //     },
  //     (attendance) {
  //       _attendanceData = attendance;
  //       setAttendanceStatus(ResponseStatus.success);
  //     },
  //   );
  // }

  Future<void> scanAttendance(
    String token,
    int eventId,
    String attendeeId,
  ) async {
    setAttendanceStatus(ResponseStatus.loading);

    if (attendeeId.isEmpty) {
      errorMessage = "Invalid QR code";
      setAttendanceStatus(ResponseStatus.error);
      return;
    }

    await processAttendance(token, eventId, attendeeId);
  }

  // Helper method to process the attendance API call
  Future<void> processAttendance(
    String token,
    int eventId,
    String attendeeId,
  ) async {
    final result = await scanAttendanceUsecase.execute(
      token,
      eventId,
      attendeeId,
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        setAttendanceStatus(ResponseStatus.error);
      },
      (attendanceData) {
        _attendeeIdentity = null;

        _attendanceData = attendanceData;
        setAttendanceStatus(ResponseStatus.success);
      },
    );
  }

  Future<void> scanIdentityCheck(token, eventId, code) async {
    setAttendanceStatus(ResponseStatus.loading);

    final result = await scanIdentityCheckUsecase.execute(token, eventId, code);

    result.fold(
      (failure) {
        errorMessage = failure.message;
        print('error scan-identity: $errorMessage');
        setAttendanceStatus(ResponseStatus.error);
      },
      (attendance) {
        _attendanceData = null;
        _attendeeIdentity = attendance;
        print('success scan-identity: $_attendeeIdentity');
        setAttendanceStatus(ResponseStatus.success);
      },
    );
  }

  Future<void> getEventAttendees(token, eventId) async {
    _setListAttendeesStatus(ResponseStatus.loading);

    final result = await getEventAttendeesUsecase.execute(token, eventId);

    result.fold(
      (failure) {
        errorMessage = failure.message;

        print('error loading attendees at provider: $errorMessage');

        _setListAttendeesStatus(ResponseStatus.error);
      },
      (attendees) {
        _listAttendees = attendees;
        _setListAttendeesStatus(ResponseStatus.success);
      },
    );
  }

  Future<void> updateAttendees(
    token,
    eventId,
    List<Map<String, dynamic>> attendeesData,
  ) async {
    _setUpdateAttendeesStatus(ResponseStatus.loading);

    final result = await updateAttendeesStatusUsecase.execute(
      token,
      eventId,
      attendeesData,
    );

    result.fold(
      (failure) {
        errorMessage = failure.message;
        print('Update attendees error: $errorMessage');
        _setUpdateAttendeesStatus(ResponseStatus.error);
      },
      (success) {
        print('Update attendees success: $success');

        // Refresh attendees list
        getEventAttendees(token, eventId);
        _setUpdateAttendeesStatus(ResponseStatus.success);
      },
    );
  }
}
