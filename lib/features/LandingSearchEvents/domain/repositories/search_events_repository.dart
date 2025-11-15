import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/search_event_entity.dart';

abstract class SearchEventsRepository {
  Future<Either<Failure, List<SearchEventEntity>>> searchEvents(
    String token,
    int userId,
    String query,
  );
}
