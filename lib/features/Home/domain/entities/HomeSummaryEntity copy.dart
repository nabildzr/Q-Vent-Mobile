import 'package:equatable/equatable.dart';

class HomeSummaryEntity extends Equatable {
  final int pastCount;
  final String upcomingEvent;
  final int currentMonthCount;

  const HomeSummaryEntity({
    required this.pastCount,
    required this.upcomingEvent,
    required this.currentMonthCount,
  });

  @override
  List<Object?> get props => [pastCount, upcomingEvent, currentMonthCount];
}
