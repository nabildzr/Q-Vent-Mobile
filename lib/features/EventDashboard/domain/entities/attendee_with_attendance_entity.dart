import 'package:equatable/equatable.dart';

import 'attendance.dart';
import 'attendee.dart';

class AttendeeWithAttendanceEntity extends Equatable {
  final AttendeeEntity attendeeEntity;
  final AttendanceEntity attendanceEntity;

  const AttendeeWithAttendanceEntity({
    required this.attendeeEntity,
    required this.attendanceEntity,
  });
  
  @override
  List<Object?> get props => [attendeeEntity, attendanceEntity];
}
