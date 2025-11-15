import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/HomeSummaryEntity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_local_datasource.dart';
import '../datasources/home_remote_datasource.dart';
import '../models/HomeEventHistoryModel.dart';
import '../models/HomeSummaryModel.dart';

class HomeRepositoryImplementation extends HomeRepository {
  final HomeRemoteDatasource homeRemoteDatasource;
  final HomeLocalDatasource homeLocalDatasource;
  final SharedPreferences sharedPreferences;

  HomeRepositoryImplementation({
    required this.homeRemoteDatasource,
    required this.homeLocalDatasource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, HomeSummaryEntity>> getHomeSummary(
    String token,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        HomeSummaryModel result = await homeLocalDatasource.getHomeSummary();

        print('no connection: $result');

        return Right(result);
      } else {
        HomeSummaryModel result = await homeRemoteDatasource.getHomeSummary(
          token,
        );

        print(result);

        sharedPreferences.setString('home_summary', jsonEncode(result));

        return Right(result);
      }
    } catch (e) {
      return Left(SimpleFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HomeEventHistoryModel>>> getHomeEventHistory(
    String token,
  ) async {
    try {
      final List<ConnectivityResult> connectivityResult =
          await (Connectivity().checkConnectivity());

      if (connectivityResult.contains(ConnectivityResult.none)) {
        List<HomeEventHistoryModel> result =
            await homeLocalDatasource.getHomeEventHistory();

        // print('in repo impl (no conn): $result');

        return Right(result);
      } else {
        List<HomeEventHistoryModel> result = await homeRemoteDatasource
            .getHomeEventHistory(token);

        sharedPreferences.setString('home_event_history', jsonEncode(result));

        // print('in repo impl (conn available): $result');

        return Right(result);
      }
    } catch (e) {
      print('HomeEventHistoryLogError: $e');
      return Left(SimpleFailure(e.toString()));
    }
  }
}
