import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/search_event_entity.dart';
import '../../domain/repositories/search_events_repository.dart';
import '../datasources/search_events_local_datasource.dart';
import '../datasources/search_events_remote_datasource.dart';

class SearchEventsRepositoryImplementation implements SearchEventsRepository {
  final SearchEventsRemoteDatasource searchEventsRemoteDatasource;
  final SearchEventsLocalDatasource searchEventsLocalDatasource;
  final SharedPreferences sharedPreferences;

  SearchEventsRepositoryImplementation({
    required this.searchEventsRemoteDatasource,
    required this.searchEventsLocalDatasource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<SearchEventEntity>>> searchEvents(
    String token,
    int userId,
    String query,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        List<SearchEventEntity> result =
            await searchEventsLocalDatasource.searchEvents();

        return Right(result);
      } else {
        List<SearchEventEntity> result = await searchEventsRemoteDatasource
            .searchEvents(token: token, userId: userId, query: query);

        sharedPreferences.setString(
          'search_landing_events_cache',
          jsonEncode(result),
        );

        return Right(result);
      }
    } catch (e) {
      print("error after search event: $e");
      throw Left(GeneralFailure(e.toString()));
    }
  }
}
