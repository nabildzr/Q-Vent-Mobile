import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/HomeEventHistoryEntity.dart';
import '../repositories/home_repository.dart';

class HomeEventHistoryUsecase {
  final HomeRepository homeRepository;

  HomeEventHistoryUsecase( this.homeRepository);


  Future<Either<Failure, List<HomeEventHistoryEntity>>> execute(String token) {
    return homeRepository.getHomeEventHistory(token);
  } 
}