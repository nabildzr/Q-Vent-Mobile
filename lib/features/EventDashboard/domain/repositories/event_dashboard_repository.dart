import 'package:dartz/dartz.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/check_identity_model.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/check_identity_entity.dart';

import '../../../../core/error/failure.dart';
import '../entities/attendance_data_entity.dart';
import '../entities/event_entity.dart';
import '../entities/list_attendees_entity.dart';

abstract class EventDashboardRepository {
  Future<Either<Failure, EventEntity>> getEventById(token, eventId);
  Future<Either<Failure, AttendanceDataEntity>> scanAttendance(
    token,
    eventId,
    code,
  );
  Future<Either<Failure, CheckIdentityEntity>> scanIdentityCheck(
    token,
    eventId,
    code,
  );
  Future<Either<Failure, ListAttendeesEntity>> getEventAttendees(
    token,
    eventId,
  );
  Future<Either<Failure, bool>> updateAttendeesStatus(
    token,
    eventId,
    List<Map<String, dynamic>> attendeesData,
  );
}
