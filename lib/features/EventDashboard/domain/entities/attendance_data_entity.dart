import 'package:equatable/equatable.dart';
import 'attendance.dart';
import 'attendee.dart';

class AttendanceDataEntity extends Equatable {
  final bool success;
  final String message;
  final String qrCode;
  final AttendanceEntity attendanceEntity;
  final AttendeeEntity attendeeEntity;

  const AttendanceDataEntity( {
    required this.attendanceEntity,
    required this.attendeeEntity,
    required this.success,
    required this.message,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [success, message, qrCode ,attendanceEntity, attendeeEntity];
}