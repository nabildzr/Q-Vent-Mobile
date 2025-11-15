import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../entities/list_attendees_entity.dart';
import '../repositories/event_dashboard_repository.dart';

class GetEventAttendeesUsecase {
  final EventDashboardRepository eventDashboardRepository;

  GetEventAttendeesUsecase(this.eventDashboardRepository);

  Future<Either<Failure, ListAttendeesEntity>> execute(token, eventId) async {
    return await eventDashboardRepository.getEventAttendees(token, eventId);
  }
}