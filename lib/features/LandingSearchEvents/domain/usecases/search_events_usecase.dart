import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/search_event_entity.dart';
import '../repositories/search_events_repository.dart';

class SearchEventsUsecase {
  final SearchEventsRepository searchEventRepository;

  SearchEventsUsecase(this.searchEventRepository);

  Future<Either<Failure, List<SearchEventEntity>>> execute(
    String token,
    int userId,
    String query,
  ) async {
    return await searchEventRepository.searchEvents(token, userId,query);
  }
}
