import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../repositories/event_dashboard_repository.dart';

class UpdateAttendeesStatusUsecase {
  final EventDashboardRepository eventDashboardRepository;

  UpdateAttendeesStatusUsecase(this.eventDashboardRepository);

  Future<Either<Failure, bool>> execute(
    token,
   eventId,
    List<Map<String, dynamic>> attendeesData,
  ) async {
    return await eventDashboardRepository.updateAttendeesStatus(
      token,
      eventId,
      attendeesData,
    );
  }
}
