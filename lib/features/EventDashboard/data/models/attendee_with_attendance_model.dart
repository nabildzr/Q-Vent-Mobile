import '../../domain/entities/attendee_with_attendance_entity.dart';
import 'attendance_model.dart';
import 'attendee_model.dart';

class AttendeeWithAttendanceModel extends AttendeeWithAttendanceEntity {
  const AttendeeWithAttendanceModel({
    required super.attendeeEntity,
    required super.attendanceEntity,
  });

  factory AttendeeWithAttendanceModel.fromJson(Map<String, dynamic> data) {
    return AttendeeWithAttendanceModel(
      attendeeEntity: AttendeeModel.fromJson(data),
      attendanceEntity: AttendanceModel.fromJson(data['attendance']),
    );
  }

  static List<AttendeeWithAttendanceModel> fromJsonList(List data) {
    if (data.isEmpty) return [];

    return data
        .map((singleAttendee) => AttendeeWithAttendanceModel.fromJson(singleAttendee))
        .toList();
  }
}
