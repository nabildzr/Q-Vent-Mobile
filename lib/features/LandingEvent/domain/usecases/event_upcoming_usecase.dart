import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/event_entity.dart';
import '../repositories/landing_event_repository.dart';

class LandingEventUpcomingUsecase {
  final LandingEventRepository landingEventRepository;

  LandingEventUpcomingUsecase(this.landingEventRepository);

  Future<Either<Failure, List<EventEntity>>> execute(
    String token,
    int userId,
  ) {
    return landingEventRepository.getEventUpcoming(token, userId);
  }
}
