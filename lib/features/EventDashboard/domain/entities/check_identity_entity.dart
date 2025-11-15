import 'package:equatable/equatable.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/attendance_model.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/attendee_model.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/event_model.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/attendee.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/event_entity.dart';

import '../../domain/entities/attendance.dart';

class CheckIdentityEntity extends Equatable {
  final AttendeeEntity attendee;
  final AttendanceEntity attendances;
  final EventEntity event;
  final String message;
  final bool success;

  const CheckIdentityEntity({
    required this.event,
    required this.attendee,
    required this.attendances,
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [attendee, attendances, event, message, success];
}
