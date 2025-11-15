import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/HomeEventHistoryEntity.dart';
import '../entities/HomeSummaryEntity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeSummaryEntity>> getHomeSummary(String token);
  Future<Either<Failure, List<HomeEventHistoryEntity>>> getHomeEventHistory(String token); 
}