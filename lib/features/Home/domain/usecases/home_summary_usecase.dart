import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/HomeSummaryEntity.dart';
import '../repositories/home_repository.dart';

class HomeSummaryUsecase {
  final HomeRepository homeRepository;

  HomeSummaryUsecase(this.homeRepository);

  Future<Either<Failure, HomeSummaryEntity>> execute(
    String token,
  ) async {
    return homeRepository.getHomeSummary(token);
  }
}
