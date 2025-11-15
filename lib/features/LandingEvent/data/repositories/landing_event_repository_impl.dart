import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/repositories/landing_event_repository.dart';
import '../datasources/landing_event_local_datasource.dart';
import '../datasources/landing_event_remote_datasource.dart';

class LandingEventRepositoryImplementation implements LandingEventRepository {
  final LandingEventLocalDatasource landingEventLocalDatasource;
  final LandingEventRemoteDataSource landingEventRemoteDataSource;
  final SharedPreferences sharedPreferences;

  LandingEventRepositoryImplementation(
    this.sharedPreferences, {
    required this.landingEventLocalDatasource,
    required this.landingEventRemoteDataSource,
  });

  @override
  Future<Either<Failure, List<EventEntity>>> getEventOngoing(
    String token,
    int userId,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        List<EventEntity> result =
            await landingEventLocalDatasource.getEventOngoing();

        print('event ongoing local: $result');

        return Right(result);
      } else {
        List<EventEntity> result = await landingEventRemoteDataSource
            .getEventOngoing(token, userId);

        sharedPreferences.setString(
          'landing_event_ongoing_cache',
          jsonEncode(result),
        );

        return Right(result);
      }
    } catch (e) {
      return Left(SimpleFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEventPast(
    String token,
    int userId,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        List<EventEntity> result =
            await landingEventLocalDatasource.getEventPast();

        return Right(result);
      } else {
        List<EventEntity> result = await landingEventRemoteDataSource
            .getEventPast(token, userId);

        sharedPreferences.setString(
          'landing_event_past_cache',
          jsonEncode(result),
        );

        return Right(result);
      }
    } catch (e) {
      return Left(SimpleFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<EventEntity>>> getEventUpcoming(
    String token,
    int userId,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        List<EventEntity> result =
            await landingEventLocalDatasource.getEventUpcoming();

        return Right(result);
      } else {
        List<EventEntity> result = await landingEventRemoteDataSource
            .getEventUpcoming(token, userId);

        sharedPreferences.setString(
          'landing_event_upcoming_cache',
          jsonEncode(result),
        );

        return Right(result);
      }
    } on EmptyException catch (e) {
      return Left(GeneralFailure(e.toString()));
    } catch (e) {
      return Left(GeneralFailure(e.toString()));
    }
  }
}
