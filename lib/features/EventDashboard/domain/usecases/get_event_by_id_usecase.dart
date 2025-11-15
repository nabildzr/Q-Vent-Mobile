import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/event_entity.dart';
import '../repositories/event_dashboard_repository.dart';

class GetEventByIdUsecase {
  final EventDashboardRepository eventDashboardRepository;

  GetEventByIdUsecase(this.eventDashboardRepository);

  Future<Either<Failure, EventEntity>> execute(token, eventId) async {
    return await eventDashboardRepository.getEventById(token, eventId);
  }
}
