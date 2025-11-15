import 'package:dartz/dartz.dart';
import 'package:qr_event_management/features/EventDashboard/domain/entities/check_identity_entity.dart';

import '../../../../core/error/failure.dart';
import '../repositories/event_dashboard_repository.dart';

class ScanIdentityCheckUsecase {
  final EventDashboardRepository eventDashboardRepository;

  ScanIdentityCheckUsecase(this.eventDashboardRepository);

  Future<Either<Failure, CheckIdentityEntity>> execute(
    token,
    eventId,
    code,
  ) async {
    return await eventDashboardRepository.scanIdentityCheck(token, eventId, code);
  }
}
