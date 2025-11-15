import 'package:qr_event_management/features/EventDashboard/data/models/attendance_model.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/attendee_model.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/event_model.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/check_identity_entity.dart';


class CheckIdentityModel extends CheckIdentityEntity {
  const CheckIdentityModel({
    required super.event,
    required super.attendee,
    required super.attendances,
    required super.message,
    required super.success,
  });

  factory CheckIdentityModel.fromJson(Map<String, dynamic> data) {
    return CheckIdentityModel(
      event: EventModel.fromJson(data['data']['primary_event']),
      message: data['message'] ?? '',
      success: data['success'] ?? false,
      attendee: AttendeeModel.fromJson(data['data']['attendee']),
      attendances: AttendanceModel.fromJson(data['data']['attendances']),
    );
  }
}
