import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:qr_event_management/features/EventDashboard/data/models/check_identity_model.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/check_identity_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/attendance_data_entity.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/list_attendees_entity.dart';
import '../../domain/repositories/event_dashboard_repository.dart';
import '../datasources/event_dashboard_remote_datasource.dart';

class EventDashboardRepositoryImplementation
    implements EventDashboardRepository {
  final SharedPreferences sharedPreferences;
  final EventDashboardRemoteDatasource eventDashboardRemoteDatasource;

  EventDashboardRepositoryImplementation({
    required this.sharedPreferences,
    required this.eventDashboardRemoteDatasource,
  });

  @override
  Future<Either<Failure, EventEntity>> getEventById(token, eventId) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        final result = await eventDashboardRemoteDatasource.getEventById(
          token,
          eventId,
        );

        return Right(result);
      } else {
        final result = await eventDashboardRemoteDatasource.getEventById(
          token,
          eventId,
        );

        return Right(result);
      }
    } catch (e) {
      return Left(SimpleFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AttendanceDataEntity>> scanAttendance(
    token,
    eventId,
    code,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return Left(ConnectionFailure('No connection available.'));
      } else {
        AttendanceDataEntity result = await eventDashboardRemoteDatasource
            .scanAttendance(token, eventId, code);

        return Right(result);
      }
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CheckIdentityEntity>> scanIdentityCheck(
    token,
    eventId,
    code,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return Left(ConnectionFailure('No connection available.'));
      } else {
        CheckIdentityEntity result = await eventDashboardRemoteDatasource
            .scanIdentityCheck(token, eventId, code);

        return Right(result);
      }
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ListAttendeesEntity>> getEventAttendees(
    token,
    eventId,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return Left(ConnectionFailure('No connection available.'));
      } else {
        ListAttendeesEntity result = await eventDashboardRemoteDatasource
            .getEventAttendees(token, eventId);

        print(
          'from event dashboard - repository implementation - get-event-attendee: $result',
        );

        return Right(result);
      }
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateAttendeesStatus(
   token,
 eventId,
    List<Map<String, dynamic>> attendeesData,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        return Left(ConnectionFailure('No connection available.'));
      } else {
        bool result = await eventDashboardRemoteDatasource
            .updateAttendeesStatus(token, eventId, attendeesData);

        print('Repository: Update attendees status result: $result');
        return Right(result);
      }
    } catch (e) {
      print('Repository: Update attendees error: $e');
      return Left(GeneralFailure(e.toString()));
    }
  }
}
