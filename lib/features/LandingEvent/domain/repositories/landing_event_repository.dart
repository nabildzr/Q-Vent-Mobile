import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/event_entity.dart';

abstract class LandingEventRepository {
  Future<Either<Failure, List<EventEntity>>> getEventUpcoming(
    String token,
    int userId,
  );
  Future<Either<Failure, List<EventEntity>>> getEventOngoing(
    String token,
    int userId,
  );
  Future<Either<Failure, List<EventEntity>>> getEventPast(
    String token,
    int userId,
  );
}
