import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/event_entity.dart';
import '../repositories/landing_event_repository.dart';

class LandingEventPastUsecase {
  final LandingEventRepository landingEventRepository;

  LandingEventPastUsecase(this.landingEventRepository);

  Future<Either<Failure, List<EventEntity>>> execute(String token, int userId) {
    return landingEventRepository.getEventPast(token, userId);
  }
}